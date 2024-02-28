return {
  "Wansmer/treesj",
  dependencies = {
    "nvim-treesitter",
  },
  keys = {
    { "<Leader>m,", "<Cmd>TSJToggle<CR>", noremap = true, desc = "<Cmd>TSJToggle<CR>" },
  },
  cmd = { "TSJToggle" },
  opts = {
    use_default_keymaps = false,
  },
}
