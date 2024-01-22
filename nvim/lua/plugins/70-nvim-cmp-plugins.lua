return {
  {
    "uga-rosa/cmp-dictionary",
    dependencies = {
      { "nvim-lua/plenary.nvim" },
    },
    opts = {
      paths = "/usr/share/dict/words",
      first_case_insensitive = true,
      exact_length = 2,
      document = {
        enable = false,
      },
    },
  },
  {
    "petertriho/cmp-git",
    dependencies = {
      { "nvim-lua/plenary.nvim" },
    },
    opts = {
      filetypes = vim.g.personal_module.md(),
    },
  },
}
