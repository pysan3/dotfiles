#!/usr/bin/zsh

if [[ 'xdotfiles' != x$(basename ${DOTFILES:=$HOME/dotfiles}) ]]; then
  echo "install_base.zsh might not be placed in the right place."
  echo "Try running it inside dotfile directory."
  exit
fi

source "$DOTFILES/.zshenv"
unset DOTFILES_FUNCTIONS && source "$DOTFILES/functions.zsh"
setopt sh_word_split
current_dir="$PWD"

function update_git_repo() {
  dist="$1"; repo_url="$2"
  if [ ! -d "$dist" ]; then
    info "Installing $dist"
    mkdir -p "$dist" && git clone --depth 1 "$repo_url" "$dist" \
      || (error "Failed to clone $repo_url to $dist" && return 1)
  fi
  info "Updating $dist" \
    && git -C "$dist" submodule update --init --recursive \
    && git -C "$dist" fetch --tags -f \
    || (error "Failed to update $dist" && return 1)
  [ $# -ge 3 ] && tag="$3" || tag=$(git -C "$dist" describe --tags $(git -C "$dist" rev-list --tags --max-count=1)) \
    && git -C "$dist" checkout "$tag" \
    || (error "Failed to checkout to tag: $tag in $dist" && return 1)
  for file in $(command find "$dist" -name '*.zsh' -type f); do
    if [ ! "$file.zwc" -nt "$file" ]; then
      info "Found $file -> Compiling"
      zcompile "$file"
    fi
  done
}

NVIM_UPDATE_ALL=false
function checkcommand () {
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
pip install --upgrade --user pip

# install haskel interpreter
function install_pandoc () {
  info 'Installing `cabal` for haskel and `pandoc`'
  warning 'Answer N->Y->Y to the questions'
  curl https://get-ghcup.haskell.org | sh
  cabal --version
  cabal new-update
  cabal new-install --overwrite-policy=always pandoc pandoc-citeproc pandoc-crossref
}
if ! command -v pandoc &>/dev/null && checkyes "Seems you don't have pandoc installed. Install?"; then
  install_pandoc
fi
info 'Haskell installation done'

# install zsh shell utils
function install_zsh_shell_utils () {
  mkdir -p "$XDG_DATA_HOME/zsh"
  ZSH_SYNTAX_HIGHLIGHTING_INSTALL_DIR="$XDG_DATA_HOME/zsh/zsh-syntax-highlighting"
  update_git_repo "$ZSH_SYNTAX_HIGHLIGHTING_INSTALL_DIR" https://github.com/zsh-users/zsh-syntax-highlighting.git
  ZSH_AUTOSUGGESTIONS_INSTALL_DIR="$XDG_DATA_HOME/zsh/zsh-autosuggestions"
  update_git_repo "$ZSH_AUTOSUGGESTIONS_INSTALL_DIR" https://github.com/zsh-users/zsh-autosuggestions.git
}
install_zsh_shell_utils
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
pip install --user --upgrade pipupgrade rich pyreadline
info 'python programs installation done'

# install ruby
install_ruby=true
if [ ! -d "$RBENV_ROOT" ]; then
  info "Installing ruby and rbenv, mainly for neovim"
  if command -v 'rbenv' &> /dev/null; then
    error 'Command `rbenv` found but not installed to' "$RBENV_ROOT"
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
  update_git_repo "$RBENV_ROOT/plugins/ruby-build" https://github.com/rbenv/ruby-build.git
  export PATH="$RBENV_ROOT/bin:$PATH"
  PREFIX="$XDG_PREFIX_HOME" "$RBENV_ROOT/plugins/ruby-build/install.sh"
  latest_ruby=$(rbenv install -l 2>/dev/null | grep -v - | tail -1)
  CONFIGURE_OPTS='--disable-install-rdoc' rbenv install -s -v "$latest_ruby"
  rbenv global "$latest_ruby" && info "Installed ruby (v: $latest_ruby) for user: $USER"
fi
info 'Ruby setup done'

# RUST
if ! command -v 'cargo' &> /dev/null; then
  if checkyes "Seems you don't have cargo (rust) installed. Install?"; then
    curl -sSf https://sh.rustup.rs | sh
    source "$CARGO_HOME/env"
    cargo install cargo-update && info "Successfully installed cargo"
  else
    echo 'Press C-c to exit and install cargo manually. Or press ENTER to continue.'
    warning 'cargo is a MUST required dependency for further executions'
    read tmp
  fi
fi

function cargo_list_line_parse() {
  return_value="$1"; shift 1
  IFS=':' read -r -A cmdArr <<< $(echo "$@" | sed -e 's/^#\s*//')
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
    pkg="${alt%% *}"
  fi
  if [[ x"$return_value" = x'pkg' ]]; then echo "$pkg"; return; fi
  if [[ x"$return_value" = x'alias' ]]; then echo "alias $cmd='$issudo$alt'"; return; fi
}

CARGO_ALIAS_CACHE="${CARGO_ALIAS_CACHE:-$XDG_CACHE_HOME/cargo/alias_local.zsh}"
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
  if ! command -v ${alt%% *} &> /dev/null && ($install_all_cargo_cmds || checkyes "$question"); then
    pkg_list="$pkg_list $pkg"
  fi
done < "$DOTFILES/static/list_rust_packages.txt"
[[ -n "$pkg_list" ]] && eval "cargo install $pkg_list"
while IFS= read -r line; do
  if [ 'x#' = x${line:0:1} ]; then continue; fi
  alt=$(cargo_list_line_parse 'alt' $line)
  pkg=$(cargo_list_line_parse 'pkg' $line)
  alias_cmd=$(cargo_list_line_parse 'alias' $line)
  if command -v ${alt%% *} &> /dev/null; then
    info "installation $pkg success"
    echo "$alias_cmd" >> "$CARGO_ALIAS_CACHE"
  else
    error "installation $pkg failed"
  fi
done < "$DOTFILES/static/list_rust_packages.txt"
zcompile "$CARGO_ALIAS_CACHE"
info 'cargo cli tools setup done'

# use `bat` to display man pages
if command -v bat &>/dev/null && ! grep -q 'MANPAGER' "$CARGO_ALIAS_CACHE"; then
  echo "export MANPAGER=\"sh -c 'col -bx | bat -l man -p'\"" >> "$CARGO_ALIAS_CACHE"
fi

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
    zcompile "$NVM_DIR/nvm.sh"
    source "$NVM_DIR/nvm.sh"
    if checkyes 'Use --lts (y) or latest node (N)?'; then
      nvm install --lts
    else
      nvm install node
    fi
    nvm install-latest-npm
    export PATH="$(npm config get prefix)/bin:$PATH"
  fi
fi
if ! command -v 'pnpm' &>/dev/null || checkyes 'Upgrade pnpm?'; then
  npm i -g pnpm
  export PATH="$PNPM_HOME:$PATH"
fi

# install useful npm cli commands
checkcommand 'clipboard' 'pnpm i -g clipboard-cli'
checkcommand 'bw' 'pnpm i -g @bitwarden/cli'

# lua, luarocks
function install_lua () {
  tmp_file=$(mktemp); LUA_INSTALL_DIR="$XDG_DATA_HOME/lua-${LOCAL_LUA_VERSION:=5.1.5}"
  wget -O "$tmp_file" https://www.lua.org/ftp/lua-$LOCAL_LUA_VERSION.tar.gz \
    && tar xzf "$tmp_file" -C "$XDG_DATA_HOME" \
    && make -C "$LUA_INSTALL_DIR" linux && make -C "$LUA_INSTALL_DIR" install INSTALL_TOP="$XDG_PREFIX_HOME" \
    && info "lua-$LOCAL_LUA_VERSION install done" || error "lua-$LOCAL_LUA_VERSION install FAILED!!"
  LUAROCKS_INSTALL_DIR="$XDG_DATA_HOME/luarocks"
  update_git_repo "$LUAROCKS_INSTALL_DIR" https://github.com/luarocks/luarocks \
    && cd "$LUAROCKS_INSTALL_DIR" && ./configure --with-lua="$XDG_PREFIX_HOME" --prefix="$XDG_PREFIX_HOME" \
    && make && make install \
    && info "luarocks installed successfully" || error "luarocks install FAILED"
  cd "$current_dir"
}
(! command -v 'lua' &>/dev/null || ! command -v 'luarocks' &>/dev/null || checkyes 'Upgrade lua?') && install_lua

function install_golang () {
  tmp_file=$(mktemp)
  wget -O "$tmp_file" "https://go.dev/dl/$(wget -O- 'https://go.dev/VERSION?m=text').linux-amd64.tar.gz" \
    && tar xzf "$tmp_file" -C "$XDG_DATA_HOME" \
    && ln -sf "$XDG_DATA_HOME/go/bin/"* "$XDG_BIN_HOME" \
    && info "go installed successfully" || error "go install FAILED"
}
(! command -v 'go' &>/dev/null || checkyes 'Upgrade golang?') && install_golang

# install fzf
FZF_INSTALL_DIR="$XDG_DATA_HOME/fzf"
update_git_repo "$FZF_INSTALL_DIR" https://github.com/junegunn/fzf.git shell/completion.zsh
"$FZF_INSTALL_DIR/install" --xdg --key-bindings --completion --no-update-rc --no-bash --no-fish
zcompile "$XDG_CONFIG_HOME/fzf/fzf.zsh"
info 'fzf setup done'

# install gh from source
command -v 'gh' &>/dev/null && info 'gh found' || warning 'gh not found.'
if checkyes 'Install gh from source?'; then
  update_git_repo "$XDG_DATA_HOME/gh-cli" https://github.com/cli/cli.git
  cd "$XDG_DATA_HOME/gh-cli" && make install prefix="$XDG_PREFIX_HOME"
  cd "$current_dir"
fi

# install tmux from source
command -v 'tmux' &>/dev/null && info 'tmux found' || warning 'tmux not found.'
if checkyes 'Install tmux from source?'; then
  update_git_repo "$XDG_DATA_HOME/tmux-git" https://github.com/tmux/tmux.git
  cd "$XDG_DATA_HOME/tmux-git" && ./autogen.sh && ./configure --prefix="$XDG_PREFIX_HOME" \
    && make -j$(nproc) && make install
  cd "$current_dir"
fi

# install tmux plugin manager
TPM_INSTALL_DIR="$XDG_DATA_HOME/tmux/plugins/tpm"
update_git_repo "$TPM_INSTALL_DIR" https://github.com/tmux-plugins/tpm
info 'tmux setup done'

function install_log_rotate () {
  update_git_repo "$XDG_DATA_HOME/log_rotate" https://github.com/ShawnFeng0/log_rotate.git
  cmake -B "$XDG_DATA_HOME/log_rotate/build" && make -C "$XDG_DATA_HOME/log_rotate/build"
  ln -sf "$XDG_DATA_HOME/log_rotate/build/log_rotate" "$XDG_BIN_HOME"
}
command -v 'log_rotate' &>/dev/null && info 'log_rotate found' || install_log_rotate

# install protoc from source
command -v 'protoc' &>/dev/null && info 'protoc found' || warning 'protoc not found.'
if checkyes 'Install protoc from source?'; then
  update_git_repo "$XDG_DATA_HOME/protoc" https://github.com/protocolbuffers/protobuf.git
  cd "$XDG_DATA_HOME/protoc" && ./autogen.sh && ./configure --prefix="$XDG_PREFIX_HOME" \
    && make -j$(nproc) && make check -j$(nproc) && make install -j$(nproc) \
    && info 'protoc setup done'
  cd "$current_dir"
fi

# install lynx from source
command -v 'lynx' &>/dev/null && info 'lynx found' || warning 'lynx not found.'
if checkyes 'Install lynx from source?'; then
  cd "$XDG_DATA_HOME" && wget -c http://invisible-island.net/datafiles/release/lynx-cur.zip \
    && unzip -o lynx-cur.zip && rm -rf lynx-cur.zip && cd $(ls -d lynx*/ | grep -v lynx_ | tail -1) \
    && ./configure --prefix="$XDG_PREFIX_HOME" --exec-prefix="$XDG_PREFIX_HOME" --mandir="$XDG_PREFIX_HOME/man" \
        --enable-externs --enable-find-leaks --enable-gnutls-compat --enable-gzip-help \
        --enable-internal-links --enable-ipv6 --enable-japanese-utf8 --enable-local-docs --enable-nested-tables \
        --enable-nls --enable-widec --with-ssl --with-screen=ncursesw --without-cfg-file --with-zlib \
    && make install && make install-help && make install-doc \
    && info 'lynx setup done' || error 'lynx setup failed'
  cd "$current_dir"
fi

# install btop from source
command -v 'btop' &>/dev/null && info 'btop found' || warning 'btop not found.'
if checkyes 'Install btop from source?'; then
  # sudo apt install coreutils sed git build-essential gcc-11 g++-11
  # gcc-11, g++-11 => gcc-10, g++-10
  BTOP_INSTALL_DIR="$XDG_DATA_HOME/btop"
  update_git_repo "$BTOP_INSTALL_DIR" https://github.com/aristocratos/btop.git
  checkyes 'Use g++-10 (y) or g++-11 (N)?' && CXX="g++-10" || CXX="g++-11"
  make -C "$BTOP_INSTALL_DIR" QUIET=true ADDFLAGS=-march=native CXX="$CXX" \
    && make -C "$BTOP_INSTALL_DIR" install PREFIX="$XDG_PREFIX_HOME" \
    && info 'btop installation done'
fi

# install bmon (bandwidth monitor)
command -v 'bmon' &>/dev/null && info 'bmon found' || warning 'bmon not found.'
if checkyes 'Install bmon from source?'; then
  # sudo apt install build-essential make libconfuse-dev libnl-3-dev libnl-route-3-dev libncurses-dev pkg-config dh-autoreconf
  BMON_INSTALL_DIR="$XDG_DATA_HOME/bmon"
  update_git_repo "$BMON_INSTALL_DIR" https://github.com/tgraf/bmon.git
  cd "$BMON_INSTALL_DIR" && ./autogen.sh && ./configure --prefix="$XDG_PREFIX_HOME" \
    && make -j$(nproc) && make install \
    && info 'bmon installation done'
  cd "$current_dir"
fi

# install nvtop from source
command -v 'nvtop' &>/dev/null && info 'nvtop found' || warning 'nvtop not found.'
if checkyes 'Install nvtop from source?'; then
  update_git_repo "$XDG_DATA_HOME/nvtop" https://github.com/Syllo/nvtop.git
  mkdir -p "$XDG_DATA_HOME/nvtop/build" && cd "$_"
  cmake .. -DCMAKE_INSTALL_PREFIX="$XDG_PREFIX_HOME" && make && make install \
    && info 'nvtop setup done'
  cd "$current_dir"
fi

# install nix
command -v 'nix' &>/dev/null && info 'nix found' || warning 'nix not found.'
if checkyes 'Install nix from source?'; then
  # editline
  update_git_repo "$XDG_DATA_HOME/editline" https://github.com/troglobit/editline.git
  ./configure --prefix="$XDG_PREFIX_HOME" && make all && make install \
    && ldconfig "$XDG_PREFIX_HOME" -n \
    && export PKG_CONFIG_LIBDIR="$XDG_PREFIX_HOME/lib/pkgconfig:$PKG_CONFIG_LIBDIR" \
    && info 'editline setup done'
  # json
  update_git_repo "$XDG_DATA_HOME/json" https://github.com/nlohmann/json.git
  mkdir -p "$XDG_DATA_HOME/json/build" && cd "$_"
  cmake .. -DCMAKE_INSTALL_PREFIX="$XDG_PREFIX_HOME" && make && make install \
    && ldconfig "$XDG_PREFIX_HOME" -n \
    && export PKG_CONFIG_LIBDIR="$XDG_PREFIX_HOME/lib/pkgconfig:$PKG_CONFIG_LIBDIR" \
    && info 'nholmann/json setup done'
  # lowdown
  update_git_repo "$XDG_DATA_HOME/lowdown" https://github.com/kristapsdz/lowdown.git
  ./configure --prefix="$XDG_PREFIX_HOME" && make && make regress && make install install_libs \
    && ldconfig "$XDG_PREFIX_HOME" -n \
    && export PKG_CONFIG_LIBDIR="$XDG_PREFIX_HOME/share/pkgconfig:$PKG_CONFIG_LIBDIR" \
    && info 'lowdown setup done'
  # brotli
  update_git_repo "$XDG_DATA_HOME/brotli" https://github.com/google/brotli.git
  mkdir -p "$XDG_DATA_HOME/brotli/build" && cd "$_"
  cmake .. -DCMAKE_INSTALL_PREFIX="$XDG_PREFIX_HOME" -DCMAKE_BUILD_TYPE=Release \
    && cmake --build . --config Release --target install \
    && ldconfig "$XDG_PREFIX_HOME" -n \
    && export PKG_CONFIG_LIBDIR="$XDG_PREFIX_HOME/lib/pkgconfig:$PKG_CONFIG_LIBDIR" \
    && info 'brotli setup done'
  cd "$current_dir"
fi

# install nvim
if checkyes 'Do you want to update nvim?'; then
  NVIM_UPDATE_ALL=true
fi
# install nvim from source
if ! command -v 'nvim' &>/dev/null || $NVIM_UPDATE_ALL || checkyes 'Install nvim from source?'; then
  NVIM_INSTLL_DIR="$XDG_DATA_HOME/nvim-git"
  update_git_repo "$NVIM_INSTLL_DIR" https://github.com/neovim/neovim.git "${NVIM_BUILD_TAG:-stable}"
  cd "$NVIM_INSTLL_DIR"
  make CMAKE_BUILD_TYPE=RelWithDebInfo CMAKE_INSTALL_PREFIX="$XDG_PREFIX_HOME" install || error 'NVIM BUILD FAILED'
  info 'nvim installed'
  cd -
fi

# nvim dependencies
pip install --user --upgrade pynvim
gem install neovim
pnpm i -g neovim
# ctags
if ! command -v 'ctags' &>/dev/null || $NVIM_UPDATE_ALL || checkyes 'Reinstall ctags?'; then
  update_git_repo "$XDG_DATA_HOME/ctags" https://github.com/universal-ctags/ctags.git
  cd "$XDG_DATA_HOME/ctags" && ./autogen.sh && ./configure --prefix="$XDG_PREFIX_HOME" \
    && make -j$(nproc) && make install
  cd "$current_dir"
fi
# sad
checkcommand 'delta' 'cargo install git-delta'
checkcommand 'sad' 'cargo install --locked --all-features --git https://github.com/ms-jpq/sad --branch senpai'
# telescope
if $NVIM_UPDATE_ALL || checkyes 'Install telescope dependencies?'; then
  checkcommand 'ueberzug' 'pip install ueberzug'
  checkcommand 'pdftoppm' 'sudo apt install poppler-utils || yay -S poppler'
  checkcommand 'rg' 'cargo install ripgrep' # https://www.linode.com/docs/guides/ripgrep-linux-installation/
  checkcommand 'ffmpegthumbnailer' 'sudo apt install ffmpegthumbnailer || yay -S ffmpegthumbnailer'
fi

# lookatme (terminal markdown renderer)
checkcommand 'lookatme' 'pip install --user --upgrade lookatme'

# PackerSync
if $NVIM_UPDATE_ALL || checkyes 'Run :PackerSync?'; then
  nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'
fi

info "Everything is done. Thx!!"; true

