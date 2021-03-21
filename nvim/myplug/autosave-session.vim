fu! GetCurrentDirName()
    echo system('basename ' . getcwd())
endfunction

fu! SaveSess()
    let sessionpath = expand(getcwd() . '/.session.vim ')
    let dirname = system('basename ' . getcwd())
    execute 'mksession! ' . sessionpath
    echo 'Saved session as: ' . expand(g:startify_session_dir) . '/' .dirname
    if empty(glob(expand(g:startify_session_dir)) . '/' . dirname)
        execute '! ln ' . sessionpath . ' ' . expand(g:startify_session_dir) . '/' . dirname
    endif
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

autocmd VimLeave * call SaveSess()
autocmd VimEnter * nested call RestoreSess()
