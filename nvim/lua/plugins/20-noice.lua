local function scroll_lsp_popups(key, scroll_height)
  return {
    key,
    function()
      if not require("noice.lsp").scroll(scroll_height) then
        return key
      end
    end,
    mode = { "n", "i", "s" },
    silent = true,
    expr = true,
  }
end

local M = {
  "folke/noice.nvim",
  event = "VeryLazy",
  cmd = { "Noice" },
  cond = not vim.g.started_by_firenvim,
  dependencies = {
    "nui.nvim",
    "nvim-notify",
  },
  keys = {
    { "<Leader>n", "<Cmd>Noice history<CR>", silent = true },
    {
      "<Leader>N",
      function()
        require("noice").redirect("Notifications")
      end,
      desc = "Noice Notifications",
    },
    -- scroll lsp popups
    scroll_lsp_popups("<C-f>", 4),
    scroll_lsp_popups("<C-b>", -4),
  },
}

M.init = function()
  local function lhs_lower(lhs)
    return require("telescope.utils").display_termcodes(
      string.gsub(lhs, [[(<..->)]], string.lower):gsub("<leader>", vim.g.mapleader or "\\")
    )
  end
  local function get_maps(m, filter)
    if m == nil or m == "" then
      m = "n"
    end
    local result_string = { string.format("GET MAPS: mode = %s, filter = '%s'", m, filter) }
    local keymaps = vim.list_extend(vim.api.nvim_get_keymap(m), vim.api.nvim_buf_get_keymap(0, m)) ---@diagnostic disable-line
    local results = {
      keys = { "mode", "lhs", "type", "rhs", "desc" },
      format = { "%s", "'%s'", "%s", "%s", "%s" },
      add_row = function(self, row, format)
        local res, fmt = {}, vim.tbl_extend("force", self.format, format or {})
        for i, key in ipairs(self.keys) do
          res[i] = string.format(fmt and fmt[i] or "%s", row[i])
          self[key] = math.min(math.max(self[key] or 0, string.len(res[i])), 40)
        end
        self[#self + 1] = res
      end,
      print_row = function(self, row)
        local res = {}
        for i, key in ipairs(self.keys) do
          res[i] = row[i] .. string.rep(" ", self[key] - string.len(row[i]))
        end
        return res
      end,
    }
    results:add_row(results.keys, vim.split(string.rep([['%s' ]], #results.keys), " ", {}))
    for _, map in ipairs(keymaps) do
      local lhs = lhs_lower(map.lhs)
      if filter == nil or type(map.lhs) ~= "string" or string.match(lhs, lhs_lower(filter)) then
        local maptype, rhs, desc = "vim", vim.inspect(map.rhs), map.desc or ""
        if map.callback ~= nil then
          maptype = "lua"
          rhs = require("telescope.actions.utils")._get_anon_function_name(debug.getinfo(map.callback))
          rhs = string.gsub(rhs, "<anonymous>", "LUA: " .. desc)
        end
        if not string.match(lhs, "<plug>") then
          results:add_row({ m, lhs, maptype, rhs, desc })
        end
      end
    end
    if #results > 1 then
      for _, row in ipairs(results) do
        result_string[#result_string + 1] = table.concat(results:print_row(row), " ")
      end
    else
      result_string[#result_string + 1] = "None"
    end
    print(table.concat(result_string, "\n"))
  end
  -- HACK: Workaround for https://github.com/folke/noice.nvim/issues/77
  vim.api.nvim_create_user_command("Map", function(cmd)
    local mode, filter = nil, nil
    if cmd.fargs ~= nil then
      mode = #cmd.fargs >= 1 and cmd.fargs[1] or "n"
      filter = #cmd.fargs >= 2 and cmd.fargs[2] or nil
    end
    get_maps(mode, filter)
  end, { force = true, nargs = "*" })
  for _, mode in ipairs({ "n", "i", "c", "v", "x", "s", "o", "t", "l" }) do
    vim.api.nvim_create_user_command(mode:upper() .. "Map", function(cmd)
      local filter = nil
      if cmd.fargs ~= nil then
        filter = #cmd.fargs >= 1 and cmd.fargs[1] or nil
      end
      get_maps(mode, filter)
    end, { force = true, nargs = "*" })
  end
end

M.opts = {
  messages = {
    enabled = true,
    view = "notify",
    view_error = "notify",
    view_warn = "notify",
    view_history = "messages",
    view_search = false,
  },
  health = { checker = false },
  lsp = {
    progress = { enabled = false },
    override = {
      ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
      ["vim.lsp.util.stylize_markdown"] = true,
      ["cmp.entry.get_documentation"] = true,
    },
    hover = { enabled = true },
    signature = { enabled = true },
  },
  presets = {
    bottom_search = false,
    command_palette = true,
    long_message_to_split = true,
    inc_rename = true,
    lsp_doc_border = true,
  },
  routes = {
    { -- route long messages to split
      filter = {
        event = "msg_show",
        any = { { min_height = 5 }, { min_width = 200 } },
        ["not"] = {
          kind = { "confirm", "confirm_sub", "return_prompt", "quickfix", "search_count" },
        },
        blocking = false,
      },
      view = "messages",
      opts = { stop = true },
    },
    { -- route long messages to split
      filter = {
        event = "msg_show",
        any = { { min_height = 5 }, { min_width = 200 } },
        ["not"] = {
          kind = { "confirm", "confirm_sub", "return_prompt", "quickfix", "search_count" },
        },
        blocking = true,
      },
      view = "mini",
    },
    { -- hide `written` message
      filter = {
        event = "msg_show",
        kind = "",
        find = "written",
      },
      opts = { skip = true },
    },
    { -- send annoying msgs to mini
      filter = {
        event = "msg_show",
        any = {
          { find = "; after #%d+" },
          { find = "; before #%d+" },
          { find = "fewer lines" },
        },
      },
      view = "mini",
    },
  },
  views = {
    split = {
      win_options = { wrap = false },
      size = 16,
      close = { keys = { "q", "<CR>", "<Esc>" } },
    },
    popup = {
      win_options = { wrap = false },
    },
  },
}

return M
