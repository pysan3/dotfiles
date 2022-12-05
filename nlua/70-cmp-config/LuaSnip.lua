local luasnip = require("luasnip")

require("luasnip.loaders.from_snipmate").lazy_load()
require("luasnip.loaders.from_vscode").lazy_load()

-- manually load snippets from `molleweide/LuaSnip-snippets.nvim`
require("luasnip.loaders.from_lua").lazy_load({
  paths = vim.api.nvim_get_runtime_file("lua/luasnip_snippets/snippets", false),
})
require("luasnip.loaders.from_lua").lazy_load({
  paths = vim.fn.stdpath("config") .. "/lua/snippets",
})

-- LuaSnip startup config
local util = require("luasnip.util.util")
luasnip.config.setup({
  region_check_events = "InsertEnter,CursorMoved", -- "CursorMoved", "CursorHold", "InsertEnter"
  delete_check_events = "TextChanged,CursorMoved",
  -- extend ft snippets to load
  load_ft_func = require("luasnip.extras.filetype_functions").extend_load_ft({
    c = { "cpp" },
    markdown = { "lua", "json", "html" },
    html = { "css", "javascript" },
    typescript = { "javascript" },
    all = { "_" },
  }),
  ext_opts = {
    [require("luasnip.util.types").choiceNode] = {
      active = {
        virt_text = { { "o", "GruvboxOrange" } },
      },
    },
  },
  -- allow nested snippet placeholders
  parser_nested_assembler = function(_, snippet)
    local select = function(snip, no_move)
      snip.parent:enter_node(snip.indx)
      for _, node in ipairs(snip.nodes) do
        node:set_mark_rgrav(true, true)
      end
      if not no_move then
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", true)
        local pos_begin, pos_end = snip.mark:pos_begin_end()
        util.normal_move_on(pos_begin)
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("v", true, false, true), "n", true)
        util.normal_move_before(pos_end)
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("o<C-G>", true, false, true), "n", true)
      end
    end
    function snippet:jump_into(dir, no_move)
      if self.active then
        if dir == 1 then
          self:input_leave()
          return self.next:jump_into(dir, no_move)
        else
          select(self, no_move)
          return self
        end
      else
        self:input_enter()
        if dir == 1 then
          select(self, no_move)
          return self
        else
          return self.inner_last:jump_into(dir, no_move)
        end
      end
    end

    function snippet:jump_from(dir, no_move)
      if dir == 1 then
        return self.inner_first:jump_into(dir, no_move)
      else
        self:input_leave()
        return self.prev:jump_into(dir, no_move)
      end
    end

    return snippet
  end,
})

-- ChoiceNode-Popup
-- https://github.com/L3MON4D3/LuaSnip/wiki/Misc#choicenode-popup
local current_nsid = vim.api.nvim_create_namespace("LuaSnipChoiceListSelections")
local current_win = nil

local function window_for_choiceNode(choiceNode)
  local buf = vim.api.nvim_create_buf(false, true)
  local buf_text, buf_text_tmp = {}, {}
  local row_selection, row_offset = 0, 0
  for i, node in ipairs(choiceNode.choices) do
    local text = node:get_docstring()
    if node == choiceNode.active_choice then
      row_selection = i
      row_offset = #text
    end
    vim.list_extend(buf_text_tmp, text, 1, #text)
  end
  local w, h = vim.lsp.util._make_floating_popup_size(buf_text_tmp, {})
  for _, text in ipairs(buf_text_tmp) do
    local lines = {}
    for line in string.gmatch(text ~= "" and text or " ", "[^\n]+") do
      table.insert(lines, line .. string.rep(" ", w - string.len(line)))
    end
    table.insert(buf_text, table.concat(lines, "\n"))
  end
  vim.api.nvim_buf_set_text(buf, 0, 0, 0, 0, buf_text)

  -- adding highlight so we can see which one is been selected.
  local extmark = vim.api.nvim_buf_set_extmark(
    buf,
    current_nsid,
    row_selection - 1, -- row_selection is 0-indexed
    0,
    { hl_group = "DiffAdd", end_row = row_selection + row_offset - 1 }
  )

  -- shows window at a beginning of choiceNode.
  local win = vim.api.nvim_open_win(buf, false, {
    relative = "win",
    width = w,
    height = h,
    bufpos = choiceNode.mark:pos_begin_end(),
    row = h > 2 and 0 or 1,
    col = h > 2 and vim.fn.max(vim.opt.colorcolumn:get()) - vim.fn.getcurpos()[3] - w - 1 or 1, -- snippet selection window on color column if more than one line
    style = "minimal",
    border = "rounded",
  })

  -- return with 3 main important so we can use them again
  return { win_id = win, extmark = extmark, buf = buf }
end

local function choice_popup(choiceNode)
  -- build stack for nested choiceNodes.
  if current_win then
    vim.api.nvim_win_close(current_win.win_id, true)
    vim.api.nvim_buf_del_extmark(current_win.buf, current_nsid, current_win.extmark)
  end
  local create_win = window_for_choiceNode(choiceNode)
  current_win = {
    win_id = create_win.win_id,
    prev = current_win,
    node = choiceNode,
    extmark = create_win.extmark,
    buf = create_win.buf,
  }
end

local function update_choice_popup(choiceNode)
  vim.api.nvim_win_close(current_win.win_id, true)
  vim.api.nvim_buf_del_extmark(current_win.buf, current_nsid, current_win.extmark)
  local create_win = window_for_choiceNode(choiceNode)
  current_win.win_id = create_win.win_id
  current_win.extmark = create_win.extmark
  current_win.buf = create_win.buf
end

local function choice_popup_close()
  vim.api.nvim_win_close(current_win.win_id, true)
  vim.api.nvim_buf_del_extmark(current_win.buf, current_nsid, current_win.extmark)
  -- now we are checking if we still have previous choice we were in after exit nested choice
  current_win = current_win.prev
  if current_win then
    -- reopen window further down in the stack.
    local create_win = window_for_choiceNode(current_win.node)
    current_win.win_id = create_win.win_id
    current_win.extmark = create_win.extmark
    current_win.buf = create_win.buf
  end
end

vim.api.nvim_create_user_command("LsChoicePopup", function()
  choice_popup(luasnip.session.event_node)
end, {})
vim.api.nvim_create_user_command("LsChoicePopupClose", function()
  choice_popup_close()
end, {})
vim.api.nvim_create_user_command("LsUpdateChoicePopup", function()
  update_choice_popup(luasnip.session.event_node)
end, {})
vim.cmd([[
augroup LuaSnipChoicePopup
  autocmd!
  autocmd User LuasnipChoiceNodeEnter LsChoicePopup
  autocmd User LuasnipChoiceNodeLeave LsChoicePopupClose
  autocmd User LuasnipChangeChoice LsUpdateChoicePopup
augroup END
]])
