#!/usr/bin/zsh

if [[ 'xdotfiles' != x$(basename ${DOTFILES:=$HOME/dotfiles}) ]]; then
  echo "install_base.zsh might not be placed in the right place."
  echo "Try running it inside dotfile directory."
  exit
fi

source "$DOTFILES/.zshenv"
unset DOTFILES_FUNCTIONS && source "$DOTFILES/functions.zsh"
setopt sh_word_split

function update_git_repo() {
  dist="$1"; repo_url="$2"
  shift 2
  if [ ! -d "$dist" ]; then
    info "Installing $dist"
    mkdir -p "$dist" && git clone --depth 1 "$repo_url" "$dist"
  fi
  info "Updating $dist"
  git -C "$dist" pull
  sleep 1
  for file in $@; do
    info "Compiled $dist/$file"
    zcompile "$dist/$file"
  done
  for file in $(command find "$dist" -name '*.zsh' -type f); do
    if [ ! "$file.zwc" -nt "$file" ]; then
      info "Found $file -> Compiling"
      zcompile "$file"
    fi
  done
}

if ! command -v 'python' &>/dev/null || [[ $(python -V 2>&1) =~ 'Python 2.*' ]]; then
  error 'No python command found'
  if checkyes 'Do you want to create a systemwide symlink to python3?'; then
    sudo ln -s "$(which python3)" /usr/bin/python
  elif checkyes 'Do you want to create an alias?'; then
    alias python='python3'
    alias pip='pip3'
  else
    error 'Please set `python` command to run Python 3.x'
  fi
fi

# install haskel interpreter
if ! command -v pandoc &>/dev/null && checkyes "Seems you don't have pandoc installed. Install?"; then
  info 'Installing `cabal` for haskel and `pandoc`'
  warning 'Answer N->Y->Y to the questions'
  curl https://get-ghcup.haskell.org | sh
  cabal --version
  cabal new-update
  cabal new-install --overwrite-policy=always pandoc pandoc-citeproc pandoc-crossref
fi
info 'Haskell installation done'

# install zsh shell utils
mkdir -p "$XDG_DATA_HOME"/zsh
ZSH_SYNTAX_HIGHLIGHTING_INSTALL_DIR="$XDG_DATA_HOME"/zsh/zsh-syntax-highlighting
update_git_repo "$ZSH_SYNTAX_HIGHLIGHTING_INSTALL_DIR" https://github.com/zsh-users/zsh-syntax-highlighting.git zsh-syntax-highlighting.zsh
ZSH_AUTOSUGGESTIONS_INSTALL_DIR="$XDG_DATA_HOME"/zsh/zsh-autosuggestions
update_git_repo "$ZSH_AUTOSUGGESTIONS_INSTALL_DIR" https://github.com/zsh-users/zsh-autosuggestions.git zsh-autosuggestions.zsh
info 'Zsh extensions installation done'

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
pip install --user --upgrade pipupgrade
info 'python programs installation done'

# install ruby
install_ruby=true
if [ ! -d "$RBENV_ROOT" ]; then
  info "Installing ruby and rbenv, mainly for neovim"
  if command -v 'rbenv' &> /dev/null; then
    error 'Command `rbenv` found but not installed to '"$RBENV_ROOT"
    if checkyes "Continue installation? ($(tput setaf 1)THIS WILL TAKE OVER EXISTING ENVS$(tput sgr0))"; then
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
fi
if "$install_ruby"; then
  update_git_repo "$RBENV_ROOT" https://github.com/rbenv/rbenv.git
  update_git_repo "$RBENV_ROOT"/plugins/ruby-build https://github.com/rbenv/ruby-build.git
  export PATH="$RBENV_ROOT/bin:$PATH"
  latest_ruby=$(rbenv install -l 2>/dev/null | grep -v - | tail -1)
  CONFIGURE_OPTS='--disable-install-rdoc' rbenv install "$latest_ruby"
  rbenv global "$latest_ruby" && info "Installed ruby (v: $latest_ruby) for user: $USER"
fi
info 'Ruby setup done'

# RUST
if ! command -v 'cargo' &> /dev/null; then
  if checkyes "Seems you don't have cargo (rust) installed. Install?"; then
    curl -sSf https://sh.rustup.rs | sh
    source "$CARGO_HOME"/env
    cargo install cargo-update && info "Successfully installed cargo"
  else
    echo 'Press C-c to exit and install cargo manually. Or press ENTER to continue.'
    warning 'cargo is a MUST required dependency for further executions'
    read tmp
  fi
fi

function cargo_list_line_parse() {
  return_value="$1"; shift 1
  IFS='=' read -r -A cmdArr <<< $(echo "$@" | sed -e 's/^#\s*//')
  # add one dummy in bash because zsh array is 1-index
  if [[ x$(basename $SHELL) = x'bash' ]]; then
    cmdArr="tmp $cmdArr"
  fi
  cmd=${cmdArr[1]}; alt=${cmdArr[2]}; issudo=""
  if [[ x"$return_value" = x'cmd' ]]; then echo "$cmd"; return; fi
  if [[ x"$alt" == xsudo* ]]; then
    alt="${alt:5}"
    issudo="sudo "
  fi
  if [[ x"$return_value" = x'alt' ]]; then echo "$alt"; return; fi
  if [ ${#cmdArr[@]} -gt 2 ]; then
    pkg=${cmdArr[3]}
  else
    pkg="$alt"
  fi
  if [[ x"$return_value" = x'pkg' ]]; then echo "$pkg"; return; fi
  if [[ x"$return_value" = x'alias' ]]; then echo "alias $cmd='$issudo$alt'"; return; fi
}

CARGO_ALIAS_CACHE=${CARGO_ALIAS_CACHE:-$XDG_CACHE_HOME/cargo/alias_local.zsh}
mkdir -p "$(dirname "$CARGO_ALIAS_CACHE")"; touch "$CARGO_ALIAS_CACHE"
pkg_list=''; install_all_cargo_cmds=false
checkyes 'Do you want to install all cargo cli commands?' && install_all_cargo_cmds=true
while IFS= read -r line; do
  cmd=$(cargo_list_line_parse 'cmd' $line)
  alt=$(cargo_list_line_parse 'alt' $line)
  pkg=$(cargo_list_line_parse 'pkg' $line)
  cat "$CARGO_ALIAS_CACHE" | grep -v $cmd | sponge "$CARGO_ALIAS_CACHE"
  if [ 'x#' = x${line:0:1} ]; then continue; fi
  question="$alt not installed. Do you want to install with cargo?"
  if ! command -v $alt &> /dev/null && ($install_all_cargo_cmds || checkyes "$question"); then
    pkg_list="$pkg_list $pkg"
  fi
done < "$DOTFILES/static/list_rust_packages.txt"
[[ -n "$pkg_list" ]] && eval "cargo install -v $pkg_list"
while IFS= read -r line; do
  if [ 'x#' = x${line:0:1} ]; then continue; fi
  alt=$(cargo_list_line_parse 'alt' $line)
  pkg=$(cargo_list_line_parse 'pkg' $line)
  alias_cmd=$(cargo_list_line_parse 'alias' $line)
  if command -v $alt &> /dev/null; then
    info "installation $pkg success"
    echo "$alias_cmd" >> "$CARGO_ALIAS_CACHE"
  else
    error "installation $pkg failed"
  fi
done < "$DOTFILES/static/list_rust_packages.txt"
zcompile "$CARGO_ALIAS_CACHE"
info 'cargo cli tools setup done'

# node, npm
if ! command -v 'node' &>/dev/null || ! command -v 'npm' &>/dev/null || checkyes 'Upgrade node / npm?'; then
  if checkyes 'Can you use sudo?'; then
    sudo apt install npm -y
    sudo npm install -g n
    sudo n stable
    sudo npm update -g npm
    npm config set prefix "$XDG_DATA_HOME/npm"
  else
    rm -rf "${NVM_DIR:=$XDG_DATA_HOME/nvm}"
    mkdir -p "$NVM_DIR"
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash
    zcompile "$NVM_DIR"/nvm.sh
    source "$NVM_DIR"/nvm.sh
    nvm install node
    export PATH="$(npm config get prefix)/bin:$PATH"
  fi
fi

# setup clipboard
if ! command -v 'clipboard' &>/dev/null; then
  npm i -g clipboard-cli
fi

# install fzf
FZF_INSTALL_DIR="$XDG_DATA_HOME"/fzf
update_git_repo "$FZF_INSTALL_DIR" https://github.com/junegunn/fzf.git shell/completion.zsh shell/key-bindings.zsh
"$FZF_INSTALL_DIR"/install --xdg --key-bindings --completion --no-update-rc --no-bash --no-fish
sleep 1 && zcompile "$XDG_CONFIG_HOME"/fzf/fzf.zsh
info 'fzf setup done'

# install tmux plugin manager
TPM_INSTALL_DIR="$XDG_DATA_HOME"/tmux/plugins/tpm
update_git_repo "$TPM_INSTALL_DIR" https://github.com/tmux-plugins/tpm
info 'tmux setup done'

# install protoc from source
command -v 'protoc' &>/dev/null && info 'protoc found' || warning 'protoc not found.'
if checkyes 'Install protoc from source?'; then
  update_git_repo "$XDG_DATA_HOME"/protoc https://github.com/protocolbuffers/protobuf.git
  current_dir="$PWD"
  cd "$XDG_DATA_HOME"/protoc
  git submodule update --init --recursive
  ./autogen.sh && ./configure --prefix="$HOME/.local"
  make -j$(nproc) && make check -j$(nproc) && make install -j$(nproc)
  cd "$current_dir"
fi
info 'protoc setup done'

command -v 'nvtop' &>/dev/null && info 'nvtop found' || warning 'nvtop not found.'
if checkyes 'Install nvtop from source?'; then
  update_git_repo "$XDG_DATA_HOME"/nvtop https://github.com/Syllo/nvtop.git
  mkdir -p "$XDG_DATA_HOME"/nvtop/build && cd "$_"
  cmake .. -DCMAKE_INSTALL_PREFIX="$HOME/.local" && make
  make install
fi
info 'nvtop setup done'

# install and update zap (appimage package manager)
if ! command -v 'zap' &>/dev/null; then
  info 'Installing zap (appimage package manager)'
  curl https://raw.githubusercontent.com/srevinsaju/zap/main/install.sh | bash -s
fi
# install nvim
NVIM_UPDATE_ALL=false
if checkyes 'Do you want to update nvim?'; then
  NVIM_UPDATE_ALL=true
fi
if $NVIM_UPDATE_ALL || ! command -v 'nvim' &>/dev/null || checkyes 'Install nvim with zap?'; then
  rm "$XDG_DATA_HOME"/zap/v2/index/nvim.json
  zap i --github --from neovim/neovim --executable nvim
else
  error 'Please install manually.'
  echo 'https://github.com/neovim/neovim/wiki/Installing-Neovim'
fi
info 'zap and nvim installation done'

# nvim dependencies
checkcommand () {
  if ! command -v "$1" &>/dev/null || $NVIM_UPDATE_ALL; then
    warning "Installing command '$1' with following command."
    echo "$ $2"
    if [[ "$2" == *'sudo'* ]]; then
      checkyes 'Command includes `sudo`. Do you want to continue?' || return
    fi
    eval "$2" || error "failed: $2; DO IT YOURSELF"
  else
    info "Command '$1' found. Skipping..."
  fi
}

pip install --user --upgrade pynvim
gem install neovim
npm i -g neovim
# ctags
if ! command -v 'ctags' &>/dev/null || $NVIM_UPDATE_ALL || checkyes 'Reinstall ctags?'; then
  update_git_repo "$XDG_DATA_HOME"/ctags https://github.com/universal-ctags/ctags.git
  current_dir="$PWD"
  cd "$XDG_DATA_HOME"/ctags
  ./autogen.sh && ./configure --prefix="$HOME/.local"
  make -j$(nproc) && make install
  cd "$current_dir"
fi
# sad
checkcommand 'delta' 'cargo install git-delta'
checkcommand 'sad' 'cargo install --locked --all-features --git https://github.com/ms-jpq/sad --branch senpai'
# null-ls
checkcommand 'stylua' 'cargo install stylua'
checkcommand 'prettier' 'npm install --save-dev -g prettier'
checkcommand 'eslint' 'npm install --save-dev -g eslint'
checkcommand 'autopep8' 'pip install --user --upgrade autopep8'
checkcommand 'pyright' 'pip install --user --upgrade pyright'
checkcommand 'pylsp' 'pip install --user --upgrade python-lsp-server'
checkcommand 'flake8' 'pip install --user --upgrade flake8'
checkcommand 'pylint' 'pip install --user --upgrade pylint'
checkcommand 'emmet-ls' 'npm install -g emmet-ls'
checkcommand 'taplo' 'cargo install taplo-cli'
# telescope
if $NVIM_UPDATE_ALL || checkyes 'Install telescope dependencies?'; then
  checkcommand 'ueberzug' 'pip install ueberzug'
  checkcommand 'pdftoppm' 'sudo apt install poppler-utils || yay -S poppler'
  checkcommand 'rg' 'cargo install ripgrep' # https://www.linode.com/docs/guides/ripgrep-linux-installation/
  checkcommand 'ffmpegthumbnailer' 'sudo apt install ffmpegthumbnailer || yay -S ffmpegthumbnailer'
fi

# lookatme (terminal markdown renderer)
checkcommand 'lookatme' 'pip install --user --upgrade lookatme'

info "Everything is done. Thx!!"; true

