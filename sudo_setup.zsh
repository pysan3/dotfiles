#!/usr/bin/zsh

if [[ 'xdotfiles' != x$(basename ${DOTFILES:=$HOME/dotfiles}) ]]; then
  echo "install_base.zsh might not be placed in the right place."
  echo "Try running it inside dotfile directory."
  exit
fi

source "$DOTFILES/.zshenv"
unset DOTFILES_FUNCTIONS && source "$DOTFILES/functions.zsh"
setopt sh_word_split

if command -v 'apt' &>/dev/null || checkyes 'apt available?'; then
  # install_base.zsh dependencies
  sudo apt install -y moreutils atool
  # python build dependencies (for pyenv)
  sudo apt install -y make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev xz-utils tk-dev libffi-dev liblzma-dev python3-openssl git python3-distutils-extra
  # nvim dependencies (build latest on my own)
  sudo apt install -y ninja-build gettext libtool libtool-bin autoconf automake cmake g++ pkg-config unzip curl doxygen
  # tmux dependencies (build latest on my own)
  sudo apt install -y libevent ncurses libevent-dev ncurses-dev build-essential bison pkg-config
  # words (use for spell check)
  sudo apt install -y wamerican
fi

if command -v 'dnf' &>/dev/null || checkyes 'dnf (Amazon Linux 2023) available?'; then
  # base toolchain (gcc, g++, make, patch, autoconf, automake, libtool, bison, ...)
  sudo dnf groupinstall -y 'Development Tools'
  # install_base.zsh dependencies
  # NOTE: `moreutils` and `atool` do NOT exist in the AL2023 repos and EPEL is not
  # compatible with AL2023 (https://github.com/amazonlinux/amazon-linux-2023/issues/146).
  # sponge is built from moreutils source below; atool has no substitute here.
  warning 'atool is unavailable on Amazon Linux 2023.'
  # --allowerasing: AL2023 ships curl-minimal which conflicts with full curl
  sudo dnf install -y --allowerasing git curl wget tar gzip unzip
  # python build dependencies (for pyenv)
  sudo dnf install -y make gcc patch zlib-devel bzip2 bzip2-devel readline-devel \
    sqlite sqlite-devel openssl-devel tk-devel libffi-devel xz-devel ncurses-devel gdbm-devel
  # nvim dependencies (build latest on my own)
  sudo dnf install -y ninja-build cmake gcc gcc-c++ make gettext glibc-gconv-extra \
    unzip doxygen libtool autoconf automake pkgconf-pkg-config
  # tmux dependencies (build latest on my own)
  sudo dnf install -y ncurses-devel bison pkgconf-pkg-config
  sudo dnf install -y libevent-devel \
    || warning 'libevent-devel not found in enabled repos; tmux build will fail without it (base libevent exists in AL2023)'
  # words (use for spell check)
  sudo dnf install -y words
  # sponge (moreutils is not packaged for AL2023; build only sponge from the official
  # upstream — `make sponge` compiles sponge.c standalone, no docbook/perl needed)
  if ! command -v 'sponge' &>/dev/null; then
    moreutils_tmp=$(mktemp -d)
    git clone --depth 1 --branch 0.70 https://git.joeyh.name/git/moreutils.git "$moreutils_tmp" \
      && make -C "$moreutils_tmp" sponge \
      && sudo install -m 755 "$moreutils_tmp/sponge" /usr/local/bin/sponge \
      || error 'Failed to build sponge from moreutils source'
    rm -rf "$moreutils_tmp"
  fi
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
  # yazi
  yay -S yazi ffmpeg 7zip jq poppler fd ripgrep fzf zoxide resvg imagemagick
  # delete all cache
  pacman -Scc
  yay -Scc
  set +xe
fi

if command -v 'brew' &>/dev/null; then
  # neovim build dependency
  xcode-select --install
  brew bundle --file "$DOTFILES/config/brewfile/Brewfile"
fi
