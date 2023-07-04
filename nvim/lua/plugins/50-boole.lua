return {
  "nat-418/boole.nvim",
  cmd = { "Boole" },
  keys = {
    { "<C-a>", "<Cmd>Boole increment<CR>", silent = true },
    { "<C-x>", "<Cmd>Boole decrement<CR>", silent = true },
  },
  opts = {
    mappings = {
      increment = "<C-a>",
      decrement = "<C-x>",
    },
    additions = {},
    allow_caps_additions = {
      { "foo", "bar" },
      { "hoge", "fuga" },
      { "enable", "disable" },
    },
  },
}
