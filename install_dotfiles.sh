#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

if [[ 'xdotfiles' != x$(basename $DIR) ]]; then
    echo "install.sh might not be placed in the right place."
    echo "Try running it inside dotfile directory."
    exit
fi

WORKDIR=$PWD
cd $DIR
for f in `command ls -Ap | grep -v / | grep -v '.session.vim' | grep -v 'test' | grep -v 'tmp'`; do
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
for f in `command find "config" -type f`; do
    file=${f#"config/"}
    if [ ! -f "$XDG_CONFIG_HOME/$file" ]; then
        mkdir -p `dirname "$XDG_CONFIG_HOME/$file"`
        ln -s "$DIR/$f" "$XDG_CONFIG_HOME/$file"
    fi
done
if [ -d ./nvim ]; then
    mkdir -p "$XDG_CONFIG_HOME/nvim/session"
    mkdir -p "$XDG_CONFIG_HOME/nvim/undodir"
    cp -rs "$DIR/nvim" "$XDG_CONFIG_HOME" 2>/dev/null
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

    # install coc extensions
    set -o nounset    # error when referencing undefined variable
    set -o errexit    # exit when command fails

    # Install extensions
    mkdir -p ~/.config/coc/extensions
    cd ~/.config/coc/extensions
    if [ ! -f package.json ]; then
      echo '{"dependencies":{}}'> package.json
    fi
    # Change extension names to the extensions you need
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

fi

cd $WORKDIR

