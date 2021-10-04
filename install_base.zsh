#!/bin/zsh

source "$DOTFILES/functions.sh"

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
fi
if [ ! -f ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
    git clone git://github.com/zsh-users/zsh-autosuggestions.git ~/.zsh/zsh-autosuggestions
fi

# install poetry
if ! command -v 'poetry' &> /dev/null; then
    curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py | python -
fi

# RUST
if [ -f ~/.cargo/env ]; then
    source ~/.cargo/env
else
    export PATH="$PATH:$HOME/.cargo/bin"
fi
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
            cargo install -v $pkg
        else
            echo "failed to create alias from '$cmd' to '$alt': command not found"
            continue
        fi
    fi
    eval "alias $cmd='$issudo$alt'"
done < "$HOME/dotfiles/list_rust_packages.txt"
