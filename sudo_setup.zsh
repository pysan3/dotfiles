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
  # python build dependencies
  sudo apt-get install -y make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev xz-utils tk-dev libffi-dev liblzma-dev python-openssl git python3-distutils-extra python-distutils-extra
  # btop dependencies
  sudo apt-get install -y coreutils sed git build-essential
  sudo apt-get install -y gcc-11 g++-11 || sudo apt-get install -y gcc-10 g++-10
  # bmon dependencies
  sudo apt-get install -y build-essential make libconfuse-dev libnl-3-dev libnl-route-3-dev libncurses-dev pkg-config dh-autoreconf
  # nvim dependencies
  sudo apt-get -y install ninja-build gettext libtool libtool-bin autoconf automake cmake g++ pkg-config unzip curl doxygen
  # tmux dependencies
  sudo apt-get install -y libevent ncurses libevent-dev ncurses-dev build-essential bison pkg-config
  # nix dependencies
  sudo apt-get install -y autoconf automake libtool m4 autoconf-archive pkg-config libboost-all-dev libarchive-dev bison flex libsodium-dev libseccomp-dev sqlite3 curl libgc-dev libgtest-dev
  # pandoc
  sudo apt-get install -y pandoc
fi

if command -v 'pacman' &>/dev/null || checkyes 'pacman available?'; then
  set -x
  sudo pacman -Syu
  # basics
  sudo pacman -S base-devel neofetch git tmux vim curl moreutils
  # nvim dependencies
  sudo pacman -S base-devel cmake unzip ninja tree-sitter curl
  # python dependencies
  sudo pacman -S base-devel openssl zlib xz tk python python-pip python-virtualenv python-pipenv \
    python-gobject python-wxpython python-yaml python-xlib python-utils python-pyopenssl \
    poppler-glib python-distutils-extra python-pip python-gobject gtk3 python-cairo libhandy
  # texlive
  sudo pacman -S texlive-full
  # pandoc
  sudo pacman -S pandoc
  # delete all cache
  sudo pacman -Scc
  set +x
fi
