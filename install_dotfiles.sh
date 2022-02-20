#!/bin/bash

DOTFILES="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

if [[ 'xdotfiles' != x$(basename $DOTFILES) ]]; then
    echo "install.sh might not be placed in the right place."
    echo "Try running it inside dotfile directory."
    exit
fi

WORKDIR=$PWD
cd $DOTFILES || error "Could not cd to $DOTFILES; Abort" || exit

unset DOTFILES_FUNCTIONS && source "$DOTFILES/functions.zsh"

# create symlink to .zsh* files
for f in $(command ls -Ap | grep -v / | grep -v '\.sh' | grep -v '\.zsh$'); do
    if [[ "$f" =~ (\.git|\.session|test|tmp|local|list|README|LICENSE).* ]]; then continue; fi
    if [ -f "$HOME/$f" ]; then
        warning "$HOME/$f: Symbolic link already exists."
    else
        ln -s "$DOTFILES/$f" "$HOME/$f"
        info "Created a symbolic link of $f in $HOME"
    fi
done

# create and copy configs in $XDG_CONFIG_HOME
if [ -z "$XDG_CONFIG_HOME" ]; then
    XDG_CONFIG_HOME="$HOME/.config"
fi
info "$(tput setaf 4)XDG_CONFIG_HOME$(tput sgr0) := $HOME/.config"
for f in $(command find "config" -type f); do
    file=${f#"config/"}
    if [ ! -f "$XDG_CONFIG_HOME/$file" ]; then
        dir_name=$(dirname "$XDG_CONFIG_HOME/$file")
        mkdir -p "$dir_name"
        warning "Created dir: $dir_name"
        ln -s "$DOTFILES/$f" "$XDG_CONFIG_HOME/$file"
        info "Created a symbolic link of $f in $dir_name"
    elif [ "$XDG_CONFIG_HOME/$file" -ef "$DOTFILES/$f" ]; then
        info "Symlink to $f is already set"
    else
        error "$XDG_CONFIG_HOME/$f already exists. Cannot overwrite"
    fi
done

# neovim configs and install extensions
function link_nvim () {
    NFROM="$1"; NTO="$2"; NMSG="$3 to $2"
    [ ! -d "$NFROM" ] && error "$NFROM not found." && return 1
    if [[ -d "$NTO" && x$(followlink "$NTO") = x"$NFROM" ]]; then info "$NMSG already installed"
    else ln -s "$NFROM" "$NTO" && info "Installed $NMSG" || error "Failed to install $NMSG"
    fi
}
link_nvim "$DOTFILES"/nvim "$XDG_CONFIG_HOME"/nvim "nvim config files"
link_nvim "$DOTFILES"/nlua "$XDG_CONFIG_HOME"/nvim/lua "nlua config files"

# install files in ./static/
if [ ! -f ~/texmf/tex/latex/local/pdfpc-commands.sty ]; then
    mkdir -p ~/texmf/tex/latex/local
    ln -s "$DOTFILES/static/pdfpc-commands.sty" ~/texmf/tex/latex/local/pdfpc-commands.sty
    if checkdependency 'texhash'; then
        texhash ~/texmf
    fi
    info "Installed pdfpc-commands.sty"
fi

cd $WORKDIR || error "Could not cd to $WORKDIR; Abort" || exit

checkdependency git
