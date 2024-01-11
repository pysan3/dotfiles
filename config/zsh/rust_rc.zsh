#!/usr/bin/zsh

function add_completions() {
  # cmd="$1"; cache_file="$2"
  if [ ! -f "$2" ]; then
    eval "$1" > "$2"
  fi
  source "$2"
}

prepends='' appends=''
function _prepend() {
  prepends="$1:$prepends"
}
function _append() {
  appends="$appends:$1"
}

# js
local nvm_version=$(cat "$NVM_DIR/alias/default")
_prepend "$NVM_DIR/versions/node/v${nvm_version}/bin"
alias nvm="unalias nvm 2>/dev/null; source $NVM_DIR/nvm.sh; rehash; nvm"

# Python
_prepend "$PYENV_ROOT/bin:$PYENV_ROOT/shims:$PYENV_ROOT/versions/global/bin:$POETRY_HOME/bin"

# Python
_prepend "$GOPATH/bin"

# alias to command line utils
_append "$CARGO_HOME/bin"
[ -f "${CARGO_ALIAS_CACHE:=$XDG_CACHE_HOME/cargo/alias_local.zsh}" ] && source "$CARGO_ALIAS_CACHE"

# Nim
_append "$HOME/.nimble/bin"

[[ "$PATH" == *"$prepends"* ]] || export PATH="$prepends:$PATH"
[[ "$PATH" == *"$appends"* ]] || export PATH="$PATH:$appends"
unset -f _prepend
unset -f _append
unset prepends
unset appends

true
