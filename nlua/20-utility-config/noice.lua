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
      filter = { event = "msg_show", min_height = 5 },
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
