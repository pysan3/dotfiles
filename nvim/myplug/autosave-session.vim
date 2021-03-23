fu! GetCurrentDirName()
    echo system('basename ' . getcwd())
endfunction

fun! Confirm(msg, ans, value)
    echo a:msg . ' '
    let l:answer = nr2char(getchar())

    if l:answer ==? a:ans
        return a:value
    elseif l:answer ==? 'n'
        return 0
    elseif l:answer ==? 'y'
        return 1
    else
        return ! a:value
    endif
endfun

fu! SaveSess(...)
    let sessionpath = expand(getcwd() . '/.session.vim ')
    let dirname = expand(g:startify_session_dir) . '/' . trim(system('basename ' . getcwd()))
    let yes = a:0 && a:1
    if (!yes) && empty(glob(dirname)) && (Confirm('Save current session to ' . dirname . '? [y/N]: ', 'y', 1) == 0)
        echo 'Not saving a new session.'
        return 0
    endif
    execute 'mksession! ' . sessionpath
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

autocmd VimLeave * call SaveSess()
command! WQ call SaveSess(1) | wq
autocmd VimEnter * nested call RestoreSess()
