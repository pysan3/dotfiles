let $FZF_DEFAULT_OPTS='--reverse'

nnoremap [fugitive] <Nop>

nmap <Leader>g [fugitive]
nnoremap [fugitive]s :G<CR>
nnoremap [fugitive]a :G add .<CR>
nnoremap [fugitive]t :GBranches<CR>
nnoremap [fugitive]p :G push<CR>
nnoremap [fugitive]l :G pull<CR>
nnoremap [fugitive]b :G blame<CR>
nnoremap [fugitive]d :Gdiff<CR>
nnoremap [fugitive]m :G merge<CR>
nnoremap [fugitive]f :diffget //2<CR>
nnoremap [fugitive]j :diffget //3<CR>
