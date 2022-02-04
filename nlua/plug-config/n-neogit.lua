require("neogit").setup({
  disable_signs = false,
  disable_hint = false,
  disable_context_highlighting = false,
  disable_commit_confirmation = true,
  disable_insert_on_commit = false,
  auto_refresh = true,
  disable_builtin_notifications = false,
  commit_popup = {
    kind = "split",
  },
  -- Change the default way of opening neogit
  kind = "split",
  -- customize displayed signs
  signs = {
    -- { CLOSED, OPENED }
    section = { ">", "v" },
    item = { ">", "v" },
    hunk = { "", "" },
  },
  integrations = {
    diffview = true,
  },
  -- Setting any section to `false` will make the section not render at all
  sections = {
    untracked = { folded = false },
    unstaged = { folded = false },
    staged = { folded = false },
    stashes = { folded = false },
    unpulled = { folded = false },
    unmerged = { folded = false },
    recent = { folded = false },
  },
  mappings = {
    status = {
      ["B"] = "BranchPopup",
    },
  },
})

require("gitsigns").setup({
  signs = {
    -- icon: ▎
    add = { hl = "GitSignsAdd", text = " ", numhl = "GitSignsAddNr", linehl = "GitSignsAddLn" },
    change = { hl = "GitSignsChange", text = " ", numhl = "GitSignsChangeNr", linehl = "GitSignsChangeLn" },
    delete = { hl = "GitSignsDelete", text = ">", numhl = "GitSignsDeleteNr", linehl = "GitSignsDeleteLn" },
    topdelete = { hl = "GitSignsDelete", text = ">", numhl = "GitSignsDeleteNr", linehl = "GitSignsDeleteLn" },
    changedelete = { hl = "GitSignsChange", text = " ", numhl = "GitSignsChangeNr", linehl = "GitSignsChangeLn" },
  },
  signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
  numhl = false, -- Toggle with `:Gitsigns toggle_numhl`
  linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
  word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
  watch_gitdir = {
    interval = 1000,
    follow_files = true,
  },
  attach_to_untracked = true,
  current_line_blame = true, -- Toggle with `:Gitsigns toggle_current_line_blame`
  current_line_blame_opts = {
    virt_text = true,
    virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
    delay = 1000,
    ignore_whitespace = true,
  },
  current_line_blame_formatter_opts = {
    relative_time = false,
  },
  sign_priority = 6,
  update_debounce = 100,
  status_formatter = nil, -- Use default
  max_file_length = 40000,
  preview_config = {
    -- Options passed to nvim_open_win
    border = "single",
    style = "minimal",
    relative = "cursor",
    row = 0,
    col = 1,
  },
  yadm = {
    enable = false,
  },
  on_attach = function(bufnr)
    local function map(mode, lhs, rhs, opts)
      opts = vim.tbl_extend("force", { noremap = true, silent = true }, opts or {})
      vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, opts)
    end
    -- Navigation
    map("n", "]c", "&diff ? ']c' : '<cmd>Gitsigns next_hunk<CR>'", { expr = true })
    map("n", "[c", "&diff ? '[c' : '<cmd>Gitsigns prev_hunk<CR>'", { expr = true })
    -- Actions
    map("n", "<leader>hs", ":Gitsigns stage_hunk<CR>")
    map("v", "<leader>hs", ":Gitsigns stage_hunk<CR>")
    map("n", "<leader>hr", ":Gitsigns reset_hunk<CR>")
    map("v", "<leader>hr", ":Gitsigns reset_hunk<CR>")
    map("n", "<leader>hS", "<cmd>Gitsigns stage_buffer<CR>")
    map("n", "<leader>hu", "<cmd>Gitsigns undo_stage_hunk<CR>")
    map("n", "<leader>hR", "<cmd>Gitsigns reset_buffer<CR>")
    map("n", "<leader>hp", "<cmd>Gitsigns preview_hunk<CR>")
    map("n", "<leader>hb", '<cmd>lua require"gitsigns".blame_line{full=true}<CR>')
    map("n", "<leader>tb", "<cmd>Gitsigns toggle_current_line_blame<CR>")
    map("n", "<leader>hd", "<cmd>Gitsigns diffthis<CR>")
    map("n", "<leader>hD", '<cmd>lua require"gitsigns".diffthis("~")<CR>')
    map("n", "<leader>td", "<cmd>Gitsigns toggle_deleted<CR>")
    -- Text object
    map("o", "ih", ":<C-U>Gitsigns select_hunk<CR>")
    map("x", "ih", ":<C-U>Gitsigns select_hunk<CR>")
  end,
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
" highlight conflicts
highlight ConflictMarkerBegin guibg=#2f7366
highlight ConflictMarkerOurs guibg=#2e5049
highlight ConflictMarkerTheirs guibg=#344f69
highlight ConflictMarkerEnd guibg=#2f628e
highlight ConflictMarkerCommonAncestorsHunk guibg=#754a81
]])
