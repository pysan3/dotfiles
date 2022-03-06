function! SourceLocalConfig() abort
  let l:projectfile = findfile('.vim/local.vim', expand('%:p').';')
  if filereadable(l:projectfile)
    silent execute 'source' l:projectfile
  endif
endfunction

augroup MyAutoCmds
  autocmd BufRead,BufNewFile * call SourceLocalConfig()

  if has('nvim')
    autocmd DirChanged * call SourceLocalConfig()
  endif
augroup END

