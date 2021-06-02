#!/bin/zsh

# install haskel interpreter
if [ ! -d ~/.ghcup ] || [ ! command -v cabal &> /dev/null ] || [ ! command -v pandoc &> /dev/null ]; then
    cd
    wget -qO- https://get.haskellstack.org/ | sh
    . "$HOME/.ghcup/env"
    cabal --version
    cabal new-update
    cabal new-install pandoc
    cabal new-install pandoc-citeproc pandoc-crossref
fi
[ -f "/home/takuto/.ghcup/env" ] && source "/home/takuto/.ghcup/env" # ghcup-env
