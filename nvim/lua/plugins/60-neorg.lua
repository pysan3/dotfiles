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

M.opts = { load = {} }
M.opts.load["core.defaults"] = {}
M.opts.load["core.norg.concealer"] = { config = { icon_preset = "diamond" } }
M.opts.load["core.norg.completion"] = { config = { engine = "nvim-cmp", name = "[Norg]" } }
M.opts.load["core.norg.esupports.metagen"] = {}
M.opts.load["core.integrations.nvim-cmp"] = {}
M.opts.load["core.norg.qol.toc"] = {}
M.opts.load["core.norg.qol.todo_items"] = {}
M.opts.load["core.export"] = {}
M.opts.load["core.presenter"] = { config = { zen_mode = "zen-mode" } }
M.opts.load["core.norg.journal"] = {}
M.opts.load["core.norg.dirman"] = {
  config = list_workspaces({
    "wiki",
    "work",
  }),
}
M.opts.load["core.keybinds"] = {
  -- https://github.com/nvim-neorg/neorg/blob/main/lua/neorg/modules/core/keybinds/keybinds.lua
  config = {
    default_keybinds = true,
    neorg_leader = "<Leader><Leader>",
  },
}

return M
