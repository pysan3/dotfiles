vim.env.FZF_DEFAULT_OPTS = "--reverse"

vim.cmd([[
nnoremap [fugitive] <Nop>

nmap <Leader>l [fugitive]
nnoremap [fugitive]s <Cmd>G<CR>
nnoremap [fugitive]a <Cmd>G add .<CR>
nnoremap [fugitive]t <Cmd>GBranches<CR>
nnoremap [fugitive]p <Cmd>G push --quiet<CR>
nnoremap [fugitive]l <Cmd>G pull --quiet<CR>
nnoremap [fugitive]b <Cmd>G blame<CR>
nnoremap [fugitive]d <Cmd>Gdiff<CR>
nnoremap [fugitive]m <Cmd>G merge<CR>
nnoremap [fugitive]d <Cmd>diffget //2<CR>
nnoremap [fugitive]k <Cmd>diffget //3<CR>
nnoremap [fugitive]v dv<CR>

" nnoremap dv "open diff configuration menu"
]])
