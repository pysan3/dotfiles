#!/bin/bash

if [[ x$DOTFILES = x ]]; then
    DOTFILES=$HOME/dotfiles
fi
FILES=$(ls -ap $DOTFILES/ | grep -v /)
if [ $# -ge 1 ]; then
    FILES=$@
fi

for f in "$FILES"; do
    ln -sf $DOTFILES/$f $HOME/$f
done
