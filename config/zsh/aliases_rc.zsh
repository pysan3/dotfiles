export DOTFILES=$HOME/dotfiles
source "$DOTFILES/functions.zsh"

# export PATH="$HOME"/myCommands:"$HOME"/myCommands/bin:$PATH
export FZF_DEFAULT_OPTS='--height=40% --cycle --info=hidden --tabstop=4 --black'

export PIPENV_VENV_IN_PROJECT=1
export PIPENV_NO_INHERIT=1
export PIPENV_IGNORE_VIRTUALENVS=1
export CLICOLOR=1
export EDITOR='vim'
export MAKEFLAGS="-j$(nproc)"

if [ x"$MYENV" = 'x' ]; then
  export MYENV='undefined';
fi
if [ x"$PCNAME" = 'x' ]; then
  export PCNAME='undefined';
fi

alias ll='ls -aFhl --color=auto'
alias lr='ls -RFh --color=auto'
alias la='ls -aFh --color=auto'
alias l='ls -1F --color=auto'
alias tree='tree -a -I "\.DS_Store|\.git|node_modules|vendor\/bundle" -N'
alias grep='grep --color=auto'
alias e='exit 0'
alias p='python'

alias rm='rm -i --preserve-root'
alias mv='mv -i'
alias cp='cp -i'
alias ln='ln -i'
alias tp='trash-put'
alias tlist='trash-list'
alias tres='trash-restore'
alias ts="ts '[%Y-%m-%d %H:%M:%S]'"

alias ..='cd ..'

alias g='git'
export GIT_SSH_COMMAND='ssh -i ~/.ssh/id_git -F /dev/null'
alias yay='yay --noconfirm'
alias res="source $HOME/.zshenv && source $ZDOTDIR/.zshrc"

function def() {
  res=$(type $@)
  case $res in
    *function*)         echo $res && declare -f $@ ;;
    *builtin*|*alias*)  run-help $@ ;;
    *)                  echo $res ;;
  esac
}

function upgradeall() {
  upgradecmds='py rs js rb hs'
  for lang in $upgradecmds; do
    cmd=$(def "upgrade$lang")
    eval "upgrade$lang" && info "DONE: $cmd" || error "FAIL: $cmd"
  done
}
alias upgradepy='pipupgrade --verbose --latest --yes; poetry self update' # pip install pipupgrade
alias upgraders='cargo install-update --all' # cargo install cargo-update
alias upgradejs='npm install -g pnpm && pnpm upgrade -g'
alias upgraderb='gem update'
alias upgradehs='cabal new-update' # cabal new-install --overwrite-policy=always pandoc pandoc-citeproc pandoc-crossref
alias upgradezap='zap upgrade'

alias vm="cd; nvim $ZDOTDIR/.vimrc; cd - >/dev/null"
alias vz="cd; nvim $ZDOTDIR/.zshrc; cd - >/dev/null"
alias vv="cd; nvim $HOME/.zshenv; cd - >/dev/null"
alias va="cd; nvim $ZDOTDIR/aliases_rc.zsh; cd - >/dev/null"
alias vr="cd; nvim $ZDOTDIR/rust_rc.zsh; cd - >/dev/null"
alias vl="cd; nvim $ZDOTDIR/local_rc.zsh; cd - >/dev/null"
alias vs="cd; nvim $ZDOTDIR/script_rc.zsh; cd - >/dev/null"
alias vc="cd; nvim ~/.mySecrets.env; cd - >/dev/null"
alias ve="cd; nvim .env; cd - >/dev/null"
alias vh="cd; nvim $XDG_CACHE_HOME/zsh/.zsh_history; cd - >/dev/null"
alias vlocal="cd; nvim $XDG_CONFIG_HOME/nvim/local.vim; cd - >/dev/null"

alias dc="docker-compose"
alias rp='realpath'
alias po='poetry'
alias tm="tmuxinator"
alias t='tmux'
alias ta='tmux a'
alias tat='tmux a -t'
alias tl="tmux ls"
alias ttmp="tmux new-session -A -s tmp"
function tn() { tmux new-session -A -s $(basename "$PWD") }
alias yt='youtube-dl -ci -f mp4'

alias piplist="pip freeze | grep -v 'pkg-resources' > requirements.txt; cat requirements.txt"
function act() {
  [ -f 'bin/activate' ] && source bin/activate
  [ -f '.venv/bin/activate' ] && source .venv/bin/activate
  return 0
}
act

# depends on local_rc.zsh
function cbw () {
  ( \
    set -a && source ~/.mySecrets.env && set +a \
    && bw unlock --passwordenv BW_PASSWORD >/dev/null 2>&1;
    echo $BW_PASSWORD | bw $* 2>/dev/null
  )
}
alias bwpass="jq '.login' | jq -r '.password'"
alias here="$FE . >/dev/null 2>&1 || true"

function update_zwc () {
  compile_zdot() { [ -f "$1" ] && [ ! "$1.zwc" -nt "$1" ] && zcompile "$1" && info "Compiled $1" }
  compile_zdot "$HOME/.zshenv"
  # compile_zdot .zprofile
  compile_zdot "$ZDOTDIR/.zshrc"
  compile_zdot "$ZDOTDIR/local_rc.zsh"
  compile_zdot "$ZDOTDIR/rust_rc.zsh"
  compile_zdot "$ZDOTDIR/aliases_rc.zsh"
  compile_zdot "$ZDOTDIR/script_rc.zsh"
  # compile_zdot .zlogin
  # compile_zdot .zlogout
  compile_zdot "$ZDOTDIR/.zcompdump"
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
}
dotenv

# Run dotenv on every new directory
function cd () {
  deactivate >/dev/null 2>/dev/null
  builtin cd $@
  act
  dotenv
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
  if [ $# -lt 3 ]; then
    TO="${2%.*}_lock.pdf"
  else
    TO="$3"
  fi
  echo "Found file: $F"
  echo "Locked file created: $TO"
  qpdf --encrypt "$1" "$1" 40 -- "$F" "$TO"
}

function lynxf () {
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
  lynxf -cmd_script "$DOTFILES/static/lynx/duckduckgo.key.log" "https://duckduckgo.com/lite?kl=us-en&q=$url"
}
alias "?"=duck
function duckja () {
  declare url=$(urlencode "$*")
  lynxf -cmd_script "$DOTFILES/static/lynx/duckduckgo.key.log" "https://duckduckgo.com/lite?kl=jp-jp&q=$url"
}
alias "??"=duckja
function google () {
  declare url=$(urlencode "$*")
  lynxf -cmd_script "$DOTFILES/static/lynx/google.key.log" "https://google.com/search?q=$url"
}
alias "?g"=google

function pdfcompress () {
  	ps2pdf -dPDFSETTINGS=/prepress -dCompatibilityLevel=1.4 -sOutputFile="compressed-$1" "$1"
}

function appearance () {
  cat \
    <(wget -O- 'https://www.cl.cam.ac.uk/~mgk25/ucs/examples/UTF-8-demo.txt' 2> /dev/null) \
    <(wget -O- 'https://unicode.org/Public/emoji/13.0/emoji-test.txt' 2> /dev/null) \
    | less
}

function tvim() {
  if [ $# -ge 1 ]; then
    cd "$1"
  fi
  workdir=$(basename "$PWD" | sed -e 's/\.//g')
  if `tmux has-session -t "$workdir" 2> /dev/null`; then
    checkyes "Found a session named $workdir. Delete?"
    if [ $? -eq 0 ]; then
      tmux kill-session -t "$workdir"
    else
      tmux attach-session -t "$workdir"
      return 0
    fi
  fi
  vimcmd="act && nvim"
  if [ ! -f "$PWD/.vim/session.vim" ]; then
    vimcmd="$vimcmd ."
  fi
  tmux new-session -s "$workdir" -d
  if [ x$MYENV = xWSL ]; then
    sleep 1
  fi
  tmux send-keys -t "$workdir" "$vimcmd" ENTER
  tmux select-layout -t "$workdir" main-vertical
  tmux a -t "$workdir"
}

function venv() {
  python -m venv "$@";
  cd "$@";
  source bin/activate;
  pip install wheel;
  pip install attrdict;
  piplist;
}

function pinit() {
  cmd='pipenv install'
  if [ -f requirements.txt ]; then
    checkyes 'Found a requirements.txt in the project. Do you want to reference it?'
    if [ $? -eq 0 ]; then
      echo 'Installing from requirements.txt'
      cmd=$cmd' -r requirements.txt'
    fi
  fi
  eval $cmd
  act;
  pipenv install attrdict rich;
  pipenv install --dev isort pylint autopep8 flake8
  pylint --generate-rcfile > .pylintrc
}

function tinit () {
  po init
  res=$?
  po config virtualenvs.in-project true
  po env use $(python -c "import sys; i=sys.version_info; print(f'{i.major}.{i.minor}')")
  if [ $res -ne 0 ]; then
    checkyes '`pyproject.toml` might already exist. Do you want to install packages from it?'
    if [ $? -eq 0 ]; then
      echo 'Installing from pyproject.toml'
      po install
    fi
  elif [ -f requirements.txt ]; then
    checkyes 'Found a requirements.txt in the project. Do you want to reference it?'
    if [ $? -eq 0 ]; then
      echo 'Installing from requirements.txt'
      checkyes 'Do you want to install the strict versions?'
      strict_version=$?
      cat requirements.txt | cut -f1 -d';' | while read package; do
      if [[ x"$package" =~ ^x[#-].* ]]; then continue; fi
      if [[ x"$package" = x ]]; then continue; fi
      if [ $strict_version -ne 0 ]; then
        package=$(echo "$package" | cut -d'=' -f1)
      fi
      po add "$package"
    done
    fi
  fi
  act
}

function cinit() {
  rm -rf build;
  mkdir build;
  cd build;
  cmake ..;
}

function pfwd() {
  # ssh -fNT -L 127.0.0.1:$2:127.0.0.1:$2 $1 && echo "Port forward to: http://127.0.0.1:$2"
  svr="$1"; port="$2"; shift 2
  eval "ssh -fNT $@ -L 127.0.0.1:${port}:127.0.0.1:${port} ${svr}" && echo "Port forward to: http://127.0.0.1:${port}"
}

function img2eps () {
  if ! command -v 'convert' &> /dev/null; then
    sudo apt install imagemagick
  fi
  for filename in $@; do
    echo "$filename"
    name=$(echo $filename | cut -f 1 -d '.')
    convert $filename eps2:$name.eps
  done
}

function ex () {
  for filename in $@; do
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

function sshfs_remote() {
  if [ -z "$(command ls -A $2)" ]; then
    tmux has-session -t sshfs 2>/dev/null || tmux new -d -s sshfs
    sleep 2 # wait for tmux to start (especially in WSL)
    tmux send-keys -t sshfs "command sshfs $1 $2 -o allow_other" Enter
  fi
}

function happ() {
  trap "echo terminated; git remote rm heroku; return" 1 2 3 15
  heroku git:remote --app $(basename -s .git `git remote get-url origin`)
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
  local selected_dir="$(cdr -l | sed 's/^[0-9]\+ \+//' | fzf --query="$LBUFFER" --prompt='cd > ' +s --preview 'eval exa -aFhl {}')"
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