#!/bin/bash

DOTFILES="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

if [[ 'xdotfiles' != x$(basename $DOTFILES) ]]; then
    echo "install.sh might not be placed in the right place."
    echo "Try running it inside dotfile directory."
    exit
fi

WORKDIR=$PWD
cd $DOTFILES

source "$DOTFILES/functions.zsh"

# create symlink to .zsh* files
for f in `command ls -Ap | grep -v / | grep -v '\.sh' | grep -v '\.zsh'`; do
    if [[ "$f" =~ (\.git|\.session|test|tmp|local|list).* ]]; then continue; fi
    if [ -f "$HOME/$f" ]; then
        echo "$HOME/$f: Symbolic link already exists."
    else
        echo "Creating a symbolic link of $f in $HOME"
        ln -s "$DOTFILES/$f" "$HOME/$f"
    fi
done

# create and copy configs in $XDG_CONFIG_HOME
if [ -z "$XDG_CONFIG_HOME" ]; then
    echo 'setting $XDG_CONFIG_HOME to '"$HOME/.config"
    XDG_CONFIG_HOME="$HOME/.config"
fi
for f in `command find "config" -type f`; do
    file=${f#"config/"}
    if [ ! -f "$XDG_CONFIG_HOME/$file" ]; then
        mkdir -p `dirname "$XDG_CONFIG_HOME/$file"`
        ln -s "$DOTFILES/$f" "$XDG_CONFIG_HOME/$file"
    fi
done

# install files in ./static/
if [ ! -f ~/texmf/tex/latex/local/pdfpc-commands.sty ]; then
    mkdir -p ~/texmf/tex/latex/local
    ln -s "$DOTFILES/static/pdfpc-commands.sty" ~/texmf/tex/latex/local/pdfpc-commands.sty
    if checkdependency 'texhash'; then
        texhash ~/texmf
    fi
fi

# neovim configs and install extensions
if [ -d ./nvim ]; then
    mkdir -p "$XDG_CONFIG_HOME/nvim/session"
    mkdir -p "$XDG_CONFIG_HOME/nvim/undodir"
    cp -rs "$DOTFILES/nvim" "$XDG_CONFIG_HOME" 2>/dev/null
fi

cd $WORKDIR

checkdependency git
checkdependency tmux
