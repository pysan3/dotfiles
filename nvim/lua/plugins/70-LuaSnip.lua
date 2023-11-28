local M = {
  "L3MON4D3/LuaSnip",
  dependencies = {
    { "rafamadriz/friendly-snippets" },
    { "molleweide/LuaSnip-snippets.nvim" },
    { "gisphm/vim-gitignore" },
    { "numToStr/Comment.nvim" },
  },
}

M.init = function()
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
      local file_info = snippet_file_infos[sniptype]
      file_found = file_info.prefix .. "/" .. ft .. "." .. file_info.ext
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
end

M.config = function()
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
  -- code comment presets
  require("luasnip").filetype_extend("typescript", { "tsdoc" })
  require("luasnip").filetype_extend("javascript", { "jsdoc" })
  require("luasnip").filetype_extend("lua", { "luadoc" })
  require("luasnip").filetype_extend("python", { "pydoc" })
  require("luasnip").filetype_extend("rust", { "rustdoc" })
  require("luasnip").filetype_extend("cs", { "csharpdoc" })
  require("luasnip").filetype_extend("java", { "javadoc" })
  require("luasnip").filetype_extend("c", { "cdoc" })
  require("luasnip").filetype_extend("cpp", { "cppdoc" })
  require("luasnip").filetype_extend("php", { "phpdoc" })
  require("luasnip").filetype_extend("kotlin", { "kdoc" })
  require("luasnip").filetype_extend("ruby", { "rdoc" })
  require("luasnip").filetype_extend("sh", { "shelldoc" })

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
    local win_col = math.min(
      unpack(vim.tbl_map(tonumber, vim.opt.colorcolumn:get())),
      vim.api.nvim_win_get_width(0) - vim.g.personal_options.signcolumn_length
    )
    local win = vim.api.nvim_open_win(buf, false, {
      relative = "win",
      width = w,
      height = h,
      bufpos = choiceNode.mark:pos_begin_end(),
      style = "minimal",
      border = "rounded",
      -- snippet selection window on color column if more than one line
      row = h > 1 and 0 or 1,
      col = h > 1 and (win_col - w - 3) or 1, -- 0-index and width of border
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
    if not current_win then
      return
    end
    vim.api.nvim_win_close(current_win.win_id, true)
    vim.api.nvim_buf_del_extmark(current_win.buf, current_nsid, current_win.extmark)
    local create_win = window_for_choiceNode(choiceNode)
    current_win.win_id = create_win.win_id
    current_win.extmark = create_win.extmark
    current_win.buf = create_win.buf
  end

  local function choice_popup_close()
    if not current_win then
      return
    end
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

  local choice_popup_g = vim.api.nvim_create_augroup("LuaSnipChoicePopup", { clear = true })
  vim.api.nvim_create_autocmd("User", {
    pattern = "LuasnipChoiceNodeEnter",
    group = choice_popup_g,
    callback = function(_)
      choice_popup(luasnip.session.event_node)
    end,
  })
  vim.api.nvim_create_autocmd("User", {
    pattern = "LuasnipChoiceNodeLeave",
    group = choice_popup_g,
    callback = function(_)
      choice_popup_close()
    end,
  })
  vim.api.nvim_create_autocmd("User", {
    pattern = "LuasnipChangeChoice",
    group = choice_popup_g,
    callback = function(_)
      update_choice_popup(luasnip.session.event_node)
    end,
  })
end

return M
