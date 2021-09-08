#!/bin/zsh

# install haskel interpreter
if [ ! -d ~/.ghcup ] || [ ! command -v cabal &> /dev/null ] || [ ! command -v pandoc &> /dev/null ]; then
    cd
    wget -qO- https://get-ghcup.haskell.org | sh
    stack setup
    . "$HOME/.ghcup/env"
    cabal --version
    cabal new-update
    cabal new-install pandoc
    cabal new-install pandoc-citeproc pandoc-crossref
fi
[ -f "~/.ghcup/env" ] && source "~/.ghcup/env" # ghcup-env

