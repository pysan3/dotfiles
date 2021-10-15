#!/bin/zsh

DOTFILES="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
source "$DOTFILES/functions.zsh"

# install haskel interpreter
if [ ! -d ~/.ghcup ] || [ ! command -v cabal &> /dev/null ] || [ ! command -v pandoc &> /dev/null ]; then
    cd
    wget -qO- https://get-ghcup.haskell.org | sh
    stack setup
    . "$HOME/.ghcup/env"
    cabal --version
    cabal new-update
    cabal new-install pandoc
    cabal new-install pandoc-citeproc pandoc-crossref
fi
[ -f "~/.ghcup/env" ] && source "~/.ghcup/env" # ghcup-env

# install zsh shell utils
mkdir -p ~/.zsh
if [ ! -f ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
    git clone git://github.com/zsh-users/zsh-syntax-highlighting.git ~/.zsh/zsh-syntax-highlighting
    zcompile ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi
if [ ! -f ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
    git clone git://github.com/zsh-users/zsh-autosuggestions.git ~/.zsh/zsh-autosuggestions
    zcompile ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

# install poetry
if ! command -v 'poetry' &> /dev/null; then
    curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py | python -
fi

# install ruby
if [ ! -d ~/.rbenv ]; then
    git clone https://github.com/rbenv/rbenv.git ~/.rbenv
    git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
fi
export PATH="$PATH:$HOME/.rbenv/bin"
CONFIGURE_OPTS='--disable-install-rdoc' rbenv install $(rbenv install -l | grep -v - | tail -1)
rbenv global $(rbenv install -l | grep -v - | tail -1)

# RUST
if ! command -v 'cargo' &> /dev/null; then
    checkyes "Seems you don't have cargo installed. Install?"
    if [ $? -eq 0 ]; then
        wget -qO - https://sh.rustup.rs | sh
        source ~/.cargo/env
    else
        echo 'Press C-c to exit and install cargo manually.'
        read tmp
    fi
fi
while IFS= read -r line; do
    if [ 'x#' = x${line:0:1} ]; then continue; fi
    IFS='=' read -r -A cmdArr <<< "$line"
    # add one dummy in bash because zsh array is 1-index
    if [[ x$(basename $SHELL) = x'bash' ]]; then
        cmdArr="tmp $cmdArr"
    fi
    cmd=${cmdArr[1]}
    alt=${cmdArr[2]}
    issudo=""
    if [[ x"$alt" == xsudo* ]]; then
        alt="${alt:5}"
        issudo="sudo "
    fi
    if [ ${#cmdArr[@]} -gt 2 ]; then
        pkg=${cmdArr[3]}
    else
        pkg="$alt"
    fi
    if ! command -v $alt &> /dev/null; then
        checkyes "$alt not installed. Do you want to install with cargo?"
        if [ $? -eq 0 ]; then
            cargo install -v $pkg -f
        else
            echo "failed to create alias from '$cmd' to '$alt': command not found"
            continue
        fi
    fi
    eval "alias $cmd='$issudo$alt'"
done < "$HOME/dotfiles/list_rust_packages.txt"

# install nvim
if ! command -v nvim &> /dev/null; then
    echo 'It seems neovim is not installed. Commands bellow will be called.'
    echo 'sudo apt install neovim'
    echo 'sudo apt install python-neovim'
    echo 'sudo apt install python3-neovim'
    checkyes 'Proceed? '
    if [ $? -eq 0 ]; then
        sudo apt install neovim
        sudo apt install python-neovim
        sudo apt install python3-neovim
    else
        echo 'Please install manually. https://github.com/neovim/neovim/wiki/Installing-Neovim'
    fi
fi

# install coc extensions
set -o nounset    # error when referencing undefined variable
set -o errexit    # exit when command fails
mkdir -p ~/.config/coc/extensions
cd ~/.config/coc/extensions
if [ ! -f package.json ]; then
  echo '{"dependencies":{}}'> package.json
fi
if ! checkdependency 'npm'; then
    exit
fi
npm install \
    coc-diagnostic \
    coc-explorer \
    coc-lists \
    coc-dictionary \
    coc-word \
    coc-emoji \
    coc-snippets \
    coc-tsserver \
    coc-eslint \
    coc-prettier \
    coc-vetur \
    coc-json \
    coc-python \
    coc-pyright \
    coc-protobuf \
    coc-vimtex \
    coc-texlab \
    coc-sh \
    coc-yaml \
    --global-style --ignore-scripts --no-bin-links --no-package-lock --only=prod
cd -
