require("neogit").setup({
  disable_signs = false,
  disable_hint = false,
  disable_context_highlighting = false,
  disable_commit_confirmation = true,
  disable_insert_on_commit = false,
  auto_refresh = true,
  disable_builtin_notifications = true,
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
})
