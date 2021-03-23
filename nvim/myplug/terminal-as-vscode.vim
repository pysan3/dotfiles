if has('nvim')
  " exitフックを指定して:terminalを開く
  function! s:termopen_wrapper(on_exit) abort
    " https://github.com/neovim/neovim/pull/5529
    " でvimのpartialがneovimに取り込まれて以降は、
    " on_existに設定するコールバックが関数名でなく、
    " 関数値そのもの？(function('関数名'))ようなので、古いneovimの場合注意
    "
    " 7.4.1577が当たっているかどうかで切り分ける
    if has('patch-7.4.1577')
      call termopen($SHELL, {'on_exit': function(a:on_exit)})
    else
      call termopen($SHELL, {'on_exit': a:on_exit})
    endif
  endfunction

  " terminalの終了時にバッファを消すフック
  function! s:onTermExit(job_id, code, event) dict
    " Process Exitが表示されたその後cr打つとバッファが無くなるので
    " それと同じようにする
    call feedkeys("\<CR>")
  endfun

  " 水平分割でexit時に自動でcloseする行数sizeのターミナルバッファ表示
  function! TermHelper(...) abort
    let h_or_v = get(a:, 1, 'h') "デフォルトは水平分割
    let size = get(a:, 2, 15) "デフォルトは高さ(or幅)15のウィンドウ

    if h_or_v == 'h'
      "topleft new | call s:termopen_wrapper('s:onTermExit')
      botright new | Eterminal
      execute 'resize ' . size
    else
      "vertical botright new | call s:termopen_wrapper('s:onTermExit')
      vertical botright new | Eterminal
      execute 'vertical resize ' . size
    endif
  endfun

  " 水平ウィンドウ分割してターミナル表示 引数はwindowの行数指定(Horizontal terminal)
  command! -count=12 Hterminal :call TermHelper('h', <count>)
  " 垂直ウィンドウ分割してターミナル表示 引数はwindowの行数指定(Vertical terminal)
  command! -count=80 Vterminal :call TermHelper('v', <count>)
  " ウィンドウ分割なしでターミナル表示(Extended Terminal)
  command! Eterminal :call s:termopen_wrapper('s:onTermExit') | startinsert
endif

" Terminal
nnoremap <A-t> :Hterminal<CR>
inoremap <A-t> <Esc>:Hterminal<CR>
tmap <A-t> <Esc><Leader>q<CR>

" Terminal go back to normal mode
tnoremap <Esc> <C-\><C-n>
tnoremap :q! <C-\><C-n>:q!<CR>

