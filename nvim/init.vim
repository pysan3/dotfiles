function! SourceIFExists(file)
  if filereadable(expand(a:file))
    exe 'source' a:file
  endif
endfunction
command! -nargs=1 SourceIF call SourceIFExists(<f-args>)

lua require 'plug-config.00-plugins'
SourceIF $HOME/.config/nvim/general/settings.vim
SourceIF $HOME/.config/nvim/keys/mappings.vim
lua require 'plug-config.airbufferline'
lua require 'themes.envtheme'
lua require 'plug-config.n-notify'
lua require 'lsp-config.n-cmp'
lua require 'lsp-config.n-lsp-init'
lua require 'plug-config.n-tree'
lua require 'plug-config.n-autopairs'
lua require 'plug-config.telescope'
lua require 'plug-config.treesitter'
lua require 'plug-config.comment'
lua require 'plug-config.n-fugitive'
lua require 'plug-config.n-neogit'
lua require 'plug-config.toggleterm'

lua require 'plug-config.undotree'
lua require 'plug-config.vim-math'
SourceIF $HOME/.config/nvim/plug-config/vim-markdown.vim
lua require 'plug-config.dragvisuals'
lua require 'plug-config.expand-region'
lua require 'plug-config.zen-mode'
" TODO
SourceIF $HOME/.config/nvim/plug-config/start-screen.vim
SourceIF $HOME/.config/nvim/plug-config/vimtex.vim

SourceIF $HOME/.config/nvim/plug-config/firenvim.vim
SourceIF $HOME/.config/nvim/plug-config/sneak.vim

SourceIF $HOME/.config/nvim/myplug/autosave-session.vim
SourceIF $HOME/.config/nvim/myplug/terminal-as-vscode.vim
SourceIF $HOME/.config/nvim/myplug/easy-commit.vim
SourceIF $HOME/.config/nvim/myplug/load-local-config.vim
SourceIF $HOME/.config/nvim/local.vim

