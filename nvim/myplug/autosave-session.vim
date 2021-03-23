fu! GetCurrentDirName()
    echo system('basename ' . getcwd())
endfunction

fu! SaveSess()
    let sessionpath = expand(getcwd() . '/.session.vim ')
    let dirname = expand(g:startify_session_dir) . '/' . system('basename ' . getcwd())
    echo 'sessionpath to: ' . sessionpath
    execute 'mksession! ' . sessionpath
    echo 'Saved session as: ' . dirname
    if empty(dirname)
        execute '! ln ' . sessionpath . ' ' . dirname
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

autocmd VimLeavePre * call SaveSess()
autocmd VimEnter * nested call RestoreSess()
