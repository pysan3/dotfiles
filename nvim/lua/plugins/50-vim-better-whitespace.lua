return {
  "ntpeters/vim-better-whitespace",
  event = "BufReadPost",
  cmd = { "StripWhitespace" },
  keys = {
    { "]w", "<Cmd>NextTrailingWhitespace<CR>", noremap = true },
    { "[w", "<Cmd>PrevTrailingWhitespace<CR>", noremap = true },
  },
  init = function()
    vim.g.better_whitespace_enabled = 1
    vim.g.strip_whitespace_on_save = 1
    vim.g.strip_whitespace_confirm = 0
    vim.g.better_whitespace_operator = "_s"
    vim.g.better_whitespace_filetypes_blacklist = { "diff", "qf", "help", "norg" }
  end,
}
