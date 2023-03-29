local function neogit_map(key, method, no_neogit)
  return {
    vim.g.personal_options.prefix.neogit .. key,
    string.format([[<Cmd>%s%s<CR>]], no_neogit and "" or "Neogit ", method),
    desc = "Neogit: " .. method,
  }
end

return {
  "TimUntersberger/neogit",
  dependencies = {
    {
      "sindrets/diffview.nvim",
      cmd = { "DiffviewOpen", "DiffviewFileHistory" },
    },
    { 'nvim-lua/plenary.nvim' },
    { "rhysd/conflict-marker.vim" },
  },
  keys = {
    neogit_map("s", "kind=vsplit"),
    neogit_map("d", "DiffviewOpen", true),
    neogit_map("D", "DiffviewOpen master", true),
    neogit_map("g", "log"),
    neogit_map("l", "pull"),
    neogit_map("p", "push"),
  },
  init = function()
    vim.cmd([[
    highlight ConflictMarkerBegin guibg=#2f7366
    highlight ConflictMarkerOurs guibg=#2e5049
    highlight ConflictMarkerTheirs guibg=#344f69
    highlight ConflictMarkerEnd guibg=#2f628e
    highlight ConflictMarkerCommonAncestorsHunk guibg=#754a81
    ]])
  end,
  opts = {
    disable_signs = false,
    disable_hint = false,
    disable_context_highlighting = false,
    disable_commit_confirmation = true,
    disable_insert_on_commit = false,
    auto_refresh = true,
    disable_builtin_notifications = true,
    console_timeout = 10000,
    auto_show_console = false,
    commit_popup = { kind = "split" },
    kind = "split",
    signs = {
      -- { CLOSED, OPENED }
      section = { ">", "v" },
      item = { ">", "v" },
      hunk = { "", "" },
    },
    integrations = {
      diffview = true,
    },
    sections = {
      untracked = { folded = false },
      unstaged = { folded = false },
      staged = { folded = false },
      stashes = { folded = true },
      unpulled = { folded = true },
      unmerged = { folded = false },
      recent = { folded = true },
    },
    mappings = {
      status = {
        ["B"] = "BranchPopup",
      },
    },
  },
}
