let $FZF_DEFAULT_OPTS='--reverse'

nnoremap [fugitive] <Nop>

nmap <Leader>l [fugitive]
nnoremap [fugitive]s :G<CR>
nnoremap [fugitive]a :G add .<CR>
nnoremap [fugitive]t :GBranches<CR>
nnoremap [fugitive]p :G push --quiet<CR>
nnoremap [fugitive]l :G pull --quiet<CR>
nnoremap [fugitive]b :G blame<CR>
nnoremap [fugitive]d :Gdiff<CR>
nnoremap [fugitive]m :G merge<CR>
nnoremap [fugitive]d :diffget //2<CR>
nnoremap [fugitive]k :diffget //3<CR>
nnoremap [fugitive]v dv<CR>

" nnoremap dv "open diff configuration menu"
