local function find_all_dicts()
  local dict_source = { "/usr/share/dict/words" }
  for filepath in vim.fn.glob(vim.fn.stdpath("config") .. "/spell/*.add"):gmatch("[^\n]+") do
    dict_source[#dict_source + 1] = filepath
  end
  return dict_source
end

return {
  {
    "uga-rosa/cmp-dictionary",
    dependencies = {
      { "nvim-lua/plenary.nvim" },
    },
    opts = {
      paths = find_all_dicts(),
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
