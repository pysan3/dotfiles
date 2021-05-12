#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

if [[ 'xdotfiles' != x$(basename $DIR) ]]; then
    echo "install.sh might not be placed in the right place."
    echo "Try running it inside dotfile directory."
    exit
fi

WORKDIR=$PWD
cd $DIR
for f in `command ls -ap | grep -v / | grep -v '.session.vim'`; do
    if [ -f "$HOME/$f" ]; then
        echo "$HOME/$f: Symbolic link already exists."
    else
        echo "Creating a symbolic link of $f in $HOME"
        ln -s "$DIR/$f" "$HOME/$f"
    fi
done
if [ -z "$XDG_CONFIG_HOME" ]; then
    echo 'setting $XDG_CONFIG_HOME to '"$HOME/.config"
    XDG_CONFIG_HOME="$HOME/.config"
fi
if [ -d ./nvim ]; then
    mkdir -p "$XDG_CONFIG_HOME/nvim/session"
    mkdir -p "$XDG_CONFIG_HOME/nvim/undodir"
    cp -rs "$DIR/nvim" "$XDG_CONFIG_HOME"
    if ! command -v nvim &> /dev/null; then
        echo -n 'It seems neovim is not installed. Install? '
        result=0
        if [[ $SHELL == *'bash'* ]]; then
            read -n1 -p "[Y/n] " yn; if [[ $yn =~ n|N ]]; then result=1; fi
        elif [[ $SHELL == *'zsh'* ]]; then
            if read -q; then :; else result=1; fi
        else
            echo 'Could not detect which shell you are using. Please install manually.'
            echo 'https://github.com/neovim/neovim/wiki/Installing-Neovim'
            result=1
        fi
        echo
        if [ $result -eq 0 ]; then
            sudo apt install neovim
            sudo apt install python-neovim
            sudo apt install python3-neovim
        fi
    fi
fi

cd $WORKDIR

