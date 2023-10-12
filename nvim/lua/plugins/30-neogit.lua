local function neogit_map(key, method, no_neogit)
  return {
    vim.g.personal_options.prefix.neogit .. key,
    string.format([[<Cmd>%s%s<CR>]], no_neogit and "" or "Neogit ", method),
    desc = "Neogit: " .. method,
  }
end

return {
  "NeogitOrg/neogit",
  dependencies = {
    {
      "sindrets/diffview.nvim",
      cmd = { "DiffviewOpen", "DiffviewFileHistory" },
    },
    { "nvim-lua/plenary.nvim" },
    { "rhysd/conflict-marker.vim" },
  },
  cond = vim.g.personal_options.use_git_plugins,
  keys = {
    neogit_map("s", ""),
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
  ---@type NeogitConfig
  opts = {
    disable_signs = false,
    disable_hint = false,
    disable_context_highlighting = false,
    disable_commit_confirmation = true,
    disable_insert_on_commit = false,
    auto_refresh = false,
    disable_builtin_notifications = true,
    console_timeout = 10000,
    auto_show_console = false,
    integrations = {
      diffview = true,
    },
    sections = {
      sequencer = {
        folded = false,
        hidden = false,
      },
      untracked = {
        folded = false,
        hidden = false,
      },
      unstaged = {
        folded = false,
        hidden = false,
      },
      staged = {
        folded = true,
        hidden = false,
      },
      stashes = {
        folded = true,
        hidden = false,
      },
      unpulled_upstream = {
        folded = true,
        hidden = false,
      },
      unmerged_upstream = {
        folded = false,
        hidden = false,
      },
      unpulled_pushRemote = {
        folded = true,
        hidden = false,
      },
      unmerged_pushRemote = {
        folded = false,
        hidden = false,
      },
      recent = {
        folded = true,
        hidden = false,
      },
      rebase = {
        folded = true,
        hidden = false,
      },
    },
  },
}
