function! SourceIfExists(file)
  if filereadable(expand(a:file))
    exe 'source' a:file
  endif
endfunction
command! -nargs=1 SourceIF call SourceIfExists(<f-args>)

SourceIF $HOME/.config/nvim/vim-plug/plugins.vim
SourceIF $HOME/.config/nvim/general/settings.vim
SourceIF $HOME/.config/nvim/keys/mappings.vim
" SourceIF $HOME/.config/nvim/keys/which-key.vim
SourceIF $HOME/.config/nvim/autoload/plug.vim
SourceIF $HOME/.config/nvim/themes/airline.vim
SourceIF $HOME/.config/nvim/themes/environtheme.vim
SourceIF $HOME/.config/nvim/plug-config/coc.vim
" SourceIF $HOME/.config/nvim/plug-config/fzf.vim
SourceIF $HOME/.config/nvim/plug-config/signify.vim
SourceIF $HOME/.config/nvim/plug-config/firenvim.vim
" SourceIF $HOME/.config/nvim/plug-config/fugitive.vim
SourceIF $HOME/.config/nvim/plug-config/sneak.vim
SourceIF $HOME/.config/nvim/plug-config/neogit.vim
SourceIF $HOME/.config/nvim/plug-config/telescope.vim
SourceIF $HOME/.config/nvim/plug-config/undotree.vim
SourceIF $HOME/.config/nvim/plug-config/start-screen.vim
SourceIF $HOME/.config/nvim/plug-config/vim-math.vim
SourceIF $HOME/.config/nvim/plug-config/vim-markdown.vim
SourceIF $HOME/.config/nvim/plug-config/vimtex.vim
SourceIF $HOME/.config/nvim/plug-config/dragvisuals.vim
SourceIF $HOME/.config/nvim/plug-config/asyncrun.vim
SourceIF $HOME/.config/nvim/plug-config/auto-pairs.vim
SourceIF $HOME/.config/nvim/plug-config/expand-region.vim
SourceIF $HOME/.config/nvim/plug-config/zen-mode.vim
" SourceIF $HOME/.config/nvim/syntax/markdown.vim
SourceIF $HOME/.config/nvim/myplug/autosave-session.vim
SourceIF $HOME/.config/nvim/myplug/terminal-as-vscode.vim
SourceIF $HOME/.config/nvim/myplug/easy-commit.vim
SourceIF $HOME/.config/nvim/myplug/load-local-config.vim
