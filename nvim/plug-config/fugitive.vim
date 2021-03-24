let $FZF_DEFAULT_OPTS='--reverse'

nnoremap [fugitive] <Nop>

nmap <Leader>g [fugitive]
nnoremap [fugitive]s :G<CR>
nnoremap [fugitive]a :G add .<CR>
nnoremap [fugitive]t :GBranches<CR>
nnoremap [fugitive]p :G push<CR>
nnoremap [fugitive]l :G pull<CR>
nnoremap [fugitive]b :G blame<CR>
nnoremap [fugitive]d :Gdiff<CR>
nnoremap [fugitive]m :G merge<CR>
nnoremap [fugitive]f :diffget //2<CR>
nnoremap [fugitive]j :diffget //3<CR>

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

" This command is from peterhurford/send.vim
fu! GitSendCommit(...)
    let msg = join(a:000, ' ')
    let branch = system('! git branch | awk "{print $2}"')
    if (branch == 'master') || (branch == 'main')
        echo 'It seens you are on an important branch. "' . branch . '"'
        if Confirm('Continue anyways? [Y/n] ', 'n', 0) == 0
            echo 'Aborted'
            return 0
        endif
    endif
    let command = '!
        \ git add `git rev-parse --show-toplevel`;
        \ git commit -m "' . msg . '";
        \ git push -q origin `git rev-parse --abbrev-ref HEAD`'
    let output = system(command)
    echo output
endfunction

command! -nargs=+ Send :call GitSendCommit(<f-args>)
nnoremap [fugitive]c :Send 
