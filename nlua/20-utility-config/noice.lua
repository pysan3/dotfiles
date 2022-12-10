require("noice").setup({
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
})

vim.api.nvim_set_keymap("n", "<Leader>n", "<Cmd>Noice history<CR>", {})

-- HACK: Workaround for https://github.com/folke/noice.nvim/issues/77
local get_maps = function(mode, filter)
  if mode == nil or mode == "" then mode = "n" end
  local result = string.format("get_maps: mode = %s, filter = '%s'", mode, filter)
  local keymaps = {}
  keymaps = vim.list_extend(keymaps, vim.api.nvim_get_keymap(mode)) ---@diagnostic disable-line
  keymaps = vim.list_extend(keymaps, vim.api.nvim_buf_get_keymap(0, mode)) ---@diagnostic disable-line
  for _, map in ipairs(keymaps) do
    local maptype, rhs = "rhs", map.rhs
    if map.callback ~= nil then
      maptype = "callback"
      rhs = map.callback
    end
    local append = false
    if type(map.lhs) == "string" and string.find(string.lower(map.lhs), "<plug>") then
      -- pass
    elseif type(rhs) == "string" and string.find(string.lower(rhs), "<plug>") then
      -- pass
    elseif filter == nil then
      append = true
    elseif type(map.lhs) ~= "string" then
      append = true
    elseif string.match(string.lower(map.lhs), string.gsub(filter, "<leader>", " ")) then
      append = true
    end
    if append then
      result = string.format([[%s
%s    '%s'    %s    %s    <%s>]], result, mode, map.lhs, maptype, rhs, map.desc or "")
    end
  end
  print(result)
end

vim.api.nvim_create_user_command("Map", function(cmd)
  local mode, filter = nil, nil
  if cmd.fargs ~= nil then
    mode = #cmd.fargs >= 1 and cmd.fargs[1] or "n"
    filter = #cmd.fargs >= 2 and cmd.fargs[2] or nil
  end
  get_maps(mode, filter)
end, { force = true, nargs = "*" })
