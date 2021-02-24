#!/bin/zsh

DOTFILES=$(ls -ApI 'setup.sh' | grep -v /)
if [ $# -ge 1 ]; then
    DOTFILES=$@
fi

echo $DOTFILES | while read f; do
    ln -sf $HOME/dotfiles/$f $HOME/$f
done
