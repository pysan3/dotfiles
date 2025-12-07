export DOTFILES=$HOME/dotfiles
source "$DOTFILES/functions.zsh"

export PIPENV_VENV_IN_PROJECT=1
export PIPENV_NO_INHERIT=1
export PIPENV_IGNORE_VIRTUALENVS=1
export PYTHON_KEYRING_BACKEND=keyring.backends.null.Keyring
export CONDA_ALWAYS_YES="true"
# alias ma='mamba'
# alias conda='mamba'
export CLICOLOR=1
export EDITOR='vim'
export MAKEFLAGS="-j$(nproc 2>/dev/null || sysctl -n hw.logicalcpu)"

[ x"$MYENV" = 'x' ] && export MYENV='undefined'
[ x"$PCNAME" = 'x' ] && export PCNAME='undefined'

alias ll='ls -Ahl --color=auto'
alias lr='ls -Rh --color=auto'
alias la='ls -Ah --color=auto'
alias l='ls -1 --color=auto'
alias tree='tree -a -I "\.DS_Store|\.git|node_modules|vendor\/bundle" -N'
alias grep='grep --color=auto'
alias egrep='grep -E'
alias gri='grep -i '
alias wcl='wc -l'
alias e='exit 0'
alias c='clear'
alias sc='sudo systemctl'
alias serve='http-server'

# Language specific
alias p='python'
function pm () { local file="${1:r}" && shift 1 && p -m "$(echo "$file" | sed 's,/,.,g' | sed 's/\.\.//g')" "$@" }
alias -s py='pm'
alias pt='pm pytest'
alias pts='pt -s'
alias ptsv='pts -vv'
alias c='cargo'

alias \$=''
alias rm='rm -i'
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
alias eng="env | grep -i "
alias xgs="xargs "
alias exportenv='while read -r f; do echo "${(q)f}"; done <<(env) > .env'
alias nowrap='setterm --linewrap off'
alias wrap='setterm --linewrap on'
function get_workdir () { basename "$PWD" | sed -e s'/[.-]/_/g' }

# bazel
function br () {
  local p="$(realpath --relative-to="$PWD" "$1")" j="$2" s='2'
  if [ -z "$j" ] && [[ -f "$p" ]]; then j="${p:t:r}" ; p="$(dirname "$p")" ; s='1'; fi
  ([ -z "$p" ] || [ -z "$j" ]) && error "Invalid args: <relpath> <job>: [$# < 2] $@" && return
  shift "$s"
  warning "$ bazel run" "//${p}:${j}" "$@"
  bazel run "//${p}:${j}" "$@"
}
function bt () {
  local p="$(realpath --relative-to="$PWD" "$1")"
  ([ -z "$p" ]) && error "Invalid args: <relpath>: [$# < 1] $@" && return
  shift 1
  warning "$ bazel test" "//${p}" "$@"
  bazel test "//${p}" "$@"
}

setopt extended_glob
typeset -A abbreviations
abbreviations=(
  "G"    "| grep"
  "X"    "| xargs"
  "T"    "| tail"
  "C"    "| clip-in"
  "LC"    "| tr -d '\n' | clip-in"
  "W"    "| wc"
  "A"    "| awk"
  "S"    "| sed"
  "E"    "2>&1 > /dev/null"
  "N"    "> /dev/null"
)
function magic-abbrev-expand () {
  local MATCH
  LBUFFER=${LBUFFER%%(#m)[-_a-zA-Z0-9]#}
  LBUFFER+=${abbreviations[$MATCH]:-$MATCH}
  zle self-insert
}
function no-magic-abbrev-expand () { LBUFFER+=' ' }
zle -N magic-abbrev-expand
zle -N no-magic-abbrev-expand
bindkey " " magic-abbrev-expand
bindkey "^x " no-magic-abbrev-expand

function jwtd () {
  echo "${1}" | jq -R 'split(".") | .[0],.[1] | @base64d | fromjson'
  echo -n "Signature: "
  [ -n "$2" ] && echo "${1}" | cut -d '.' -f 3 || echo "********"
}

function jwtx () {
  local name="JWT_TOKEN_${1:u}"
  local token="${(P)name}"
  if [ -n "$token" ]; then
    export JWT_TOKEN="$token"
    info "export JWT_TOKEN=\$${name}"
    shift 1
    jwtd "$JWT_TOKEN" "$@"
  fi
}

# kubectl
function k () {
  info "kubectl --context='$CONTEXT' --namespace='$NAMESPACE' $@"
  if [[ -n "$CONTEXT" && -n "$NAMESPACE" && "$#" -gt 0 ]]; then
    kubectl --context="$CONTEXT" -n "$NAMESPACE" "$@"
  fi
}
function klogf () {
  local pod="$(k get pods -o name | grep "$1" | head -n 1 | cut -d '/' -f 2)"
  if [ -z "$pod" ]; then
    error "Pod not found: $1"
    return 1
  fi
  shift 1
  k logs -f "$pod" "$@"
}
function koplogs () {
  local asset="$1" pod=""
  for pod in $(k get pods | grep 'Running' | grep "dagster-step-" | cut -d ' ' -f 1); do
    if k describe pod "$pod" 2>/dev/null | grep -q "dagster/op=$asset"; then
      info "Found pod: $pod"
    fi
  done
  if [ -z "$pod" ]; then
    error "Pod not found for asset: $asset"
    return 1
  fi
  shift 1
  k logs -f "$pod" "$@"
}

alias ..='cd ..'

alias g='git'
function cgit () { cd "${GIT_PREFIX_HOME:-$HOME/Git}" }
function main () {
  g co main || g co master
  local branch="$(g name)"
  g pull origin "$branch"
  if [ $(g remote -v | grep upstream | wcl) -ge 1 ]; then
    g pull upstream "$branch"
  else
    warning 'upstream branch not found.'
  fi
}
function clone () { cgit && R=$(paste | xargs | sed 's/  *//g') && gh repo clone "$R" && cd "$(basename "$R")" }
function fork () { cgit && R=$(paste | xargs | sed 's/  *//g') && gh repo fork --clone "$R" && cd "$(basename "$R")" }
function gh_latest_run () { gh run list -L 1 -b "$(g name)" --json databaseId -q '.[0].databaseId' -w $1 }
function gpr () { gh pr checkout "$(echo "$1" | cut -d '#' -f 1)" }
function rmcwd () { local _DELETE="$PWD" && cd .. && rm -rf "$_DELETE" }
function nopy () { export PATH=$(echo "$PATH" | sed -e 's/:/\n/g' | grep -v py | grep -v poetry | xargs | sed -e 's/ /:/g') }
function nojs () { export PATH=$(echo "$PATH" | sed -e 's/:/\n/g' | grep -v npm | grep -v nvm | xargs | sed -e 's/ /:/g') }
function yay () { ( nopy && nojs && command yay --noconfirm --sudoloop $@ ) }
function flatpak () { yes | ( command flatpak --user "$@" || command flatpak "$@" ) }
alias res="source $HOME/.zshenv && source $ZDOTDIR/.zshrc"

function def() {
  local cmd="${@[$#]}" # last argument
  local res="$(whence -v "$cmd")" raw="$(whence "$cmd" | cut -d ' ' -f 1)" lesscmd='less'
  [ x"$cmd" = x"$raw" ] && res=${res//an alias/a recursive}
  [ $(alias less &>/dev/null; echo $?) -eq 0 ] && lesscmd="$lesscmd -l zsh -pn"
  echo "$res"; draw_help () { local c=$(basename $1); tldr $c 2>/dev/null || eval "'$1' --help | $MANPAGER" || man $c }
  case $res in
    *'not found'*)  checkyes "Google it?" && eval "?g linux cli $cmd";;
    *function*)     (printf '#!/usr/bin/env zsh\n\n'; whence -f "$raw") | eval "$lesscmd" ;;
    *'an alias'*)   def "$raw" ;;
    *)              echo; draw_help "$raw"; whence "$raw" ;; # binary, builtin
  esac
}

function pyenv () {
  local global="$(command pyenv global)"
  [ -n "$global" ] && ( cd "$PYENV_ROOT/versions/" && ln -sf "$global" global )
  command pyenv $@
}

alias vm="NVIM_DISABLE_AUTOSESSION=1 dot nvim $DOTFILES/.vimrc"
alias vv="NVIM_DISABLE_AUTOSESSION=1 dot nvim $DOTFILES/.zshenv"
alias vz="NVIM_DISABLE_AUTOSESSION=1 dot nvim $ZDOTDIR/.zshrc"
alias va="NVIM_DISABLE_AUTOSESSION=1 dot nvim $ZDOTDIR/aliases_rc.zsh"
alias vr="NVIM_DISABLE_AUTOSESSION=1 dot nvim $ZDOTDIR/rust_rc.zsh"
alias vs="NVIM_DISABLE_AUTOSESSION=1 dot nvim $ZDOTDIR/script_rc.zsh"
alias vc="NVIM_DISABLE_AUTOSESSION=1 nvim $HOME/.mySecrets.env"
alias ve="NVIM_DISABLE_AUTOSESSION=1 nvim .env"
alias vh="NVIM_DISABLE_AUTOSESSION=1 vim $XDG_CACHE_HOME/zsh/.zsh_history"
alias vl="NVIM_DISABLE_AUTOSESSION=1 nvim $ZDOTDIR/local_rc.zsh"
alias vlocal="vim $XDG_CONFIG_HOME/nvim/local.vim"
function zk () { cd "$NCPATH/Notes" && cd - && tvim "$NCPATH/Notes" }

alias dc="docker-compose"
alias rp='realpath'
alias rel='rp -s --relative-to=$PWD'
alias po='poetry'
alias cargobi='cargo binstall --no-confirm'
alias tm="tmuxinator"
alias t='tmux'
alias ta='tmux a'
alias tat='tmux a -t'
alias tl="tmux ls"
alias ttmp="tmux new-session -A -s tmp"
function tn() { tmux new-session -A -s $(get_workdir) }
alias yt='yt-dlp --sponsorblock-remove default --part --format "bv*[ext=mp4]+ba[ext=m4a]/b[ext=mp4]"'
alias ytaudio='yt --extract-audio --audio-format mp3 --audio-quality 0 --write-thumbnail'
alias alembic-gen='alembic revision --autogenerate -m'
alias op='xdg-open'

function px () {
  HTTPS_PROXY="https://${PROXY_USER}:${PROXY_PASSWORD}@${PROXY_HOST}" \
    "$@"
}

alias piplist="pip freeze | grep -v 'pkg-resources' > requirements.txt; cat requirements.txt"

function act! () {
  [ -f 'bin/activate' ] && source bin/activate
  [ -f '.venv/bin/activate' ] && source .venv/bin/activate
  [ -f 'environment.yml' ] && conda activate $(cat environment.yml | grep name: | head -n 1 | cut -f 2 -d ':')
  [ -f 'environment.yaml' ] && conda activate $(cat environment.yaml | grep name: | head -n 1 | cut -f 2 -d ':')
  return 0
}

function act () { [ -z "$TMUX" ] && return 0 || act! }

# depends on local_rc.zsh
function cbw () {
  ( \
    set -a && source ~/.mySecrets.env && set +a \
      && bw unlock --passwordenv BW_PASSWORD >/dev/null; \
    echo $BW_PASSWORD | bw $@ \
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
  compile_zdot "$XDG_CACHE_HOME/zsh/.zcompdump"
  compile_zdot "$HOME/.zshenv"
  # compile_zdot .zprofile
  compile_zdot "$ZDOTDIR/.zshrc"
  return 0
}

function dot () {
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
  current_sh=".env.$(basename $PWD).sh"
  [ -f "$current_sh" ] && source "$current_sh"
  return 0
}

# Run dotenv on every new directory
function cd () {
  command -v 'deactivate' &>/dev/null && deactivate
  builtin cd "$@"; act; dotenv
  nonohup git maintenance start >/dev/null 2>&1
}
function popd () {
  command -v 'deactivate' &>/dev/null && deactivate
  builtin popd "$@"; act; dotenv
}
function pushd () {
  command -v 'deactivate' &>/dev/null && deactivate
  builtin pushd "$@"; act; dotenv
}

function syncit () {
  if ! command -v 'syncthing' &> /dev/null; then
    echo 'install syncthing'
    return
  fi
  eval "cp -v $@ ~/Sync"
}

function textemplate () {
  local template="$1" target="$2"
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

function timer () { termdown $1 && cvlc "$NCPATH/900-その他/Music/Clock-Alarm.mp3" --play-and-exit >/dev/null 2>/dev/null }
function ramen () { timer ${$((${1}*60*0.9)):r}s }

function pdfcompress () { ps2pdf -dPDFSETTINGS=/prepress -dCompatibilityLevel=1.4 -sOutputFile="compressed-$1" "$1" }
function pdflock () {
  local F="$2" TO="${2:r}_lock.pdf"
  if [ ! -f "$F" ]; then
    error "'$F' not found."; return 1
  fi
  [ $# -ge 3 ] && TO="$3"
  info "Found file: $F"
  qpdf --encrypt "$1" "$1" 256 -- "$F" "$TO" \
    && info "Locked file created: $TO" \
    || warning "Failed to create: $TO"
}

function lx () { command lynx -cfg="$LYNX_CFG" -lss="$LYNX_LSS" --useragent="$LYNX_USERAGENT" $@ }
function urlencode () {
  local str="$@" encoded="" i c x
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
function duck () { lx -cmd_script "$DOTFILES/static/lynx/duckduckgo.key.log" "https://duckduckgo.com/lite?kl=us-en&q=$(urlencode $@)" }
function duckja () { lx -cmd_script "$DOTFILES/static/lynx/duckduckgo.key.log" "https://duckduckgo.com/lite?kl=jp-jp&q=$(urlencode $@)" }
function google () { lx -cmd_script "$DOTFILES/static/lynx/google.key.log" "https://google.com/search?q=$(urlencode $@)" }
function imi () { lx "https://eow.alc.co.jp/search?q=$(urlencode $@)#resultsList-section" }
alias "?"=duck "??"=duckja "?g"=google

function colortest () {
  local T='gYw' FGs BG # The test text
  echo 'Color Test'
  echo '‾‾‾‾‾‾‾‾‾‾'
  echo -e "                 40m     41m     42m     43m     44m     45m     46m     47m"
  for FGs in '    m' '   1m' '  30m' '1;30m' '  31m' '1;31m' '  32m' \
             '1;32m' '  33m' '1;33m' '  34m' '1;34m' '  35m' '1;35m' \
             '  36m' '1;36m' '  37m' '1;37m'; do
    local FG=${FGs// /}
    echo -en " $FGs \033[$FG  $T  "
    for BG in 40m 41m 42m 43m 44m 45m 46m 47m; do
      echo -en "$EINS \033[$FG\033[$BG  $T  \033[0m"
    done
    echo
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
  local cv2_path="$(python -c 'import cv2, os; print(os.path.dirname(cv2.__file__))')"
  wget https://raw.githubusercontent.com/microsoft/python-type-stubs/main/stubs/cv2-stubs/__init__.pyi \
    -O "$cv2_path/__init__.pyi"
  yes | cp "$cv2_path/__init__.pyi" "$cv2_path/cv2.pyi"
}

function trun () { tmux new -d "$@" }
function tmv () { [ -z "$TMUX" ] && tmux a -t "$1" || tmux switchc -t "$1" }
function tvim() {
  [ $# -ge 1 ] && cd "$1" && trap 'popd &>/dev/null' EXIT
  local workdir=$(get_workdir) vimcmd='nvim .'
  if $(tmux has-session -t "=$workdir" 2> /dev/null); then
    tmv "$workdir"
    return 0
  fi
  [ -f "$PWD/.vim/session.vim" ] && vimcmd='nvim'
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
  local cmd='pipenv install'
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
  local res=$?
  po config virtualenvs.in-project true
  po env use $(python -c "import sys; i=sys.version_info; print(f'{i.major}.{i.minor}')")
  if [ $res -ne 0 ] && if checkyes '`pyproject.toml` might already exist. Do you want to install packages from it?'; then
    echo 'Installing from pyproject.toml'
    po install
  elif [ -f requirements.txt ] && checkyes 'Found a requirements.txt in the project. Do you want to reference it?'; then
    echo 'Installing from requirements.txt'
    checkyes 'Do you want to install the strict versions?'
    strict_version=$?
    local packages=' '
    cat requirements.txt | cut -f1 -d';' | while read package; do
      [[ x"$package" =~ ^x[#-].* ]] && continue
      [[ x"$package" = x ]] && continue
      [ $strict_version -ne 0 ] && package=$(echo "$package" | cut -d'=' -f1)
      packages="$packages '$package'"
    done
    eval "po add $packages"
  fi
  act!
}

function cinit() {
  local current_dir="$PWD"
  [ x"$(basename "$PWD")" = xbuild ] && cd ..
  rm -rf build
  mkdir build && cd build
  cmake ..
  cd "$current_dir"
}

function pfwd() {
  local svr="$1" port="$2"; shift 2
  eval "ssh -fNT $@ 127.0.0.1:${port}:127.0.0.1:${port} ${svr}" \
    && echo "Port forward to: http://127.0.0.1:${port}"
}

function img2eps () {
  checkdependency 'convert' || err_exit 'sudo apt install imagemagick -y'
  local filename
  setopt sh_word_split
  for filename in "$@"; do
    local dst="${filename:r}.eps"
    info "converting $filename -> $dst"
    convert "$filename" eps2:"$dst"
  done
}

function ex () {
  local filename
  setopt sh_word_split
  if command -v aunpack &> /dev/null; then
    ( set -xe; for filename in "$@"; do aunpack "$filename"; done )
    return 0
  fi
  warning 'Command aunpack not found. Install `atool`.'
  for filename in "$@"; do
    if [ -f "$filename" ]; then
      case "$filename" in
        *.tar.bz2)  tar xjf "$filename"  ;;
        *.tar.gz)   tar xzf "$filename"  ;;
        *.tar.xz)   tar xf "$filename"  ;;
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
  local filename
  setopt sh_word_split
  for filename in "$@"; do
    local bak_file="$filename.bak"
    if [ -f "$filename" ]; then
      mv -i "$filename" "$bak_file"
      [ -f "$filename" ] && warning "Skipping $filename"
    fi
  done
}

function rebak () {
  local filename
  setopt sh_word_split
  for filename in "$@"; do
    if ! [[ x"$filename" =~ .*bak ]]; then
      error "$filename does not end with '.bak'. Skipping."
      continue
    fi
    local bak_file="${filename:r}"
    if [ -f "$filename" ]; then
      mv -i "$filename" "${bak_file}"
      [ -f "$filename" ] && warning "Skipping $filename"
    fi
  done
}

alias upgradefp='! command flatpak --help &>/dev/null || ( flatpak update -y && flatpak remove --unused -y )'
alias upgradepy='pip install --upgrade --user pip pipupgrade && poetry self update && pyenv update && trun python -m pipupgrade --latest --yes'
alias upgraders='rustup update && trun cargo install-update --all'
alias upgradejs='nvm install --lts && nvm install-latest-npm && npm update -g && pnpm self-update && pnpm update -g'
function upgradeall() {
  for lang in fp py rs js; do
    eval "upgrade$lang" \
      && info "Success: $(alias upgrade$lang)" \
      || error "FAIL: $(alias upgrade$lang)"
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
  fzf-cdr-choose () { fzf -q "$LBUFFER" --prompt 'cd > ' +s --preview 'eval eza -Ahl --color=always {}' }
  local selected_dir="$(cdr -l | sed 's/^[0-9]\+ \+//' | fzf-cdr-choose)"
  unfunction fzf-cdr-choose
  if [ -n "$selected_dir" ]; then
    BUFFER=" cd ${selected_dir}"
    zle accept-line
  else
    BUFFER=''
    zle accept-line
  fi
}
zle -N fzf-cdr
bindkey '^E' fzf-cdr

true
