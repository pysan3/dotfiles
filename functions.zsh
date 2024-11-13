# [ -n "${DOTFILES_FUNCTIONS}" ] && return; export readonly DOTFILES_FUNCTIONS=0;

function error () {
  ( tput setaf 1; echo "ERROR $@"; tput sgr0 ) 1>&2
}

function warning () {
  ( tput setaf 3; echo "WARNING $@"; tput sgr0 ) 1>&2
}

function info () {
  ( tput setaf 2; echo -n "INFO "; tput sgr0; echo "$@" ) 1>&2
}

function err_exit () {
  error "$@"
  exit 1
}

# warning 'dotfiles/functions.zsh is being loaded'

function checkyes () {
  local result=1
  tput setaf 6
  printf "$@ [y/N]: " && read yn
  case "$yn" in
    [yY]*) local result=0 ;;
    [qQ]*) exit 0 ;;
    *) local result=1 ;;
  esac
  tput sgr0
  return $result
}

function checkdependency () {
  if command -v "$1" >/dev/null 2>&1; then
    return 0
  else
    error "You do not have '$1' installed."
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

true
