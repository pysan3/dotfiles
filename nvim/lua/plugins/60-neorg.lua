local M = {
  "nvim-neorg/neorg",
  ft = "norg",
  dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-cmp", "mason.nvim", "nvim-lua/plenary.nvim" },
  build = ":Neorg sync-parsers",
  cmd = "Neorg",
  default_workspace = "Notes",
}

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
        local function export_file(suffix, open_markdown_preview)
          local dst = vim.fn.fnamemodify(vim.fn.expand("%"), ":~:.:r") .. suffix -- same name with suffix
          vim.cmd([[Neorg export to-file ]] .. dst)
          vim.schedule(function()
            vim.cmd.edit(dst)
            if open_markdown_preview then
              vim.cmd([[MarkdownPreview]])
            end
          end)
        end
        keybinds.map("norg", "n", vim.g.personal_options.prefix.neorg .. "e", function()
          export_file(".md", false)
        end, { desc = "Neorg: export to markdown and open file" })
        keybinds.map("norg", "n", vim.g.personal_options.prefix.neorg .. "E", function()
          export_file(".md", true)
        end, { desc = "Neorg: export to markdown and open MarkdownPreview" })
      end,
    },
  },
}

M.opts = {
  load = plugins,
}

return M
