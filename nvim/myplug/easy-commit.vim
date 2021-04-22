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
    let msg = substitute(join(a:000, ' '), '"', '\\\"', 'g')
    echo msg
    sleep 1000m
    let branch = trim(system("! git branch | awk '{print $2}'"))
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
    let output = system(command)
    echo output
endfunction

command! -nargs=+ Send :call GitSendCommit(<f-args>)
nnoremap <Leader>gc :Send

" this config heavily depends on Floaterm
" Plug 'voldikss/vim-floaterm'
nnoremap <Leader>gz :FloatermNew git cz<CR>
