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

function update_git_history () {
  dist="$1"; repo_url="$2"
  if [ ! -d "$dist" ]; then
    info "Installing $dist"
    mkdir -p "$dist" && git clone "$repo_url" "$dist" \
      || err_exit "Failed to clone $repo_url to $dist"
  fi
  info "Updating $dist" \
    && git -C "$dist" submodule update --init --recursive \
    && git -C "$dist" fetch --tags -f \
    || err_exit "Failed to update $dist"
  [ $# -ge 3 ] && tag="$3" || tag=$(git -C "$dist" describe --tags $(git -C "$dist" rev-list --tags --max-count=1)) \
    && git -C "$dist" checkout "$tag" \
    || err_exit "Failed to checkout to tag: $tag in $dist"
  for file in $(command find "$dist" -name '*.zsh' -type f); do
    if [ ! "$file.zwc" -nt "$file" ]; then
      info "Found $file -> Compiling"
      zcompile "$file"
    fi
  done
  return 0
}

function update_git_repo () {
  dist="$1"; repo_url="$2"
  [ -d "$dist" ] && rm -rf "$dist"
  [ $# -ge 3 ] && tag="--branch $3" || tag=""
  cmd="git clone --depth 1 $tag $repo_url $dist"
  info "Running command:\n$ $cmd" \
    && eval "$cmd" \
    && info "Success" || err_exit "Failed to run $cmd"
  return 0
}

function get_latest_release () {
  curl --silent "https://api.github.com/repos/$1/releases/latest" \
    | grep '"tag_name":' \
    | sed -E 's/.*"([^"]+)".*/\1/'
}

function download_release () {
  repo="$1"; file="$2"; dest="$3"
  info "Downloading https://github.com/$repo/releases/download/$file to $dest"
  curl -gL "https://github.com/$repo/releases/download/$file" -o "$dest"
}

function checkcommand () {
  if ! command -v "$1" &>/dev/null; then
    warning "Installing command '$1' with following command."
    echo "$ $2"
    if [[ "$2" == *'sudo'* ]]; then
      checkyes 'Command includes `sudo`. Do you want to continue?' || return
    fi
    eval "$2" || err_exit "failed: $2; DO IT YOURSELF"
  else
    info "Command '$1' found. Skipping..."
  fi
}

repo="yuru7/PlemolJP"; font_name="$(basename $repo)"
if [ $(fc-list | grep "$font_name" | wc -l) -eq 0 ] && checkyes 'Install PlemolJP fonts?'; then
  tmp_dir=$(mktemp -d); mkdir -p "$XDG_DATA_HOME/fonts/$font_name"; trap "rm -v -rf '$tmp_dir'" 1 2 3 15
  latest=$(get_latest_release "$repo") \
    && info "Downloading version: $latest" \
    && download_release "$repo" "$latest/${font_name}_NF_$latest.zip" "$tmp_dir/x.zip" \
    && unzip -d "$tmp_dir" "$tmp_dir/x.zip" \
    && rm -rf "$XDG_DATA_HOME/fonts/$font_name"* \
    && mv "$tmp_dir/$font_name"*/* "$XDG_DATA_HOME/fonts/" \
    && fc-cache -vrf \
    && checkyes 'Install to /usr/local/share/fonts?' \
    && sudo mkdir -p "/usr/local/share/fonts" && sudo cp -r "$XDG_DATA_HOME/fonts/$font_name"* $_ \
    && rm -rf "$XDG_DATA_HOME/fonts/$font_name"* \
    && sudo fc-cache -vrf
  rm -v -rf "$tmp_dir"
fi

# install pyenv and poetry
if ! command -v 'python' &>/dev/null || [[ $(python -V 2>&1) =~ 'Python 2.*' ]]; then
  error 'No python command found'
  if checkyes 'Do you want to create a systemwide symlink to python3?'; then
    sudo ln -s "$(which python3)" /usr/bin/python
  elif checkyes 'Do you want to create an alias?'; then
    alias python='python3'
    alias pip='pip3'
  else
    err_exit 'Please set `python` command to run Python 3.x'
  fi
fi
if ! command -v 'pyenv' &>/dev/null || ! command -v 'poetry' &> /dev/null; then
  info "Installing pyenv" && curl https://pyenv.run | bash
  info "Installing poetry" && curl https://install.python-poetry.org | python -
  err_exit "Install the appropriate python version first. Aborting."
  exit 0
fi

python -m ensurepip --upgrade && python -m pip install --upgrade --user pip
python -m pip install -U --user pipupgrade rich trash-cli yt-dlp video-cli
info 'python programs installation done'

# install zsh shell utils
function install_zsh_shell_utils () {
  mkdir -p "$XDG_DATA_HOME/zsh"
  ZSH_SYNTAX_HIGHLIGHTING_INSTALL_DIR="$XDG_DATA_HOME/zsh/zsh-syntax-highlighting"
  update_git_history "$ZSH_SYNTAX_HIGHLIGHTING_INSTALL_DIR" https://github.com/zsh-users/zsh-syntax-highlighting.git
  ZSH_AUTOSUGGESTIONS_INSTALL_DIR="$XDG_DATA_HOME/zsh/zsh-autosuggestions"
  update_git_history "$ZSH_AUTOSUGGESTIONS_INSTALL_DIR" https://github.com/zsh-users/zsh-autosuggestions.git
}
install_zsh_shell_utils \
  && info 'Zsh extensions installation done' \
  || error 'Zsh extensions installation failed'

# RUST
function install_rust_cargo () {
  if checkyes "Seems you don't have cargo (rust) installed. Install?"; then
    tmp_file=$(mktemp); trap "rm -rf '$tmp_file'" 1 2 3 15
    wget -O "$tmp_file" https://sh.rustup.rs \
      && chmod +x "$tmp_file" \
      && "$tmp_file" -y --no-modify-path \
      && rm "$tmp_file" \
      || err_exit "cargo failed to install"
    source "$CARGO_HOME/env"
    unset RUSTC_WRAPPER
    cargo install sccache
    export RUSTC_WRAPPER=sccache
    cargo install cargo-update cargo-cache && info "Successfully installed cargo"
  else
    echo 'Press C-c to exit and install cargo manually. Or press ENTER to continue.'
    warning 'cargo is a MUST required dependency for further executions'
    read tmp
  fi
}
(false || ! command -v 'cargo' &> /dev/null) && install_rust_cargo

function cargo_list_line_parse() {
  return_value="$1"; shift 1
  IFS=':' read -r -A cmdArr <<< $(echo "$@" | sed -e 's/^#\s*//')
  # add one dummy in bash because zsh array is 1-index
  [[ x$(basename $SHELL) = x'bash' ]] && cmdArr="tmp $cmdArr"
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

export RUSTC_WRAPPER=sccache
CARGO_ALIAS_CACHE="${CARGO_ALIAS_CACHE:-$XDG_CACHE_HOME/cargo/alias_local.zsh}"
pkg_list=''; mkdir -p "$(dirname "$CARGO_ALIAS_CACHE")"; touch "$CARGO_ALIAS_CACHE"
while IFS= read -r line; do
  cmd=$(cargo_list_line_parse 'cmd' $line)
  alt=$(cargo_list_line_parse 'alt' $line | cut -d ' ' -f 1)
  pkg=$(cargo_list_line_parse 'pkg' $line)
  [ x_ = x$cmd ] || cat "$CARGO_ALIAS_CACHE" | grep -v $cmd | sponge "$CARGO_ALIAS_CACHE"
  if [ 'x#' = x${line:0:1} ]; then continue; fi
  command -v ${alt} &>/dev/null || pkg_list="$pkg_list $pkg"
done < "$DOTFILES/static/list_rust_packages.txt"
uniq_pkg_list=$(echo "$pkg_list" | sed 's/ /\n/g' | uniq | xargs)
[[ -n "$uniq_pkg_list" ]] && checkyes "Execute: 'cargo install $uniq_pkg_list'?" \
  && eval "cargo install $uniq_pkg_list"
while IFS= read -r line; do
  if [ 'x#' = x${line:0:1} ]; then continue; fi
  alt=$(cargo_list_line_parse 'alt' $line | cut -d ' ' -f 1)
  pkg=$(cargo_list_line_parse 'pkg' $line)
  command -v ${alt} &>/dev/null || (error "installation $pkg failed" && continue)
  [ x_ = x$(cargo_list_line_parse 'cmd' $line) ] && continue
  echo "$(cargo_list_line_parse 'alias' $line)" >> "$CARGO_ALIAS_CACHE"
done < "$DOTFILES/static/list_rust_packages.txt"
zcompile "$CARGO_ALIAS_CACHE"
info 'cargo cli tools setup done'

# use `bat` to display man pages
if command -v bat &>/dev/null && ! grep -q 'MANPAGER' "$CARGO_ALIAS_CACHE"; then
  echo "export MANPAGER=\"sh -c 'col -bx | bat -l man -p'\"" >> "$CARGO_ALIAS_CACHE"
fi

# node, npm
function install_nvm () {
  if checkyes 'Installing node / npm. Can you use sudo?'; then
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
    npm i -g pnpm
  fi
}
(false || ! command -v 'node' &>/dev/null || ! command -v 'npm' &>/dev/null) && install_nvm
# install necessary npm cli commands
export PATH="$PNPM_HOME:$PATH"
pnpm i -g clipboard-cli @bitwarden/cli

# nim
function install_nim () {
  curl https://nim-lang.org/choosenim/init.sh -sSf | sh
  rehash
}
(false || ! command -v 'nim' &>/dev/null || ! command -v 'nimble' &>/dev/null) && install_nim

# lua, luarocks
function install_lua () {
  tmp_file=$(mktemp); LUA_INSTALL_DIR="$XDG_DATA_HOME/lua-${LOCAL_LUA_VERSION:=5.1.5}"
  wget -O "$tmp_file" https://www.lua.org/ftp/lua-$LOCAL_LUA_VERSION.tar.gz \
    && tar xzf "$tmp_file" -C "$XDG_DATA_HOME" \
    && make -C "$LUA_INSTALL_DIR" linux && make -C "$LUA_INSTALL_DIR" install INSTALL_TOP="$XDG_PREFIX_HOME" \
    && info "lua-$LOCAL_LUA_VERSION install done" || err_exit "lua-$LOCAL_LUA_VERSION install FAILED!!"
  LUAROCKS_INSTALL_DIR="$XDG_DATA_HOME/luarocks"
  update_git_history "$LUAROCKS_INSTALL_DIR" https://github.com/luarocks/luarocks \
    && cd "$LUAROCKS_INSTALL_DIR" && ./configure --with-lua="$XDG_PREFIX_HOME" --prefix="$XDG_PREFIX_HOME" \
    && make && make install \
    && info "luarocks installed successfully" || err_exit "luarocks install FAILED"
  cd "$current_dir"
}
(false || ! command -v 'lua' &>/dev/null || ! command -v 'luarocks' &>/dev/null) && install_lua

function install_golang () {
  tmp_file=$(mktemp)
  wget -O "$tmp_file" "https://go.dev/dl/$(wget -O- 'https://go.dev/VERSION?m=text').linux-amd64.tar.gz" \
    && tar xzf "$tmp_file" -C "$XDG_DATA_HOME" \
    && ln -sf "$XDG_DATA_HOME/go/bin/"* "$XDG_BIN_HOME" \
    && info "go installed successfully" || err_exit "go install FAILED"
}
(false || ! command -v 'go' &>/dev/null) && install_golang

# install nvim from source
if ! command -v 'nvim' &>/dev/null || checkyes 'Install nvim from source?'; then
  NVIM_INSTLL_DIR="$XDG_DATA_HOME/nvim-git"
  update_git_history "$NVIM_INSTLL_DIR" https://github.com/neovim/neovim.git "${NVIM_BUILD_TAG:-stable}" \
    && cd "$NVIM_INSTLL_DIR" \
    && make CMAKE_BUILD_TYPE=RelWithDebInfo CMAKE_INSTALL_PREFIX="$XDG_PREFIX_HOME" install  \
    && info 'nvim installed' || err_exit 'NVIM BUILD FAILED'
  cd "$current_dir"
  # nvim dependencies
  pip install --user -U pynvim neovim-remote
  pnpm i -g neovim
  luarocks --local --lua-version=5.1 install magick
  # telescope
  checkcommand 'rg' 'cargo install ripgrep'
  # Lazy sync
  nvim --headless "+Lazy! sync | TSUpdateSync" "+noa qa"
fi

# install fzf
FZF_INSTALL_DIR="$XDG_DATA_HOME/fzf"
function install_fzf () {
  update_git_history "$FZF_INSTALL_DIR" https://github.com/junegunn/fzf.git shell/completion.zsh \
    && "$FZF_INSTALL_DIR/install" --xdg --key-bindings --completion --no-update-rc --no-bash --no-fish \
    && zcompile "$XDG_CONFIG_HOME/fzf/fzf.zsh" \
    && info 'fzf setup done' || err_exit 'fzf setup failed'
}
(false || ! command -v 'fzf' &>/dev/null) && install_fzf

# install getoptions
function install_getoptions () {
  wget https://github.com/ko1nksm/getoptions/releases/latest/download/getoptions -O $XDG_BIN_HOME/getoptions
  chmod +x $XDG_BIN_HOME/getoptions
}
(false || ! command -v 'getoptions' &>/dev/null) && install_getoptions

# install ulog / logrotate
function install_log_rotate () {
  update_git_history "$XDG_DATA_HOME/ulog" https://github.com/shawnfeng0/ulog.git
  mkdir -p "$XDG_DATA_HOME/ulog/build" && cd "$_" \
    && cmake .. && make \
    && ln -sf "$XDG_DATA_HOME/ulog/build/tools/logrotate/logrotate" "$XDG_BIN_HOME/ulog_rotate" \
    && info 'ulog_rotate setup done' || err_exit 'ulog_rotate setup failed'
  cd "$current_dir"
}
command -v 'ulog_rotate' &>/dev/null && info 'ulog_rotate found' || install_log_rotate

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
    && info 'lynx setup done' || err_exit 'lynx setup failed'
  cd "$current_dir"
fi

# install nvtop from source
command -v 'nvtop' &>/dev/null && info 'nvtop found' || warning 'nvtop not found.'
if checkyes 'Install nvtop from source?'; then
  update_git_history "$XDG_DATA_HOME/nvtop" https://github.com/Syllo/nvtop.git \
    && mkdir -p "$XDG_DATA_HOME/nvtop/build" && cd "$_" \
    && cmake .. -DCMAKE_INSTALL_PREFIX="$XDG_PREFIX_HOME" && make && make install \
    && info 'nvtop setup done' || err_exit 'nvtop setup failed'
  cd "$current_dir"
fi

# install gh from source
command -v 'gh' &>/dev/null && info 'gh found' || warning 'gh not found.'
if checkyes 'Install gh from source?'; then
  update_git_history "$XDG_DATA_HOME/gh-cli" https://github.com/cli/cli.git \
    && cd "$XDG_DATA_HOME/gh-cli" && make install prefix="$XDG_PREFIX_HOME" \
    && info 'gh setup done' || err_exit 'gh setup failed'
  cd "$current_dir"
fi

# install tmux from source
command -v 'tmux' &>/dev/null && info 'tmux found' || warning 'tmux not found.'
if checkyes 'Install tmux from source?'; then
  update_git_history "$XDG_DATA_HOME/tmux-git" https://github.com/tmux/tmux.git
  cd "$XDG_DATA_HOME/tmux-git" && ./autogen.sh && ./configure --prefix="$XDG_PREFIX_HOME" \
    && make -j$(nproc) && make install \
    && info 'tmux setup done' || err_exit 'tmux setup failed'
  cd "$current_dir"
fi
# install tmux plugin manager
TPM_INSTALL_DIR="$XDG_DATA_HOME/tmux/plugins/tpm"
update_git_history "$TPM_INSTALL_DIR" https://github.com/tmux-plugins/tpm \
  && info 'tmux plugmngr setup done' || err_exit 'tmux plugmngr setup failed'

# install btop from source
command -v 'btop' &>/dev/null && info 'btop found' || warning 'btop not found.'
if checkyes 'Install btop from source?'; then
  # sudo apt install coreutils sed git build-essential gcc-11 g++-11
  # gcc-11, g++-11 => gcc-10, g++-10
  BTOP_INSTALL_DIR="$XDG_DATA_HOME/btop"
  update_git_history "$BTOP_INSTALL_DIR" https://github.com/aristocratos/btop.git
  checkyes 'Use g++-10 (y) or g++-11 (N)?' && CXX="g++-10" || CXX="g++-11"
  make -C "$BTOP_INSTALL_DIR" QUIET=true ADDFLAGS=-march=native CXX="$CXX" \
    && make -C "$BTOP_INSTALL_DIR" install PREFIX="$XDG_PREFIX_HOME" \
    && info 'btop setup done' || err_exit 'btop setup failed'
fi

# install bmon (bandwidth monitor)
command -v 'bmon' &>/dev/null && info 'bmon found' || warning 'bmon not found.'
if checkyes 'Install bmon from source?'; then
  # sudo apt install build-essential make libconfuse-dev libnl-3-dev libnl-route-3-dev libncurses-dev pkg-config dh-autoreconf
  BMON_INSTALL_DIR="$XDG_DATA_HOME/bmon"
  update_git_history "$BMON_INSTALL_DIR" https://github.com/tgraf/bmon.git
  cd "$BMON_INSTALL_DIR" && ./autogen.sh && ./configure --prefix="$XDG_PREFIX_HOME" \
    && make -j$(nproc) && make install \
    && info 'bmon setup done' || err_exit 'bmon setup failed'
  cd "$current_dir"
fi

# install protoc from source
command -v 'protoc' &>/dev/null && info 'protoc found' || warning 'protoc not found.'
if checkyes 'Install protoc from source?'; then
  update_git_history "$XDG_DATA_HOME/protoc" https://github.com/protocolbuffers/protobuf.git 'v3.20.1'
  cd "$XDG_DATA_HOME/protoc" && ./autogen.sh && ./configure --prefix="$XDG_PREFIX_HOME" \
    && make -j$(nproc) && make install -j$(nproc) \
    && info 'protoc setup done' || err_exit 'protoc setup failed'
  cd "$current_dir"
fi

info "Everything is done. Thx!!"; true

