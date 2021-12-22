#!/bin/zsh

DOTFILES="$( cd "$( dirname "$0" )" &> /dev/null && pwd )"
echo "Running file in $DOTFILES"
source "$DOTFILES/.zshenv"
source "$DOTFILES/functions.zsh"

if ! command -v 'python' &>/dev/null || [[ `python -V` =~ 'Python 2.*' ]]; then
    error 'No python command found'
    if checkyes 'do you want to create a systemwide symlink to python3?'; then
        sudo ln -s `which python3` /usr/bin/python
    fi
fi

# install haskel interpreter
if [ ! -d "$XDG_DATA_HOME"/ghcup ] || [ ! command -v cabal &> /dev/null ] || [ ! command -v pandoc &> /dev/null ]; then
    info 'Installing `cabal` for haskel and `pandoc`'
    warning 'Answer N->Y->Y to the questions'
    cd
    curl --insecure https://get-ghcup.haskell.org | sh
    stack setup
    [ -f "$XDG_DATA_HOME/ghcup/env" ] && source "$XDG_DATA_HOME/ghcup/env"
    cabal --version
    cabal new-update
    cabal new-install pandoc pandoc-citeproc pandoc-crossref --overwrite-policy=always
fi
[ -f "$XDG_DATA_HOME/ghcup/env" ] && source "$XDG_DATA_HOME/ghcup/env" # ghcup-env

# install zsh shell utils
mkdir -p "$XDG_DATA_HOME"/zsh
if [ ! -f "$XDG_DATA_HOME"/zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
    info "Installing zsh-syntax-highlighting"
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$XDG_DATA_HOME"/zsh/zsh-syntax-highlighting
    zcompile "$XDG_DATA_HOME"/zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi
if [ ! -f "$XDG_DATA_HOME"/zsh/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
    info "Installing zsh-autosuggestions"
    git clone https://github.com/zsh-users/zsh-autosuggestions.git "$XDG_DATA_HOME"/zsh/zsh-autosuggestions
    zcompile "$XDG_DATA_HOME"/zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

# install pyenv
if ! command -v 'pyenv' &>/dev/null; then
    info "Installing pyenv"
    curl https://pyenv.run | bash
fi
# install poetry
if ! command -v 'poetry' &> /dev/null; then
    info "Installing poetry"
    curl https://install.python-poetry.org | python -
fi

# install ruby
install_ruby=true
if [ ! -d "$RBENV_ROOT" ]; then
    info "Installing ruby and rbenv, mainly for neovim"
    if command -v 'rbenv' &> /dev/null; then
        error 'Command `rbenv` found but not installed to '"$RBENV_ROOT"
        checkyes "Continue installation? ($(tput setaf 1)THIS WILL TAKE OVER EXISTING ENVS$(tput sgr0))"
        if [ $? -eq 0 ]; then
            install_ruby=false
            tput setaf 4
            echo "Please delete the following line in $DOTFILES/.zshenv"
            tput sgr0
            echo 'export RBENV_ROOT="$XDG_DATA_HOME"/rbenv'
            tput setaf 4
            echo 'Or add `unset RBENV_ROOT` to the top of '"$ZDOTDIR/.zshrc"
            tput sgr0
        fi
    fi
    git clone https://github.com/rbenv/rbenv.git "$RBENV_ROOT"
    git clone https://github.com/rbenv/ruby-build.git "$RBENV_ROOT"/plugins/ruby-build
fi
if "$install_ruby"; then
    export PATH="$RBENV_ROOT/bin:$PATH"
    latest_ruby=$(rbenv install -l 2>/dev/null | grep -v - | tail -1)
    CONFIGURE_OPTS='--disable-install-rdoc' RUBY_BUILD_CURL_OPTS='--insecure' rbenv install $latest_ruby
    rbenv global $latest_ruby && info "Installed ruby ($latest_ruby) for user: $USER"
fi

# RUST
if ! command -v 'cargo' &> /dev/null; then
    checkyes "Seems you don't have cargo (rust) installed. Install?"
    if [ $? -eq 0 ]; then
        curl -sSf https://sh.rustup.rs | sh
        source "$CARGO_HOME"/env
        cargo install cargo-update && info "Successfully installed cargo"
    else
        echo 'Press C-c to exit and install cargo manually. Or press ENTER to continue.'
        warning 'cargo is a MUST required dependency for further executions'
        read tmp
    fi
fi
while IFS= read -r line; do
    if [ 'x#' = x${line:0:1} ]; then continue; fi
    IFS='=' read -r -A cmdArr <<< "$line"
    # add one dummy in bash because zsh array is 1-index
    if [[ x$(basename $SHELL) = x'bash' ]]; then
        cmdArr="tmp $cmdArr"
    fi
    cmd=${cmdArr[1]}
    alt=${cmdArr[2]}
    issudo=""
    if [[ x"$alt" == xsudo* ]]; then
        alt="${alt:5}"
        issudo="sudo "
    fi
    if [ ${#cmdArr[@]} -gt 2 ]; then
        pkg=${cmdArr[3]}
    else
        pkg="$alt"
    fi
    if ! command -v $alt &> /dev/null; then
        checkyes "$alt not installed. Do you want to install with cargo?"
        if [ $? -eq 0 ]; then
            cargo install -v $pkg -f
        else
            echo "failed to create alias from '$cmd' to '$alt': command not found"
            continue
        fi
    fi
    eval "alias $cmd='$issudo$alt'"
done < "$DOTFILES/static/list_rust_packages.txt"

# install and update zap (appimage package manager)
if ! command -v 'zap' &>/dev/null; then
    info 'Installing zap (appimage package manager)'
    curl https://raw.githubusercontent.com/srevinsaju/zap/main/install.sh | bash -s
fi

# install nvim
warning 'Do you want to reinstall nvim?'
checkyes 'Install with zap?'
if [ $? -eq 0 ]; then
    zap i --github --from neovim/neovim --executable nvim
else
    error 'Please install manually.'
    echo 'https://github.com/neovim/neovim/wiki/Installing-Neovim'
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
info "Updating coc plugins."
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
    coc-pyright \
    coc-protobuf \
    coc-vimtex \
    coc-texlab \
    coc-sh \
    coc-yaml \
    --global-style --ignore-scripts --no-bin-links --no-package-lock --only=prod
    # https://github.com/Eric-Song-Nop/coc-glslx \
cd -

info "Everything is done. Thx!!"
