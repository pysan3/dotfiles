vim.cmd([[
nnoremap [neogit] <Nop>

nmap <Leader>g [neogit]
nnoremap [neogit]s <Cmd>Neogit kind=split<CR>
nnoremap [neogit]d <Cmd>DiffviewOpen<CR>
nnoremap [neogit]D <Cmd>DiffviewOpen master<CR>
nnoremap [neogit]g <Cmd>Neogit log<CR>
nnoremap [neogit]l <Cmd>Neogit pull<CR>
nnoremap [neogit]p <Cmd>Neogit push<CR>
]])

vim.cmd([[
highlight ConflictMarkerBegin guibg=#2f7366
highlight ConflictMarkerOurs guibg=#2e5049
highlight ConflictMarkerTheirs guibg=#344f69
highlight ConflictMarkerEnd guibg=#2f628e
highlight ConflictMarkerCommonAncestorsHunk guibg=#754a81
]])
