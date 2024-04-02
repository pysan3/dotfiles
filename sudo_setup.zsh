#!/usr/bin/zsh

if [[ 'xdotfiles' != x$(basename ${DOTFILES:=$HOME/dotfiles}) ]]; then
  echo "install_base.zsh might not be placed in the right place."
  echo "Try running it inside dotfile directory."
  exit
fi

source "$DOTFILES/.zshenv"
unset DOTFILES_FUNCTIONS && source "$DOTFILES/functions.zsh"
setopt sh_word_split

if command -v 'apt-get' &>/dev/null || checkyes 'apt-get available?'; then
  alias apti="sudo apt-get install -y"
  # install_base.zsh dependencies
  apti moreutils atool
  # python build dependencies (for pyenv)
  apti make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev xz-utils tk-dev libffi-dev liblzma-dev python-openssl git python3-distutils-extra python-distutils-extra
  # nvim dependencies (build latest on my own)
  apti ninja-build gettext libtool libtool-bin autoconf automake cmake g++ pkg-config unzip curl doxygen
  # tmux dependencies (build latest on my own)
  apti libevent ncurses libevent-dev ncurses-dev build-essential bison pkg-config
  # words (use for spell check)
  apti wamerican
fi

if command -v 'pacman' &>/dev/null || checkyes 'pacman available?'; then
  use_yay=false
  if command -v 'yay' &>/dev/null || checkyes 'install yay via pacman?'; then
    use_yay=true
  fi
  set -xe
  alias pacman="sudo pacman --noconfirm --sudoloop"
  pacman -Syu
  # basics
  pacman -S base-devel neofetch git tmux vim curl moreutils atool
  # nvim dependencies
  pacman -S base-devel cmake unzip ninja tree-sitter curl
  # python dependencies
  pacman -S base-devel openssl zlib xz tk python python-pip python-virtualenv python-pipenv \
    python-gobject python-wxpython python-yaml python-xlib python-utils python-pyopenssl \
    poppler-glib python-distutils-extra python-pip python-gobject gtk3 python-cairo libhandy
  # texlive
  # pacman -S texlive-full
  # yay
  if [ "$use_yay" = true ]; then
    command -v 'yay' &>/dev/null || pacman -S yay
  else
    error 'yay not found'
    exit 1
  fi
  alias yay="yay --noconfirm --sudoloop"
  # utils
  yay -S bmon btop
  # words
  yay -S words
  # xdg portals
  yay -S xdg-desktop-portal-kde xdg-desktop-portal-gtk xdg-desktop-portal-gnome
  # plemol install
  yay -S fontforge
  # wayland stuffs
  yay -S clipboard-sync
  # delete all cache
  pacman -Scc
  yay -Scc
  set +xe
fi

if command -v 'brew' &>/dev/null; then
  # basics
  brew install wget moreutils
  # neovim
  xcode-select --install
  brew install ninja cmake gettext curl
  # lua
  brew install luajit luarocks
  # apps
  brew install tmux htop btop gh lynx
  # protobuf
  brew install protobuf
fi
