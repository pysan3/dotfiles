fu! SaveSess()
    let sessionpath = expand(getcwd() . '/.session.vim ')
    execute 'mksession! ' . sessionpath
    if !filereadable(expand(g:startify_session_dir) . sessionpath)
        execute '! ln ' . sessionpath . ' ' . expand(g:startify_session_dir)
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
