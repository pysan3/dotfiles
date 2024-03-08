command! LogAutocmds call s:log_autocmds_toggle()

function! s:log_autocmds_toggle()
  augroup LogAutocmd
    autocmd!
  augroup END

  let l:date = strftime('%F', localtime())
  let s:activate = get(s:, 'activate', 0) ? 0 : 1
  if !s:activate
    call s:log('Stopped autocmd log (' . l:date . ')')
    return
  endif

  call s:log('Started autocmd log (' . l:date . ')')
  augroup LogAutocmd
    for l:au in s:aulist
      silent execute 'autocmd' l:au '* call s:log(''' . l:au . ''')'
    endfor
  augroup END
endfunction

function! s:log(message)
  silent execute '!echo "'
        \ . strftime('%T', localtime()) . ' - ' . a:message . '"'
        \ '>> /tmp/vim_log_autocommands'
endfunction

" These are deliberately left out due to side effects
" - SourceCmd
" - FileAppendCmd
" - FileWriteCmd
" - BufWriteCmd
" - FileReadCmd
" - BufReadCmd
" - FuncUndefined
" - UserGettingBored
" - SafeState

let s:aulist = [
      \ 'BufNewFile',
      \ 'BufAdd',
      \ 'BufDelete',
      \ 'BufEnter',
      \ 'BufFilePost',
      \ 'BufFilePre',
      \ 'BufHidden',
      \ 'BufLeave',
      \ 'BufModifiedSet',
      \ 'BufNew',
      \ 'BufNewFile',
      \ 'BufRead',
      \ 'BufReadPre',
      \ 'BufUnload',
      \ 'BufWinEnter',
      \ 'BufWinLeave',
      \ 'BufWipeout',
      \ 'BufWrite',
      \ 'BufWritePost',
      \ 'ChanInfo',
      \ 'ChanOpen',
      \ 'CmdUndefined',
      \ 'CmdlineChanged',
      \ 'CmdlineEnter',
      \ 'CmdlineLeave',
      \ 'CmdwinEnter',
      \ 'CmdwinLeave',
      \ 'ColorScheme',
      \ 'ColorSchemePre',
      \ 'CompleteChanged',
      \ 'CompleteDonePre',
      \ 'CompleteDone',
      \ 'CursorHold',
      \ 'CursorHoldI',
      \ 'CursorMoved',
      \ 'CursorMovedI',
      \ 'DiffUpdated',
      \ 'DirChanged',
      \ 'DirChangedPre',
      \ 'ExitPre',
      \ 'FileAppendPost',
      \ 'FileAppendPre',
      \ 'FileChangedRO',
      \ 'FileChangedShell',
      \ 'FileChangedShellPost',
      \ 'FileReadPost',
      \ 'FileReadPre',
      \ 'FileType',
      \ 'FileWritePost',
      \ 'FileWritePre',
      \ 'FilterReadPost',
      \ 'FilterReadPre',
      \ 'FilterWritePost',
      \ 'FilterWritePre',
      \ 'FocusGained',
      \ 'FocusLost',
      \ 'UIEnter',
      \ 'UILeave',
      \ 'InsertChange',
      \ 'InsertCharPre',
      \ 'InsertEnter',
      \ 'InsertLeavePre',
      \ 'InsertLeave',
      \ 'MenuPopup',
      \ 'ModeChanged',
      \ 'OptionSet',
      \ 'QuickFixCmdPre',
      \ 'QuickFixCmdPost',
      \ 'QuitPre',
      \ 'RemoteReply',
      \ 'SearchWrapped',
      \ 'RecordingEnter',
      \ 'RecordingLeave',
      \ 'SessionLoadPost',
      \ 'ShellCmdPost',
      \ 'Signal',
      \ 'ShellFilterPost',
      \ 'SourcePre',
      \ 'SourcePost',
      \ 'SpellFileMissing',
      \ 'StdinReadPost',
      \ 'StdinReadPre',
      \ 'SwapExists',
      \ 'Syntax',
      \ 'TabEnter',
      \ 'TabLeave',
      \ 'TabNew',
      \ 'TabNewEntered',
      \ 'TabClosed',
      \ 'TermOpen',
      \ 'TermEnter',
      \ 'TermLeave',
      \ 'TermClose',
      \ 'TermRequest',
      \ 'TermResponse',
      \ 'TextChanged',
      \ 'TextChangedI',
      \ 'TextChangedP',
      \ 'TextChangedT',
      \ 'TextYankPost',
      \ 'User',
      \ 'VimEnter',
      \ 'VimLeave',
      \ 'VimLeavePre',
      \ 'VimResized',
      \ 'VimResume',
      \ 'VimSuspend',
      \ 'WinClosed',
      \ 'WinEnter',
      \ 'WinLeave',
      \ 'WinNew',
      \ 'WinScrolled',
      \ 'WinResized',
      \ ]
