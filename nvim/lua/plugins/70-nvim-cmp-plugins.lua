local function find_all_dicts()
  local dict_source = {}
  local default = "/usr/share/dict/words"
  if vim.loop.fs_stat(default) then
    table.insert(dict_source, default)
  end
  for filepath in vim.fn.glob(vim.fn.stdpath("config") .. "/spell/*.add"):gmatch("[^\n]+") do
    table.insert(dict_source, filepath)
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
