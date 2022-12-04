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

vim.cmd([[
nnoremap [neogit] <Nop>

nmap <Leader>g [neogit]
nnoremap [neogit]s :Neogit kind=split<CR>
nnoremap [neogit]d :DiffviewOpen<CR>
nnoremap [neogit]D :DiffviewOpen master<CR>
nnoremap [neogit]g :Neogit log<CR>
nnoremap [neogit]l :Neogit pull<CR>
nnoremap [neogit]p :Neogit push<CR>
]])

vim.cmd([[
highlight ConflictMarkerBegin guibg=#2f7366
highlight ConflictMarkerOurs guibg=#2e5049
highlight ConflictMarkerTheirs guibg=#344f69
highlight ConflictMarkerEnd guibg=#2f628e
highlight ConflictMarkerCommonAncestorsHunk guibg=#754a81
]])
