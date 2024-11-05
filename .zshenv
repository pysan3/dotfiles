export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_PREFIX_HOME="$HOME/.local"
export XDG_DATA_HOME="$XDG_PREFIX_HOME/share"
export XDG_STATE_HOME="$XDG_PREFIX_HOME/state"
export XDG_BIN_HOME="$XDG_PREFIX_HOME/bin"
[[ "$PATH" == *"$XDG_BIN_HOME"* ]] || export PATH="$XDG_BIN_HOME:$PATH"

ZDOTDIR="$XDG_CONFIG_HOME/zsh"
export GIT_SSH_COMMAND="ssh -i $HOME/.ssh/id_git"
export SUDO_EDITOR=nvim
export CABAL_CONFIG="$XDG_CONFIG_HOME/cabal/config"
export CABAL_DIR="$XDG_CACHE_HOME/cabal"
export CARGO_HOME="$XDG_DATA_HOME/cargo"
export CARGO_REGISTRIES_CRATES_IO_PROTOCOL=git
export DOCKER_CONFIG="$XDG_CONFIG_HOME/docker"
export FZF_DEFAULT_OPTS='--height=40% --cycle --info=hidden --tabstop=4 --black'
export GHCUP_USE_XDG_DIRS=1
export STACK_ROOT="$XDG_DATA_HOME/stack"
export GOPATH="$XDG_DATA_HOME/go"
export GNUPGHOME="$XDG_DATA_HOME/gnupg"
export GTK_RC_FILES="$XDG_CONFIG_HOME/gtk-1.0/gtkrc"
export GTK2_RC_FILES="$XDG_CONFIG_HOME/gtk-2.0/gtkrc"
export JULIA_DEPOT_PATH="$XDG_DATA_HOME/julia:$JULIA_DEPOT_PATH"
export KDEHOME="$XDG_CONFIG_HOME/kde"
export LEIN_HOME="$XDG_DATA_HOME/lein"
export LYNX_CFG="$XDG_CONFIG_HOME/lynx/lynx.cfg"
export LYNX_LSS="$XDG_CONFIG_HOME/lynx/lynx.lss"
export LYNX_USERAGENT="Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_0) AppleWebKit/537.1 (KHTML, like Gecko) Chrome/21.0.1180.79 Safari/537.1 Lynx"
export MPLAYER_HOME="$XDG_CONFIG_HOME/mplayer"
export NODE_REPL_HISTORY="$XDG_DATA_HOME/node_repl_history"
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/npmrc"
export PNPM_HOME="$XDG_DATA_HOME/pnpm"
export BUN_INSTALL="$XDG_DATA_HOME/bun"
export NVM_DIR="$XDG_DATA_HOME/nvm"
export PYENV_ROOT="$XDG_DATA_HOME/pyenv"
export POETRY_HOME="$XDG_DATA_HOME/poetry"
export PYTHONSTARTUP="$XDG_CONFIG_HOME/python/pythonrc.py"
export PTPYTHON_CONFIG_HOME="$XDG_CONFIG_HOME/ptpython"
export CONDARC="$XDG_CONFIG_HOME/conda/condarc"
export MAMBA_ROOT_PREFIX="$XDG_DATA_HOME/micromamba"
export RBENV_ROOT="$XDG_DATA_HOME/rbenv"
export GEM_HOME="$XDG_DATA_HOME/gem"
export GEM_SPEC_CACHE="$XDG_CACHE_HOME/gem"
export RUSTUP_HOME="$XDG_DATA_HOME/rustup"
export WGETRC="$XDG_CONFIG_HOME/wgetrc"
export SSB_HOME="$XDG_DATA_HOME/zoom"
export HOMEBREW_NO_AUTO_UPDATE=1

export GTK_USE_PORTAL=1
# export XMODIFIERS='@im=fcitx'
# export GTK_IM_MODULE='fcitx'
# export QT_IM_MODULE='fcitx'
# export SDL_IM_MODULE='fcitx'
