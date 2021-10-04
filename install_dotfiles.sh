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
for f in `command ls -Ap | grep -v / | grep -v '\.sh'`; do
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
    else
        exit
    fi
fi

# neovim configs and install extensions
if [ -d ./nvim ]; then
    mkdir -p "$XDG_CONFIG_HOME/nvim/session"
    mkdir -p "$XDG_CONFIG_HOME/nvim/undodir"
    cp -rs "$DOTFILES/nvim" "$XDG_CONFIG_HOME" 2>/dev/null
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
fi

cd $WORKDIR

checkdependency git
checkdependency tmux
