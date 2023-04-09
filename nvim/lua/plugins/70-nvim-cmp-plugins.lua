return {
  {
    "uga-rosa/cmp-dictionary",
    init = function()
      vim.opt_global.dictionary = "/usr/share/dict/words"
    end,
    opts = {
      first_case_insensitive = true,
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
