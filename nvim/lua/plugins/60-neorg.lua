local M = {
  "nvim-neorg/neorg",
  ft = "norg",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-treesitter/nvim-treesitter-textobjects",
    "nvim-cmp",
    "mason.nvim",
    "nvim-lua/plenary.nvim",
    "ntpeters/vim-better-whitespace",
    {
      "pysan3/neorg-templates-draft",
      dependencies = { "L3MON4D3/LuaSnip" },
    },
  },
  build = ":Neorg sync-parsers",
  cmd = "Neorg",
  default_workspace = "Notes",
}

M.init = function()
  require("norg-config.commands").setup({})
  require("norg-config.autocmds").setup({})
end

local function list_workspaces(w_dirs)
  local res = {}
  for _, w in ipairs(w_dirs) do
    res[w] = "~/Nextcloud/" .. w
  end
  return { workspaces = res }
end

local function load_plugins()
  return {
    ["core.defaults"] = {},
    ["core.concealer"] = { config = { icon_preset = "diamond" } },
    ["core.completion"] = { config = { engine = "nvim-cmp", name = "[Norg]" } },
    ["core.esupports.metagen"] = { config = { type = "empty", update_date = true } },
    ["core.integrations.nvim-cmp"] = {},
    ["core.qol.toc"] = {},
    ["core.qol.todo_items"] = {},
    ["core.looking-glass"] = {},
    ["core.export"] = {},
    ["core.presenter"] = { config = { zen_mode = "zen-mode" } },
    ["core.journal"] = {
      config = {
        strategy = "nested",
        workspace = M.default_workspace,
      },
    },
    ["core.dirman"] = {
      config = list_workspaces({
        M.default_workspace,
        "Works",
      }),
    },
    ["core.keybinds"] = {
      -- https://github.com/nvim-neorg/neorg/blob/main/lua/neorg/modules/core/keybinds/keybinds.lua
      config = {
        default_keybinds = true,
        neorg_leader = "<Leader>",
        hook = require("norg-config.keybinds").hook,
      },
    },
    ["external.templates"] = {
      config = {
        templates_dir = vim.fn.stdpath("config") .. "/templates/norg",
      },
    },
  }
end

M.config = function()
  require("neorg").setup({
    load = load_plugins(),
  })
end

return M
