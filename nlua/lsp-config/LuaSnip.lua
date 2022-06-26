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

-- Command to edit snippets of the current file
local snippet_file_infos = {
  snipmate = {
    prefix = vim.fn.stdpath("config") .. "/snippets",
    ext = "snippets",
  },
  lua = {
    prefix = vim.fn.stdpath("config") .. "/lua/snippets",
    ext = "lua",
  },
}
local function edit_snippet_files(sniptype, ft)
  local file_found = nil
  require("luasnip.loaders").edit_snippet_files({
    format = function(file, source_name)
      if source_name ~= sniptype or string.find(file, "site") then
        return nil
      end
      file_found = file
      return file_found
    end,
  })
  if file_found == nil then
    file_found = snippet_file_infos[sniptype].prefix .. "/" .. ft .. "." .. snippet_file_infos[sniptype].ext
    vim.notify("Create new snippet file for " .. ft .. " at " .. file_found)
    vim.cmd("edit " .. file_found)
  end
  return file_found
end
vim.api.nvim_create_user_command("LsEditSnip", function()
  edit_snippet_files("snipmate", vim.bo.filetype)
end, {})
vim.api.nvim_create_user_command("LsEditLua", function()
  edit_snippet_files("lua", vim.bo.filetype)
end, {})

-- Virtual Text
local types = require("luasnip.util.types")
luasnip.config.set_config({
  ext_opts = {
    [types.choiceNode] = {
      active = {
        virt_text = { { "o", "GruvboxOrange" } },
      },
    },
  },
})

-- LuaSnip startup config
local util = require("luasnip.util.util")
luasnip.config.setup({
  -- extend ft snippets to load
  load_ft_func = require("luasnip.extras.filetype_functions").extend_load_ft({
    c = { "cpp" },
    markdown = { "lua", "json", "html" },
    html = { "css", "javascript" },
    typescript = { "javascript" },
    all = { "_" },
  }),
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
  local buf_text = {}
  local row_selection = 0
  local row_offset = 0
  local text
  for _, node in ipairs(choiceNode.choices) do
    text = node:get_docstring()
    -- find one that is currently showing
    if node == choiceNode.active_choice then
      -- current line is starter from buffer list which is length usually
      row_selection = #buf_text
      -- finding how many lines total within a choice selection
      row_offset = #text
    end
    vim.list_extend(buf_text, text)
  end

  vim.api.nvim_buf_set_text(buf, 0, 0, 0, 0, buf_text)
  local w, h = vim.lsp.util._make_floating_popup_size(buf_text)

  -- adding highlight so we can see which one is been selected.
  local extmark = vim.api.nvim_buf_set_extmark(
    buf,
    current_nsid,
    row_selection,
    0,
    { hl_group = "incsearch", end_line = row_selection + row_offset }
  )

  -- shows window at a beginning of choiceNode.
  local win = vim.api.nvim_open_win(buf, false, {
    relative = "win",
    width = w,
    height = h,
    bufpos = choiceNode.mark:pos_begin_end(),
    style = "minimal",
    border = "rounded",
  })

  -- return with 3 main important so we can use them again
  return { win_id = win, extmark = extmark, buf = buf }
end

function LuaSnipChoicePopup(choiceNode)
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

function LuaSnipUpdateChoicePopup(choiceNode)
  vim.api.nvim_win_close(current_win.win_id, true)
  vim.api.nvim_buf_del_extmark(current_win.buf, current_nsid, current_win.extmark)
  local create_win = window_for_choiceNode(choiceNode)
  current_win.win_id = create_win.win_id
  current_win.extmark = create_win.extmark
  current_win.buf = create_win.buf
end

function LuaSnipChoicePopupClose()
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

vim.cmd([[
augroup LuaSnipChoicePopup
  autocmd!
  autocmd User LuasnipChoiceNodeEnter lua LuaSnipChoicePopup(require("luasnip").session.event_node)
  autocmd User LuasnipChoiceNodeLeave lua LuaSnipChoicePopupClose()
  autocmd User LuasnipChangeChoice lua LuaSnipUpdateChoicePopup(require("luasnip").session.event_node)
augroup END
]])
