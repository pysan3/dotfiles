#!/usr/bin/zsh

if [[ 'xdotfiles' != x$(basename ${DOTFILES:=$HOME/dotfiles}) ]]; then
  echo "install_base.zsh might not be placed in the right place."
  echo "Try running it inside dotfile directory."
  exit
fi

source "$DOTFILES/.zshenv"
unset DOTFILES_FUNCTIONS && source "$DOTFILES/functions.zsh"
setopt sh_word_split

if checkyes 'apt-get available?'; then
  # python build dependencies
  sudo apt-get install -y make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev xz-utils tk-dev libffi-dev liblzma-dev python-openssl git
  # btop dependencies
  sudo apt-get install -y coreutils sed git build-essential
  sudo apt-get install -y gcc-11 g++-11 || sudo apt-get install -y gcc-10 g++-10
  # bmon dependencies
  sudo apt-get install -y build-essential make libconfuse-dev libnl-3-dev libnl-route-3-dev libncurses-dev pkg-config dh-autoreconf
  # nvim dependencies
  sudo apt-get -y install ninja-build gettext libtool libtool-bin autoconf automake cmake g++ pkg-config unzip curl doxygen
fi

if checkyes 'pacman available?'; then
  # nvim dependencies
  sudo pacman -S base-devel cmake unzip ninja tree-sitter curl
fi