#!/usr/bin/zsh

if [[ 'xdotfiles' != x$(basename ${DOTFILES:=$HOME/dotfiles}) ]]; then
  echo "install_all.zsh might not be placed in the right place."
  echo "Try running it inside dotfile directory."
  exit
fi

cd ${DOTFILES:=$HOME/dotfiles}
if [[ x"$PWD" != x"$DOTFILES" ]]; then
  echo "Could not cd to $DOTFILES; PWD=$PWD; Abort"
  exit
fi

zcompile "$DOTFILES/functions.zsh"
unset DOTFILES_FUNCTIONS && source "$DOTFILES/functions.zsh"

# Create temp dir
[ -z "$MYTEMPDIR" ] && MYTEMPDIR="${TEMPDIR:-/tmp}/$USER"
[ ! -d "$MYTEMPDIR" ] && mkdir -p "$MYTEMPDIR"

# create symlink to .zsh* files
for f in $(command ls -Ap | grep -v / | grep -v '\.sh' | grep -v '\.zsh$' | grep -v '\.zwc$' | grep -v '\.json$'); do
  if [[ "$f" =~ (\.git|\.session|test|tmp|local|list|README|LICENSE).* ]]; then continue; fi
  if [ -f "$HOME/$f" ]; then
    info "$HOME/$f: Symbolic link already exists."
  else
    ln -s "$DOTFILES/$f" "$HOME/$f"
    info "Created a symbolic link of $f in $HOME"
  fi
done

# create symlink for bin files to $XDG_BIN_HOME
if [ -z "$XDG_BIN_HOME" ]; then
  XDG_BIN_HOME="$HOME/.local/bin"
  info "$(tput setaf 4)XDG_BIN_HOME$(tput sgr0) := $HOME/.local/bin"
fi
for f in $(command find "bin" -type f); do
  file=${f#"bin/"}
  if [ ! -f "$XDG_BIN_HOME/$file" ]; then
    dir_name=$(dirname "$XDG_BIN_HOME/$file")
    mkdir -p "$dir_name"
    warning "Created dir: $dir_name"
    ln -s "$DOTFILES/$f" "$XDG_BIN_HOME/$file"
    info "Created a symbolic link of $f in $dir_name"
  elif [ "$XDG_BIN_HOME/$file" -ef "$DOTFILES/$f" ]; then
    info "Symlink to $f is already set"
  else
    error "$XDG_CONFIG_HOME/$f already exists. Cannot overwrite"
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
    info "Symlink to $DOTFILES/$f is already set"
  else
    error "$XDG_CONFIG_HOME/$file already exists. Cannot overwrite"
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
link_nvim "$DOTFILES/nvim" "$XDG_CONFIG_HOME/nvim" "nvim config files"

# install files in ./static/
if [ ! -f "$HOME/texmf/tex/latex/local/pdfpc-commands.sty" ]; then
  mkdir -p "$HOME/texmf/tex/latex/local"
  ln -s "$DOTFILES/static/pdfpc-commands.sty" "$HOME/texmf/tex/latex/local/pdfpc-commands.sty"
  if checkdependency 'texhash'; then
    texhash "$HOME/texmf"
  fi
  info "Installed pdfpc-commands.sty"
fi

# npmrc
npmrc="$XDG_CONFIG_HOME/npm/npmrc"
[[ -L "$npmrc" ]] && rm "$npmrc"
mkdir -p "$(dirname $npmrc)" && touch "$npmrc"
while IFS= read -r line; do
  if [[ $(cat "$npmrc" | grep "$line" | wc -l) -eq 0 ]]; then
    echo "$line" >> "$npmrc"
  fi
done < "$DOTFILES/static/npm/npmrc"
info "Installed npmrc"

# firefox configurations
ff_profile_dir=$(echo "$HOME/.mozilla/firefox/"*.default-release)
if [ ! -z "$ff_profile_dir" ]; then
  mkdir -p "$ff_profile_dir/chrome" \
    && ln -sf "$DOTFILES/static/firefox/userChrome.css" "$ff_profile_dir/chrome/" \
    && ln -sf "$DOTFILES/static/firefox/user.js" "$ff_profile_dir/" \
    && info "Installed firefox configurations" || error "Failed to install firefox configurations"
else
  info "firefox configurations is invalid or already installed"
fi
# install for windows
if [[ -d /mnt/c/Users ]]; then
  ff_profile_dir=$(echo /mnt/c/Users/i84203609/AppData/Roaming/Mozilla/Firefox/Profiles/*.default-release)
  [ ! -z "$ff_profile_dir" ] && mkdir -p "$ff_profile_dir/chrome" \
    && cp -f "$DOTFILES/static/firefox/userChrome.css" "$ff_profile_dir/chrome/" \
    && cp -f "$DOTFILES/static/firefox/user.js" "$ff_profile_dir/" \
    && info "Installed firefox configurations for Windows" \
    || error "Failed to install firefox configurations in Windows"
fi

true
