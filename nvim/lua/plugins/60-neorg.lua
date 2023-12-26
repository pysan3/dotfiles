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
    "nvim-lua/plenary.nvim",
    "laher/neorg-exec",
    {
      "pysan3/neorg-templates-draft",
      dependencies = { "L3MON4D3/LuaSnip" },
    },
  },
  build = ":Neorg sync-parsers",
  cmd = "Neorg",
  default_workspace = "Notes",
  aug = vim.api.nvim_create_augroup("NorgAuG", { clear = true }),
}

M.init = function()
  require("norg-config.commands").setup({})
  vim.api.nvim_create_autocmd("BufWritePost", {
    group = M.aug,
    pattern = "*.norg",
    command = "Neorg tangle current-file",
  })
end

local function list_workspaces(w_dirs)
  local res = {}
  for _, w in ipairs(w_dirs) do
    res[w] = "~/Nextcloud/" .. w
  end
  return res
end

local function load_plugins()
  return {
    ["core.defaults"] = {},
    ["core.concealer"] = { config = { icon_preset = "diamond" } },
    ["core.completion"] = { config = { engine = "nvim-cmp", name = "[Norg]" } },
    ["core.esupports.metagen"] = { config = { type = "auto", update_date = true } },
    ["core.integrations.nvim-cmp"] = {},
    ["core.qol.toc"] = {},
    ["core.qol.todo_items"] = {},
    ["core.looking-glass"] = {},
    ["core.export"] = {},
    ["core.export.markdown"] = { config = { extensions = "all" } },
    ["core.presenter"] = { config = { zen_mode = "zen-mode" } },
    ["core.summary"] = {},
    ["core.tangle"] = { config = { report_on_empty = false } },
    ["core.ui.calendar"] = {},
    ["core.journal"] = {
      config = {
        strategy = "nested",
        workspace = M.default_workspace,
      },
    },
    ["core.dirman"] = {
      config = {
        workspaces = list_workspaces({
          M.default_workspace,
          "Works",
        }),
        default_workspace = "default",
      },
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
        keywords = require("norg-config.templates"),
      },
    },
    ["external.exec"] = {},
  }
end

M.config = function()
  require("neorg").setup({
    load = load_plugins(),
  })
end

return M
