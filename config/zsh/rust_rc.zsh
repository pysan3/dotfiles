#!/usr/bin/zsh

function add_completions() {
  # cmd="$1"; cache_file="$2"
  if [ ! -f "$2" ]; then
    eval "$1" > "$2"
  fi
  source "$2"
}

function _prepend() {
  [[ "$PATH" == *"$1"* ]] || export PATH="$1:$PATH"
}
function _append() {
  [[ "$PATH" == *"$1"* ]] || export PATH="$PATH:$1"
}

# js
[ -s "$NVM_DIR"/nvm.sh ] && source "$NVM_DIR"/nvm.sh
_prepend "$PNPM_HOME:$(npm config get prefix)/bin"
export MANPATH="${MANPATH-$(manpath)}:$NPM_PACKAGES/share/man"

# Haskel
_append "$XDG_CACHE_HOME/cabal/bin"

# Python
_prepend "$PYENV_ROOT/bin:$PYENV_ROOT/shims:$POETRY_HOME/bin"

# alias to command line utils
_append "$CARGO_HOME/bin"
[ -f "${CARGO_ALIAS_CACHE:=$XDG_CACHE_HOME/cargo/alias_local.zsh}" ] && source "$CARGO_ALIAS_CACHE"

unset -f _prepend
unset -f _append
true
