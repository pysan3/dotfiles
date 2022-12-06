local function map(mode, lhs, rhs, opts)
  opts = vim.tbl_extend("force", { noremap = true, silent = true }, opts or {})
  vim.api.nvim_set_keymap(mode, lhs, rhs, opts)
end

-- Navigation
map("n", "]c", "&diff ? ']c' : '<Cmd>Gitsigns next_hunk<CR>'", { expr = true })
map("n", "[c", "&diff ? '[c' : '<Cmd>Gitsigns prev_hunk<CR>'", { expr = true })
-- Actions
map("n", "<leader>hs", "<Cmd>Gitsigns stage_hunk<CR>")
map("v", "<leader>hs", "<Cmd>Gitsigns stage_hunk<CR>")
map("n", "<leader>hr", "<Cmd>Gitsigns reset_hunk<CR>")
map("v", "<leader>hr", "<Cmd>Gitsigns reset_hunk<CR>")
map("n", "<leader>hS", "<Cmd>Gitsigns stage_buffer<CR>")
map("n", "<leader>hu", "<Cmd>Gitsigns undo_stage_hunk<CR>")
map("n", "<leader>hR", "<Cmd>Gitsigns reset_buffer<CR>")
map("n", "<leader>hv", "<Cmd>Gitsigns preview_hunk<CR>")
map("n", "<leader>hb", '<Cmd>lua require"gitsigns".blame_line{full=true}<CR>')
map("n", "<leader>hd", "<Cmd>Gitsigns diffthis<CR>")
map("n", "<leader>hD", '<Cmd>lua require"gitsigns".diffthis("~")<CR>')
map("n", "<leader>td", "<Cmd>Gitsigns toggle_deleted<CR>")
-- Text object
map("o", "ih", "<Cmd><C-U>Gitsigns select_hunk<CR>")
map("x", "ih", "<Cmd><C-U>Gitsigns select_hunk<CR>")

vim.cmd([[
highlight GitGutterAdd    guifg=#227700 ctermfg=2
highlight GitGutterChange guifg=#2222ff ctermfg=3
highlight GitGutterDelete guifg=#880000 ctermfg=1
]])
