local function list_workspaces(w_dirs)
  local res = {}
  for _, w in ipairs(w_dirs) do
    res[w] = "~/Documents/" .. w
  end
  return { workspaces = res }
end

return {
  "nvim-neorg/neorg",
  ft = "norg",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
  },
  build = ":Neorg sync-parsers",
  cmd = "Neorg",
  config = {
    load = {
      ["core.defaults"] = {},
      ["core.norg.dirman"] = {
        config = list_workspaces({
          "wiki",
          "work",
        }),
      },
      ["core.norg.concealer"] = {},
      ["core.norg.completion"] = {
        config = { engine = "nvim-cmp" },
      },
      ["core.integrations.nvim-cmp"] = {},
    },
  },
}
