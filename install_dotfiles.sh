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
        warning "$HOME/$f: Symbolic link already exists."
    else
        ln -s "$DOTFILES/$f" "$HOME/$f"
        info "Created a symbolic link of $f in $HOME"
    fi
done

# create and copy configs in $XDG_CONFIG_HOME
if [ -z "$XDG_CONFIG_HOME" ]; then
    XDG_CONFIG_HOME="$HOME/.config"
fi
info "$(tput setaf 4)XDG_CONFIG_HOME$(tput sgr0) := $HOME/.config"
for f in `command find "config" -type f`; do
    file=${f#"config/"}
    if [ ! -f "$XDG_CONFIG_HOME/$file" ]; then
        dir_name=`dirname "$XDG_CONFIG_HOME/$file"`
        mkdir -p "$dir_name"
        warning "Created dir: $dir_name"
        ln -s "$DOTFILES/$f" "$XDG_CONFIG_HOME/$file"
        info "Created a symbolic link of $f in $dir_name"
    elif [ "$XDG_CONFIG_HOME/$file" -ef "$DOTFILES/$f" ]; then
        info "Symlink to $f is already set"
    else
        error "$XDG_CONFIG_HOME/$f already exists. Cannot overwrite"
    fi
done

# install files in ./static/
if [ ! -f ~/texmf/tex/latex/local/pdfpc-commands.sty ]; then
    mkdir -p ~/texmf/tex/latex/local
    ln -s "$DOTFILES/static/pdfpc-commands.sty" ~/texmf/tex/latex/local/pdfpc-commands.sty
    if checkdependency 'texhash'; then
        texhash ~/texmf
    fi
    info "Installed pdfpc-commands.sty"
fi

# neovim configs and install extensions
if [ -d "$DOTFILES/nvim" ]; then
    mkdir -p "$XDG_CONFIG_HOME/nvim/session"
    mkdir -p "$XDG_CONFIG_HOME/nvim/undodir"
    cp -rs "$DOTFILES/nvim" "$XDG_CONFIG_HOME" 2>/dev/null
    info "Installed nvim config files to $XDG_CONFIG_HOME/nvim"
fi

cd $WORKDIR

checkdependency git
checkdependency tmux
