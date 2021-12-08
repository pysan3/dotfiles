function! Confirm(msg, ans, value)
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

function SessionName(path)
    if a:path == ''
        return ''
    endif
    return trim(trim(system('basename ' . a:path)), '.')
endfunction

function! FullPath(path)
    return resolve(expand(a:path))
endfun

function! SaveSess(...)
    if FullPath(getcwd()) == FullPath($HOME)
        echo 'Currently working in $HOME directory. Not saving session.'
        return 0
    endif
    let sessionpath = FullPath(getcwd() . '/.session.vim ')
    let dirname = FullPath(g:startify_session_dir) . '/' . SessionName(getcwd())
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

function! RestoreSess()
if filereadable(getcwd() . '/.session.vim')
    execute 'so ' . getcwd() . '/.session.vim'
    let current_session = SessionName(getcwd())
    for buf in range(1, bufnr('$'))
        if SessionName(bufname(buf)) == current_session
            exec 'bd ' . bufname(buf)
        endif
    endfor
endif
endfunction

function! DeleteSess()
    let session_list = split(globpath(FullPath(g:startify_session_dir), '[^_]*'), '\n')
    let current = -1
    let current_session = SessionName(getcwd())
    if len(session_list) == 0
        echo 'No sessions to delete!'
        echo 'Nice and clean :D'
        return 0
    endif
    for i in range(0, len(session_list) - 1)
        echo i . ': ' . session_list[i]
        if trim(system('basename ' . session_list[i])) ==? current_session
            let current = i
        endif
    endfor
    while 1
        let c = input('Delete which session? (Default: '. (current >= 0 ? current : 'None') . '): ')
        echo ' '
        if len(c) == 0 && current >= 0
            break
        elseif matchstr(c, '^\d$') && str2nr(c) < len(session_list)
            let current = str2nr(c)
            break
        else
            echo 'Please input an integer or nothing for default value (available only if not None).'
        endif
    endwhile
    if current >= 0
        call delete(fnameescape(trim(session_list[current])))
        echo 'Deleted ' . session_list[current]
    else
        echo 'Aborted'
    endif
endfunction

autocmd VimLeave * call SaveSess()
command! WQ call SaveSess(1) | wq
command! Q call SaveSess(0) | noa q
autocmd VimEnter * nested call RestoreSess()

command! SessSave call SaveSess()
command! SessDelete call DeleteSess()
