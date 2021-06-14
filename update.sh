#!/bin/bash

# update all globally installed pip packages
pip list --outdated --format=freeze | grep -v '^\-e' | cut -d = -f 1  | xargs -n1 pip install -U

# update global npm packages
npm update -g

if [[ x`basename $SHELL` = x'zsh' ]]; then
    :
else
    :
fi

if ! command -v 'yay' &> /dev/null; then
    yay -Syu
elif ! command -v 'apt' &> /dev/null; then
    sudo apt update && sudo apt upgrade -y
fi

