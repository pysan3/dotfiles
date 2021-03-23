fu! GetCurrentDirName()
    echo system('basename ' . getcwd())
endfunction

fu! SaveSess()
    let sessionpath = expand(getcwd() . '/.session.vim ')
    let dirname = expand(g:startify_session_dir) . '/' . system('basename ' . getcwd())
    execute 'mksession! ' . sessionpath
    echo 'sessionpath to: ' . sessionpath
    if empty(glob(dirname))
        execute '! ln ' . sessionpath . ' ' . dirname
    endif
    echo 'Saved session as: ' . dirname
endfunction

fu! RestoreSess()
if filereadable(getcwd() . '/.session.vim')
    execute 'so ' . getcwd() . '/.session.vim'
    if bufexists(1)
        for l in range(1, bufnr('$'))
            if bufwinnr(l) == -1
                exec 'sbuffer ' . l
            endif
        endfor
    endif
endif
endfunction

" autocmd VimLeave * call SaveSess()
command! WQ call SaveSess() | wq
autocmd VimEnter * nested call RestoreSess()
