autocmd FileType sh,bash,zsh,fish setlocal shiftwidth=2

augroup packer_user_config
  autocmd!
  autocmd BufWritePost *config/init.lua source <afile> | PackerSync
augroup end

nnoremap <leader><leader>r :PackerSync<CR>
