#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

if [[ xdotfiles != x$(basename $DIR) ]]; then
    echo "install.sh might not be placed in the right place."
    echo "Try running it inside dotfile directory."
    exit
fi

WORKDIR=$PWD
cd $DIR
for f in `command ls -ap | grep -v /`; do
    if [ -f "$HOME/$f" ]; then
        echo "$HOME/$f: Symbolic link already exists."
    else
        echo "Creating a symbolic link of $f in $HOME"
        ln -s "$DIR/$f" "$HOME/$f"
    fi
done
if [ -d ./nvim ]; then
    mkdir -p "$HOME/.config/nvim/session"
    cp -rs "$DIR/nvim" "$HOME/.config"
fi

cd $WORKDIR

