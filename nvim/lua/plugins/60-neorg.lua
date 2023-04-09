local M = {
  "nvim-neorg/neorg",
  ft = "norg",
  dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-cmp", "mason.nvim", "nvim-lua/plenary.nvim" },
  build = ":Neorg sync-parsers",
  cmd = "Neorg",
}

local function list_workspaces(w_dirs)
  local res = {}
  for _, w in ipairs(w_dirs) do
    res[w] = "~/Documents/" .. w
  end
  return { workspaces = res }
end

local plugins = {
  ["core.defaults"] = {},
  ["core.norg.concealer"] = { config = { icon_preset = "diamond" } },
  ["core.norg.completion"] = { config = { engine = "nvim-cmp", name = "[Norg]" } },
  ["core.norg.esupports.metagen"] = {},
  ["core.integrations.nvim-cmp"] = {},
  ["core.norg.qol.toc"] = {},
  ["core.norg.qol.todo_items"] = {},
  ["core.export"] = {},
  ["core.presenter"] = { config = { zen_mode = "zen-mode" } },
  ["core.norg.journal"] = {},
  ["core.norg.dirman"] = {
    config = list_workspaces({
      "wiki",
      "work",
    }),
  },
  ["core.keybinds"] = {
    -- https://github.com/nvim-neorg/neorg/blob/main/lua/neorg/modules/core/keybinds/keybinds.lua
    config = {
      default_keybinds = true,
      neorg_leader = "<Leader><Leader>",
    },
  },
}

M.opts = {
  load = plugins,
}

return M
