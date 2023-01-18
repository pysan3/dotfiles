local function lhs_lower(lhs)
  return require("telescope.utils").display_termcodes(
    string.gsub(lhs, [[(<..->)]], string.lower):gsub("<leader>", vim.g.mapleader or "\\")
  )
end

local function get_maps(mode, filter)
  if mode == nil or mode == "" then mode = "n" end
  print(string.format("GET MAPS: mode = %s, filter = '%s'", mode, filter))
  local keymaps = vim.list_extend(vim.api.nvim_get_keymap(mode), vim.api.nvim_buf_get_keymap(0, mode))
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
  results:add_row(results.keys, vim.split(string.rep([['%s' ]], #results.keys), " "))

  for _, map in ipairs(keymaps) do
    local lhs = lhs_lower(map.lhs)
    if filter == nil or type(map.lhs) ~= "string" or
        string.match(lhs, lhs_lower(filter)) then
      local maptype, rhs, desc = "vim", vim.inspect(map.rhs), map.desc or ""
      if map.callback ~= nil then
        maptype = "lua"
        rhs = require("telescope.actions.utils")._get_anon_function_name(map.callback)
            :gsub("<anonymous>", "LUA: " .. desc)
      end
      if not string.match(lhs, "<plug>") then
        results:add_row({ mode, lhs, maptype, rhs, desc })
      end
    end
  end
  for _, row in ipairs(results) do
    print(table.concat(results:print_row(row), " "))
  end
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

return {
  "folke/noice.nvim",
  event = "VeryLazy",
  cmd = { "Noice" },
  enabled = not vim.g.started_by_firenvim,
  dependencies = {
    "MunifTanjim/nui.nvim",
    "rcarriga/nvim-notify",
  },
  keys = {
    { "<Leader>n", "<Cmd>Noice history<CR>", silent = true },
  },
  config = {
    messages = {
      enabled = true,
      view = "notify", -- default view for messages
      view_error = "notify", -- view for errors
      view_warn = "notify", -- view for warnings
      view_history = "messages", -- view for :messages
    },
    health = { checker = false },
    lsp = {
      progress = { enabled = false },
      override = {},
      hover = { enabled = false },
      signature = { enabled = false },
      message = { enabled = false },
    },
    presets = {
      bottom_search = false, -- use a classic bottom cmdline for search
      command_palette = true, -- position the cmdline and popupmenu together
      long_message_to_split = false, -- long messages will be sent to a split
      inc_rename = false, -- enables an input dialog for inc-rename.nvim
      lsp_doc_border = false, -- add a border to hover docs and signature help
    },
    routes = {
      { -- route long messages to split
        filter = {
          event = "msg_show",
          any = { { min_height = 5 }, { min_width = 200 } },
          ["not"] = {
            kind = { "confirm", "confirm_sub", "return_prompt", "quickfix" },
          },
        },
        view = "messages",
        opts = { stop = true },
      },
    },
    views = {
      split = {
        win_options = { wrap = false },
        size = 16,
        close = { keys = { "q", "<CR>", "<Esc>" } },
      },
    },
  }
}
