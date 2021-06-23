#!/bin/bash

# update all globally installed pip packages
pip list --outdated --format=freeze | grep -v '^\-e' | cut -d = -f 1  | xargs -n1 pip install -U

# update global npm packages
npm update -g

# update rust and cargo
rustup update

if [[ x`basename $SHELL` = x'zsh' ]]; then
    :
else
    :
fi

case "$(uname -s)" in
    Darwin)
        # echo 'Mac OS X'
        ;;
    Linux)
        # echo 'Linux'
        ;;
    CYGWIN*|MINGW32*|MINGW)
        # echo 'MS Windows'
        ;;
    *)
        # echo 'Unknown OS'
        ;;
esac

if ! command -v 'yay' &> /dev/null; then
    yay -Syu --overwrite '/usr/lib/node_modules/*'
elif ! command -v 'apt' &> /dev/null; then
    sudo apt update && sudo apt upgrade -y
fi

