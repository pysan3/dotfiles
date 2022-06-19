function! SourceIFExists(file)
  if filereadable(expand(a:file))
    exe 'source' a:file
  endif
endfunction
command! -nargs=1 SourceIF call SourceIFExists(<f-args>)

SourceIF $HOME/.config/nvim/general/settings.vim
SourceIF $HOME/.config/nvim/keys/mappings.vim
lua require 'general.settings'
lua require 'plug-config'

SourceIF $HOME/.config/nvim/local.vim

