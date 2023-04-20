return {
  {
    "uga-rosa/cmp-dictionary",
    dependencies = { { "kkharji/sqlite.lua", module = "sqlite" } },
    cmd = "CmpDictionaryUpdate",
    init = function()
      vim.opt_global.dictionary = "/usr/share/dict/words"
      vim.api.nvim_create_autocmd("InsertEnter", {
        command = "CmpDictionaryUpdate",
        once = true,
      })
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
