return {
  "Wansmer/treesj",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  keys = {
    { "<Leader>m,", "<Cmd>TSJToggle<CR>", noremap = true },
  },
  cmd = { "TSJToggle" },
  config = {
    use_default_keymaps = false,
  },
}
