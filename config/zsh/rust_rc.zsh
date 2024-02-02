#!/usr/bin/zsh

prepends='' appends=''
function _prepend() {
  prepends="$1:$prepends"
}
function _append() {
  appends="$appends:$1"
}

# js
function load_nvm () {
  [ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"
  [[ "$PATH" == *"$PNPM_HOME"* ]] || export PATH="$PATH:$PNPM_HOME"
}
async_start_worker nvm_worker -n
async_register_callback nvm_worker load_nvm
async_job nvm_worker sleep 0.1

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

true
