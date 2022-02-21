# [ -n "${DOTFILES_FUNCTIONS}" ] && return; export readonly DOTFILES_FUNCTIONS=0;

function error () {
  tput setaf 1; echo "ERROR; $@" 1>&2; tput sgr0
}

function warning () {
  tput setaf 3; echo "WARNING; $@" 1>&2; tput sgr0
}

function info () {
  tput setaf 2; echo -n "INFO; "; tput sgr0; echo "$@"
}

# warning 'dotfiles/functions.zsh is being loaded'

function checkyes() {
  result=1
  if [[ x$(basename $SHELL) = x'bash' ]]; then
    read -p "$@ [y/N]: " yn; case "$yn" in [yY]*) result=0;; *) result=1;; esac
  elif [[ x$(basename $SHELL) = x'zsh' ]]; then
    printf "$@ [y/N]: "; if read -q; then result=0; else result=1; fi; echo
  fi
  return $result
}

function checkdependency () {
  if command -v "$1" >/dev/null 2>&1; then
    return 0
  else
    error 'Seems you do not have `'"$1"'`$1 installed.'
    error 'Install it and run this script again'
    return 1
  fi
}

function followlink () {
  if command -v 'readlink' >/dev/null 2>&1; then
    eval "readlink $@"
  elif command -v 'greadlink' >/dev/null 2>&1; then
    eval 'greadlink $@'
  else
    error "No command to follow link found. Please install readlink(Linux) or greadlink(Mac)"
  fi
}

