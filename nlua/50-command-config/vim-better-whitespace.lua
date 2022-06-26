vim.g.better_whitespace_enabled = 1
vim.g.strip_whitespace_on_save = 1
vim.g.strip_whitespace_confirm = 0

-- use <leader>_s to strip specific area
vim.g.better_whitespace_operator = "_s"

vim.g.better_whitespace_filetypes_blacklist = {
  "NvimTree",
  "diff",
  "git",
  "gitcommit",
  "unite",
  "qf",
  "help",
  "markdown",
  "fugitive",
}

vim.cmd([[
nnoremap ]w :NextTrailingWhitespace<CR>
nnoremap [w :PrevTrailingWhitespace<CR>
]])
