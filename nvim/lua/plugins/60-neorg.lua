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

local plugins = {
  ["core.defaults"] = {},
  ["core.norg.concealer"] = { config = { icon_preset = "diamond" } },
  ["core.norg.completion"] = { config = { engine = "nvim-cmp", name = "[Norg]" } },
  ["core.norg.esupports.metagen"] = { config = { type = "empty" } },
  ["core.integrations.nvim-cmp"] = {},
  ["core.norg.qol.toc"] = {},
  ["core.norg.qol.todo_items"] = {},
  ["core.export"] = {},
  ["core.presenter"] = { config = { zen_mode = "zen-mode" } },
  ["core.norg.journal"] = {
    config = {
      strategy = "flat",
      template_name = "../templates/journal.norg",
      workspace = M.default_workspace,
    },
  },
  ["core.norg.dirman"] = {
    config = list_workspaces({
      M.default_workspace,
      "Works",
    }),
  },
  ["core.keybinds"] = {
    -- https://github.com/nvim-neorg/neorg/blob/main/lua/neorg/modules/core/keybinds/keybinds.lua
    config = {
      default_keybinds = true,
      neorg_leader = "<Leader><Leader>",
      hook = function(keybinds)
        local norg_utils = require("norg-config.utils")
        keybinds.map("norg", "n", vim.g.personal_options.prefix.neorg .. "e", function()
          norg_utils.export_file(".md", { open_file = true, open_markdown_preview = false })
        end, { desc = "Neorg: export to markdown and open file" })
        keybinds.map("norg", "n", vim.g.personal_options.prefix.neorg .. "E", function()
          norg_utils.export_file(".md", { open_file = true, open_markdown_preview = true })
        end, { desc = "Neorg: export to markdown and open MarkdownPreview" })
      end,
    },
  },
}

M.opts = {
  load = plugins,
}

return M
