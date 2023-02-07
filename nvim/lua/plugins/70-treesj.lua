return {
  "Wansmer/treesj",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  keys = {
    { "<Leader>m,", "<Cmd>TSJToggle<CR>", noremap = true, desc = "<Cmd>TSJToggle<CR>" },
  },
  cmd = { "TSJToggle" },
  config = {
    use_default_keymaps = false,
  },
}
