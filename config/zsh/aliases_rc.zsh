export DOTFILES=$HOME/dotfiles
source "$DOTFILES/functions.zsh"

# export PATH="$HOME"/myCommands:"$HOME"/myCommands/bin:$PATH
export FZF_DEFAULT_OPTS='--height=40% --cycle --info=hidden --tabstop=4 --black'

export PIPENV_VENV_IN_PROJECT=1
export PIPENV_NO_INHERIT=1
export PIPENV_IGNORE_VIRTUALENVS=1
export PYTHON_KEYRING_BACKEND=keyring.backends.null.Keyring
export CONDA_ALWAYS_YES="true"
# alias ma='mamba'
# alias conda='mamba'
export CLICOLOR=1
export EDITOR='vim'
export MAKEFLAGS="-j$(nproc)"
export RUSTC_WRAPPER=sccache

[ x"$MYENV" = 'x' ] && export MYENV='undefined'
[ x"$PCNAME" = 'x' ] && export PCNAME='undefined'

alias ll='ls -aFhl --color=auto'
alias lr='ls -RFh --color=auto'
alias la='ls -aFh --color=auto'
alias l='ls -1F --color=auto'
alias tree='tree -a -I "\.DS_Store|\.git|node_modules|vendor\/bundle" -N'
alias grep='grep --color=auto'
alias wcl='wc -l'
alias e='exit 0'
alias c='clear'
alias sc='sudo systemctl'
alias p='python'
function pm () {
  file="${1:r}"; shift 1
  p -m "$(echo "$file" | sed 's,/,.,g' | sed 's/\.\.//g')" "$@"
}

alias rm='rm -i --preserve-root'
alias rmf='rm -rf'
alias mv='mv -i'
alias cp='cp -i'
alias ln='ln -i'
alias trm='trash-put'
alias tls='trash-list'
alias trs='trash-restore'
alias ts="ts '[%Y-%m-%d %H:%M:%S]'"
alias tst="./node_modules/.bin/tree-sitter"

alias dt='date "+%F"'
alias egr="env | grep -i"
alias xgs="xargs "
alias exportenv='while read -r f; do echo "${(q)f}"; done <<(env) > .env'
alias nowrap='setterm --linewrap off'
alias wrap='setterm --linewrap on'
function get_workdir () { basename "$PWD" | sed -e s'/[.-]/_/g' }

alias ..='cd ..'

alias g='git'
alias clone='g clone'
alias main='(g co main || g co master) && g pl'
export GIT_SSH_COMMAND='ssh -i ~/.ssh/id_git -F /dev/null'
function nopy () {
  export PATH=$(echo "$PATH" | sed -e 's/:/\n/g' | grep -v py | grep -v poetry | xargs | sed -e 's/ /:/g')
}
function nojs () {
  export PATH=$(echo "$PATH" | sed -e 's/:/\n/g' | grep -v npm | grep -v nvm | xargs | sed -e 's/ /:/g')
}
function yay() {
  ( \
    nopy && nojs \
    && command yay --noconfirm --sudoloop $@ \
  )
}
alias res="source $HOME/.zshenv && source $ZDOTDIR/.zshrc"

function def() {
  cmd="${@[$#]}" # last argument
  res=$(whence -v "$cmd"); raw=$(whence "$cmd" | cut -d ' ' -f 1); lesscmd='less'
  [ x"$cmd" = x"$raw" ] && res=${res//an alias/a recursive}
  [ $(alias less &>/dev/null; echo $?) -eq 0 ] && lesscmd="$lesscmd -l zsh -pn"
  echo "$res"; draw_help () { c=$(basename $1); tldr $c 2>/dev/null || eval "'$1' --help | $MANPAGER" || man $c }
  case $res in
    *'not found'*)  checkyes "Google it?" && eval "?g linux cli $cmd";;
    *function*)     (printf '#!/usr/bin/env zsh\n\n'; whence -f "$raw") | eval "$lesscmd" ;;
    *alias*)        def "$raw" ;;
    *)              echo; draw_help "$raw"; whence "$raw" ;; # binary, builtin
  esac
}

alias upgradepy='pip install --upgrade --user pip pipupgrade && python -m pipupgrade --latest --yes && poetry self update && pyenv update' # pip install pipupgrade
alias upgraders='rustup update && cargo install-update --all 2>/dev/null &' # cargo install cargo-update
alias upgradejs='npm install -g npm@latest pnpm && pnpm upgrade -g'
function upgradeall() {
  upgradecmds='py rs js'
  for lang in $upgradecmds; do
    eval "upgrade$lang" \
      && info "Success: $(alias upgrade$lang)" \
      || error "FAIL: $(alias upgrade$lang)"
  done
}
function pyenv () {
  command pyenv $@
  cd "$PYENV_ROOT/versions/"
  ln -sf "$(command pyenv global)" global
  cd - >/dev/null
}

alias vm="dot nvim $DOTFILES/.vimrc"
alias vv="dot nvim $DOTFILES/.zshenv"
alias vz="dot nvim $ZDOTDIR/.zshrc"
alias va="dot nvim $ZDOTDIR/aliases_rc.zsh"
alias vr="dot nvim $ZDOTDIR/rust_rc.zsh"
alias vs="dot nvim $ZDOTDIR/script_rc.zsh"
alias vc="nvim ~/.mySecrets.env"
alias ve="nvim .env"
alias vh="vim $XDG_CACHE_HOME/zsh/.zsh_history"
alias vl="vim $ZDOTDIR/local_rc.zsh"
alias vlocal="vim $XDG_CONFIG_HOME/nvim/local.vim"

alias dc="docker-compose"
alias rp='realpath'
alias po='poetry'
alias tm="tmuxinator"
alias t='tmux'
alias ta='tmux a'
alias tat='tmux a -t'
alias tl="tmux ls"
alias ttmp="tmux new-session -A -s tmp"
function tn() { tmux new-session -A -s $(get_workdir) }
alias yt='yt-dlp --sponsorblock-remove default --part --format "bv*[ext=mp4]+ba[ext=m4a]/b[ext=mp4]"'
alias ytaudio='yt --extract-audio --audio-format mp3 --audio-quality 0 --write-thumbnail'
alias op='xdg-open'

alias piplist="pip freeze | grep -v 'pkg-resources' > requirements.txt; cat requirements.txt"
function act!() {
  [ -f 'bin/activate' ] && source bin/activate
  [ -f '.venv/bin/activate' ] && source .venv/bin/activate
  [ -f 'environment.yml' ] && conda activate $(cat environment.yml | grep name: | head -n 1 | cut -f 2 -d ':')
  [ -f 'environment.yaml' ] && conda activate $(cat environment.yaml | grep name: | head -n 1 | cut -f 2 -d ':')
  return 0
}
function act() {
  [ -z "$TMUX" ] && return 0
  act!
}
act

# depends on local_rc.zsh
function cbw () {
  ( \
    set -a && source ~/.mySecrets.env && set +a \
    && bw unlock --passwordenv BW_PASSWORD >/dev/null;
    echo $BW_PASSWORD | bw $*
  )
}
alias bwpass="jq '.login' | jq -r '.password' | sed 's/^ *\| *$//'"
alias here="$FE . >/dev/null 2>&1 &"
export NCPATH="$HOME/Nextcloud"

function update_zwc () {
  compile_zdot() { [ -f "$1" ] && zcompile "$1" && info "Compiled $1" }
  compile_zdot "$ZDOTDIR/local_rc.zsh"
  compile_zdot "$ZDOTDIR/rust_rc.zsh"
  compile_zdot "$ZDOTDIR/aliases_rc.zsh"
  compile_zdot "$ZDOTDIR/script_rc.zsh"
  # compile_zdot .zlogin
  # compile_zdot .zlogout
  compile_zdot "$ZDOTDIR/.zcompdump"
  compile_zdot "$HOME/.zshenv"
  # compile_zdot .zprofile
  compile_zdot "$ZDOTDIR/.zshrc"
  return 0
}

function dot() {
  local old_dir="$PWD"
  cd $DOTFILES
  if [ $# -ne 0 ]; then
    eval "$@"
    run_cmd () { eval "$@" && info "Success: '$@'" || error "Failed: '$@'" }
    run_cmd "$HOME"/dotfiles/install_all.zsh
    run_cmd res
    run_cmd update_zwc
    cd "$old_dir"
  fi
}

# .env loading in the shell
function dotenv () {
  [ -f .env ] && source .env
  [ -f .env.sh ] && source .env.sh
  return 0
}
dotenv

# Run dotenv on every new directory
function cd () {
  command -v 'deactivate' &>/dev/null && deactivate
  builtin cd "$@"; act; dotenv
}
function popd () {
  command -v 'deactivate' &>/dev/null && deactivate
  builtin popd "$@"; act; dotenv
}
function pushd () {
  command -v 'deactivate' &>/dev/null && deactivate
  builtin pushd "$@"; act; dotenv
}

function zk () {
  tvim "$NCPATH/Notes"
}

function syncit () {
  if ! command -v 'syncthing' &> /dev/null; then
    echo 'install syncthing'
    return
  fi
  eval "cp -v $@ ~/Sync"
}

function textemplate () {
  template="$1"
  target="$2"
  if [ ! -f "$template" ]; then
    error "$template not found."
    return 1
  elif [ -f "$target" ]; then
    warning "$target already exists."
    checkyes 'overwrite?'
    if [ $? -eq 0 ]; then
      cat "$template" > "$target"
      return 0
    fi
    checkyes 'append?'
    if [ $? -eq 0 ]; then
      cat "$template" >> "$target"
      return 0
    fi
    error 'Abort'
    return 1
  else
    cat "$template" > "$target"
    return 0
  fi
}

alias tasktex="textemplate $NCPATH/Templates/task-template.tex"
alias papertex="cp $NCPATH/Templates/template.sty . && textemplate $NCPATH/Templates/paper-template.tex"

function cpp () {
  for lst in "$@"; do :; done
  mkdir -p $lst
  cp $@
}

function timer () {
  termdown $1 && cvlc "$NCPATH/900-その他/Music/Clock-Alarm.mp3" --play-and-exit >/dev/null 2>/dev/null
}

alias ramen='timer 150'

function pdflock () {
  F="$2"
  if [ ! -f "$F" ]; then
    echo "'$F' not found."; return 1
  fi
  [ $# -lt 3 ] && TO="${2:r}_lock.pdf" || TO="$3"
  echo "Found file: $F"
  echo "Locked file created: $TO"
  qpdf --encrypt "$1" "$1" 256 -- "$F" "$TO"
}

function lx () {
  command lynx -cfg="$LYNX_CFG" -lss="$LYNX_LSS" --useragent="$LYNX_USERAGENT" $*
}

function urlencode () {
  declare str="$*"; declare encoded=""; declare i c x
  for (( i=0; i<${#str}; i++ )); do
    c=${str:$i:1}
    case "$c" in
      [-_.~a-zA-Z0-9]) x="$c";;
      *) printf -v x '%%%02x' "'$c";;
    esac
    encoded+="$x"
  done
  echo "$encoded"
}

function duck () {
  declare url=$(urlencode "$*")
  lx -cmd_script "$DOTFILES/static/lynx/duckduckgo.key.log" "https://duckduckgo.com/lite?kl=us-en&q=$url"
}
alias "?"=duck
function duckja () {
  declare url=$(urlencode "$*")
  lx -cmd_script "$DOTFILES/static/lynx/duckduckgo.key.log" "https://duckduckgo.com/lite?kl=jp-jp&q=$url"
}
alias "??"=duckja
function google () {
  declare url=$(urlencode "$*")
  lx -cmd_script "$DOTFILES/static/lynx/google.key.log" "https://google.com/search?q=$url"
}
alias "?g"=google

function pdfcompress () {
  	ps2pdf -dPDFSETTINGS=/prepress -dCompatibilityLevel=1.4 -sOutputFile="compressed-$1" "$1"
}

function colortest () {
  T='gYw'   # The test text
  echo 'Color Test'
  echo '‾‾‾‾‾‾‾‾‾‾'
  echo -e "                 40m     41m     42m     43m     44m     45m     46m     47m"
  for FGs in '    m' '   1m' '  30m' '1;30m' '  31m' '1;31m' '  32m' \
             '1;32m' '  33m' '1;33m' '  34m' '1;34m' '  35m' '1;35m' \
             '  36m' '1;36m' '  37m' '1;37m'; do
    FG=${FGs// /}
    echo -en " $FGs \033[$FG  $T  "
    for BG in 40m 41m 42m 43m 44m 45m 46m 47m; do echo -en "$EINS \033[$FG\033[$BG  $T  \033[0m"; done
    echo;
  done
}

function appearance () {
  cat \
    <(colortest) \
    <(wget -O- 'https://unicode.org/Public/emoji/13.0/emoji-test.txt' 2> /dev/null) \
    <(wget -O- 'https://www.cl.cam.ac.uk/~mgk25/ucs/examples/UTF-8-demo.txt' 2> /dev/null) \
    | less
}

function cv2_get () {
  cv2_path="$(python -c 'import cv2, os; print(os.path.dirname(cv2.__file__))')"
  wget https://raw.githubusercontent.com/microsoft/python-type-stubs/main/stubs/cv2-stubs/__init__.pyi \
    -O "$cv2_path/__init__.pyi"
  yes | cp "$cv2_path/__init__.pyi" "$cv2_path/cv2.pyi"
}

function tmv () {
  sessioncmd="-t $1"
  [ -z "$TMUX" ] && tmux a $sessioncmd || tmux switchc $sessioncmd
}

function tvim() {
  [ $# -ge 1 ] && cd "$1" && trap 'popd &>/dev/null' EXIT
  workdir=$(get_workdir)
  if $(tmux has-session -t "=$workdir" 2> /dev/null); then
    tmv "$workdir"
    return 0
  fi
  [ -f "$PWD/.vim/session.vim" ] && vimcmd='nvim' || vimcmd='nvim .'
  tmux new-session -s "$workdir" -d
  [ x$MYENV = xWSL ] && sleep 1
  tmux send-keys -t "$workdir" "$vimcmd" ENTER
  tmux select-layout -t "$workdir" main-vertical
  tmv "$workdir"
}

function venv() {
  python -m venv "$1"
  cd "$1"
  source bin/activate
  pip install wheel
  piplist
}

function pinit() {
  cmd='pipenv install'
  if [ -f requirements.txt ] && checkyes 'Found a requirements.txt in the project. Do you want to reference it?'; then
    echo 'Installing from requirements.txt'
    cmd="$cmd -r requirements.txt"
  fi
  eval $cmd
  act
  pipenv install attrdict rich
  pipenv install --dev isort pylint autopep8 flake8
  pylint --generate-rcfile > .pylintrc
}

function tinit () {
  po init
  res=$?
  po config virtualenvs.in-project true
  po env use $(python -c "import sys; i=sys.version_info; print(f'{i.major}.{i.minor}')")
  if [ $res -ne 0 ]; then
    if checkyes '`pyproject.toml` might already exist. Do you want to install packages from it?'; then
      echo 'Installing from pyproject.toml'
      po install
    fi
  elif [ -f requirements.txt ]; then
    if checkyes 'Found a requirements.txt in the project. Do you want to reference it?'; then
      echo 'Installing from requirements.txt'
      checkyes 'Do you want to install the strict versions?'
      strict_version=$?
      packages=' '
      cat requirements.txt | cut -f1 -d';' | while read package; do
        if [[ x"$package" =~ ^x[#-].* ]]; then continue; fi
        if [[ x"$package" = x ]]; then continue; fi
        if [ $strict_version -ne 0 ]; then package=$(echo "$package" | cut -d'=' -f1); fi
        packages="$packages '$package'"
      done
      eval "po add $packages"
    fi
  fi
  act
}

function cinit() {
  rm -rf build
  mkdir build && cd build
  cmake ..
}

function pfwd() {
  # ssh -fNT -L 127.0.0.1:$2:127.0.0.1:$2 $1 && echo "Port forward to: http://127.0.0.1:$2"
  svr="$1"; port="$2"; shift 2
  eval "ssh -fNT $@ 127.0.0.1:${port}:127.0.0.1:${port} ${svr}" && echo "Port forward to: http://127.0.0.1:${port}"
}

function img2eps () {
  if ! command -v 'convert' &> /dev/null; then
    sudo apt install imagemagick -y
  fi
  for filename in $@; do
    echo "$filename"
    name=$(echo $filename | cut -f 1 -d '.')
    convert $filename eps2:$name.eps
  done
}

function ex () {
  for filename in "$@"; do
    if [ -f "$filename" ]; then
      case "$filename" in
        *.tar.bz2)  tar xjf "$filename"  ;;
        *.tar.gz)   tar xzf "$filename"  ;;
        *.bz2)      bunzip2 "$filename"  ;;
        *.rar)      unrar x "$filename"  ;;
        *.gz)       gunzip "$filename"   ;;
        *.tar)      tar xf "$filename"   ;;
        *.tbz2)     tar xjf "$filename"  ;;
        *.tgz)      tar xzf "$filename"  ;;
        *.zip)      unzip "$filename"    ;;
        *.Z)        uncompress "$filename";;
        *.7z)       7z x "$filename"     ;;
        *)          echo "'$filename' cannot be extracted via ex()" ;;
      esac
    else
      echo "'$filename' is not found"
    fi
  done
}

function bak () {
  for filename in $@; do
    bak_file="$filename.bak"
    if [ -f "$filename" ]; then
      mv -i "$filename" "$bak_file"
      [ -f "$filename" ] && warning "Skipping $filename"
    fi
  done
}

function rebak () {
  for filename in $@; do
    if ! [[ x"$filename" =~ .*bak ]]; then
      error "$filename does not end with '.bak'. Skipping."
      continue
    fi
    bak_file="${filename:r}"
    if [ -f "$filename" ]; then
      mv -i "$filename" "${bak_file}"
      [ -f "$filename" ] && warning "Skipping $filename"
    fi
  done
}

function sshfs_remote () {
  if [ -z "$(command ls -A $2)" ]; then
    tmux has-session -t sshfs 2>/dev/null || tmux new -d -s sshfs
    sleep 2 # wait for tmux to start (especially in WSL)
    tmux send-keys -t sshfs "command sshfs $1 $2 -o allow_other" Enter
  fi
}

function happ() {
  trap "echo terminated; git remote rm heroku; return" 1 2 3 15
  heroku git:remote --app $(basename -s .git $(git remote get-url origin))
  eval "heroku $@"
  echo "delete"
  git remote rm heroku
}

# cdr: run fzf with dir history
if [[ -n $(echo ${^fpath}/chpwd_recent_dirs(N)) && -n $(echo ${^fpath}/cdr(N)) ]]; then
  autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
  add-zsh-hook chpwd chpwd_recent_dirs
  zstyle ':completion:*' recent-dirs-insert both
  zstyle ':chpwd:*' recent-dirs-default true
  zstyle ':chpwd:*' recent-dirs-max 1000
  zstyle ':chpwd:*' recent-dirs-file "$HOME/.cache/chpwd-recent-dirs"
fi
function fzf-cdr () {
  local selected_dir="$(cdr -l | sed 's/^[0-9]\+ \+//' | fzf --query="$LBUFFER" --prompt='cd > ' +s --preview 'eval eza -aFhl {}')"
  if [ -n "$selected_dir" ]; then
    BUFFER="cd ${selected_dir}"
    zle accept-line
  else
    BUFFER=''
    zle accept-line
  fi
}
zle -N fzf-cdr
bindkey '^E' fzf-cdr

true
