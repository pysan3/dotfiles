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
  # install_base.zsh dependencies
  sudo apt-get install -y moreutils
  # python build dependencies (for pyenv)
  sudo apt-get install -y make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev xz-utils tk-dev libffi-dev liblzma-dev python-openssl git python3-distutils-extra python-distutils-extra
  # nvim dependencies (build latest on my own)
  sudo apt-get -y install ninja-build gettext libtool libtool-bin autoconf automake cmake g++ pkg-config unzip curl doxygen
  # tmux dependencies (build latest on my own)
  sudo apt-get install -y libevent ncurses libevent-dev ncurses-dev build-essential bison pkg-config
  # words (use for spell check)
  sudo apt-get install -y wamerican
  # btop dependencies (better monitoring tool)
  sudo apt-get install -y coreutils sed git build-essential
  sudo apt-get install -y gcc-11 g++-11 || sudo apt-get install -y gcc-10 g++-10
  # bmon dependencies (better monitoring tool)
  sudo apt-get install -y build-essential make libconfuse-dev libnl-3-dev libnl-route-3-dev libncurses-dev pkg-config dh-autoreconf
fi

if command -v 'pacman' &>/dev/null || checkyes 'pacman available?'; then
  use_yay=false
  if command -v 'yay' &>/dev/null || checkyes 'install yay via pacman?'; then
    use_yay=true
  fi
  set -xe
  sudo pacman --noconfirm -Syu
  # basics
  sudo pacman --noconfirm -S base-devel neofetch git tmux vim curl moreutils
  # nvim dependencies
  sudo pacman --noconfirm -S base-devel cmake unzip ninja tree-sitter curl
  # python dependencies
  sudo pacman --noconfirm -S base-devel openssl zlib xz tk python python-pip python-virtualenv python-pipenv \
    python-gobject python-wxpython python-yaml python-xlib python-utils python-pyopenssl \
    poppler-glib python-distutils-extra python-pip python-gobject gtk3 python-cairo libhandy
  # texlive
  # sudo pacman --noconfirm -S texlive-full
  # yay
  if [ "$use_yay" = true ]; then
    command -v 'yay' &>/dev/null || sudo pacman --noconfirm -S yay
  else
    error 'yay not found'
    exit 1
  fi
  # words
  yay --noconfirm -S words
  # xdg portals
  yay --noconfirm -S xdg-desktop-portal-kde xdg-desktop-portal-gtk xdg-desktop-portal-gnome
  # delete all cache
  sudo pacman --noconfirm -Scc
  yay --noconfirm -Scc
  set +xe
fi
