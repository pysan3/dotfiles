#!/bin/zsh

DOTFILES=$(ls -ApI 'setup.sh' | grep -v /)

echo $DOTFILES | while read f; do
    ln -sf $HOME/dotfiles/$f $HOME/$f
done
