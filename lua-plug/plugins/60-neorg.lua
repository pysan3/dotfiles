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
    "nvim-cmp",
    "mason.nvim",
  },
  build = ":Neorg sync-parsers",
  cmd = "Neorg",
  config = function()
    require("neorg").setup({
      load = {
        ["core.defaults"] = {},
        ["core.keybinds"] = {
          -- https://github.com/nvim-neorg/neorg/blob/main/lua/neorg/modules/core/keybinds/keybinds.lua
          config = {
            default_keybinds = true,
            neorg_leader = "<Leader><Leader>",
          },
        },
        ["core.norg.qol.toc"] = {},
        ["core.norg.journal"] = {},
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
        ["core.presenter"] = {
          config = {
            zen_mode = "zen-mode",
          }
        },
      },
    })
  end,
}
