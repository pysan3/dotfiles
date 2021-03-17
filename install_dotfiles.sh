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
    echo "Creating a symbolic link of $f in $HOME"
    ln -s "$DIR/$f" "$HOME/$f"
done

cd $WORKDIR

