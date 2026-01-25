#!/usr/bin/zsh

prepends='' appends=''
function _prepend() {
  prepends="$1:$prepends"
}
function _append() {
  appends="$appends:$1"
}

# js
export NVM_COMPLETION=true NVM_LAZY_LOAD=true
export NVM_LAZY_LOAD_EXTRA_COMMANDS=('vim' 'nvim' 'yarn')
source "$XDG_DATA_HOME/zsh/zsh-nvm/zsh-nvm.plugin.zsh"
_append "$PNPM_HOME"

# Python
_prepend "$PYENV_ROOT/bin:$PYENV_ROOT/shims:$PYENV_ROOT/versions/global/bin:$POETRY_HOME/bin"

# Golang
_prepend "$GOPATH/bin"

# alias to command line utils
_prepend "$CARGO_HOME/bin"
[ -f "${CARGO_ALIAS_CACHE:=$XDG_CACHE_HOME/cargo/alias_local.zsh}" ] && source "$CARGO_ALIAS_CACHE"

# Nim
_append "$HOME/.nimble/bin"

[[ "$PATH" == *"$prepends"* ]] || export PATH="$prepends:$PATH"
[[ "$PATH" == *"$appends"* ]] || export PATH="$PATH:$appends"
unset -f _prepend
unset -f _append
unset prepends
unset appends

export PATH="$XDG_BIN_HOME:$PATH"

true
