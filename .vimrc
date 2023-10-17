source ~/.config/nvim/general/settings.vim
source ~/.config/nvim/keys/mappings.vim

" change shape of cursor
autocmd VimEnter * silent exec "! echo -ne '\e[1 q'"
autocmd VimLeave * silent exec "! echo -ne '\e[5 q'"
autocmd InsertEnter * silent execute "!echo -en '\e[5 q'"
autocmd InsertLeave * silent execute "!echo -en '\e[1 q'"
