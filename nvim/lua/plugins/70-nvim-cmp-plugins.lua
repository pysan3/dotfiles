local M = {}

table.insert(M, { "uga-rosa/cmp-dictionary" })
M[#M].config = function()
  vim.opt_global.dictionary = "/usr/share/dict/words"
  require("cmp_dictionary").setup({
    exact = 2,
    first_case_insensitive = false,
    document = false,
    async = false,
    max_items = -1,
    capacity = 5,
    debug = false,
  })
end

table.insert(M, { "petertriho/cmp-git" })
M[#M].dependencies = { "nvim-lua/plenary.nvim" }
M[#M].opts = {
  filetypes = vim.g.personal_module.md(),
}

return M
