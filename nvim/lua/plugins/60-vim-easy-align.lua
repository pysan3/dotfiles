return {
  "junegunn/vim-easy-align",
  ft = vim.g.personal_module.md(),
  cmd = { "EasyAlign" },
  keys = {
    { "ga", "<Plug>(EasyAlign)", noremap = false, mode = { "n", "x" } },
  },
}
