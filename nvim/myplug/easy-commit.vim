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
endfunction

" Commit all at once
function! GitSendCommit(...)
    let msg = join(a:000, ' ')
    let branch = system("! git branch | awk '{print $2}'")
    echo branch
    if (branch == 'master') || (branch == 'main')
        echo 'It seems you are on an important branch. "' . branch . '"'
        if Confirm('Continue anyways? [Y/n] ', 'n', 0) == 0
            echo 'Aborted'
            return 0
        endif
    endif
    let command = '!
        \ git add .;
        \ git commit -m "' . msg . '";
        \ git push -q origin ' . branch . ';'
    echo command
    sleep 10000m
    let output = system(command)
    echo output
endfunction

command! -nargs=+ Send :call GitSendCommit(<f-args>)
nnoremap <Leader>gc :Send
