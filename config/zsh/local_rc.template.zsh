# Define environment
export LANG='en_US.UTF-8'
export MYENV='undefined'
export PCNAME='undefined'

# Define default file explorer and basic envvars
export FE='dolphin'
export GIT_SSH_COMMAND='ssh -i ~/.ssh/id_git -F /dev/null'
export GIT_PREFIX_HOME="$HOME/Git"
alias tmux="tmux -u" # force utf-8 support with tmux

# Define neovim vars
export NVIM_COLOR='jellybeans-nvim'
export NVIM_USE_TRANSPARENT=1
export NVIM_BUILD_TAG='nightly'

# Define clipboard commands
case x"$MYENV" in
  xwayland|xWayland) alias clip="wl-copy" paste="wl-paste" ;;
  *) alias clip="clipboard" paste="clipboard" ;;
esac

# WSL specific aliases
if [ x"$MYENV" = xWSL ]; then
  alias pdfpc="pdfpc -Ss" # for WSL
  export PYOPENGL_PLATFORM=egl
  export LIBGL_ALWAYS_INDIRECT=1
  if false; then
    export MESA_GL_VERSION_OVERRIDE=3.3
    export MESA_GLSL_VERSION_OVERRIDE=330
  fi
fi

# Unsafe connections
if false; then
  export REQUESTS_CA_BUNDLE=/usr/lib/ssl/certs/ca-certificates.crt
  export NODE_TLS_REJECT_UNAUTHORIZED=0
fi

# Define HTTP_PROXY on ssh connection
if [[ -n $LC_HTTP_PROXY ]]; then
  export HTTP_PROXY=$LC_HTTP_PROXY
  export HTTPS_PROXY=$LC_HTTP_PROXY
  export http_proxy=$LC_HTTP_PROXY
  export https_proxy=$LC_HTTP_PROXY
fi
if [[ -n $LC_NO_PROXY ]]; then
  export NO_PROXY=$LC_NO_PROXY
  export no_proxy=$LC_NO_PROXY
fi

function crop () {
  set -x
  if [[ x$1 = x'-h' ]]; then
    echo 'crop start[s], (length[s], (speed[nx]))'
    return
  fi
  echo $#
  start=$1
  length=''
  if [ $# -ge 2 ]; then
    length='-t '$2
  fi
  speed=1.5
  if [ $# -ge 3 ]; then
    speed=$3
  fi
  ffmpeg -i output.mp4 -vf crop=640:480:3:22 1.mp4 -y
  eval "ffmpeg -ss $1 -i 1.mp4 $length 2.mp4 -y"
  ffmpeg -i 2.mp4 -vf setpts=PTS/$speed -af atempo=$speed crop.mp4 -y
  # rm 1.mp4 2.mp4
  set +x
}

function syncddns () {
  cbw get item mydns.jp | jq '.login' | jq -r '"\(.username):\(.password)"'
  cbw get item mydns.jp | jq '.login' | jq -r '"\(.username):\(.password)"' | { read login; for v in 4 6; do curl -u "$login" "https://ipv$v.mydns.jp/login.html"; done }
}

function mount_netd_wsl() {
  error 'sudo apt install cifs-utils'
  from="$1"; to="$2"
  [ $# -ge 3 ] && user="$3" || read -p 'username: ' user
  [ $# -ge 4 ] && pass="$3" || read -sp 'password: ' pass
  sudo mkdir -p "$to"
  sudo mount -t cifs -o user="$user",pass="$pass",vers=1.0 "$from" "$to"
}

# # >>> conda initialize >>>
# # !! Contents within this block are managed by 'conda init' !!
# __conda_setup="$("$HOME/.local/share/miniconda3/bin/conda" 'shell.zsh' 'hook' 2> /dev/null)"
# if [ $? -eq 0 ]; then
#   eval "$__conda_setup"
# else
#   if [ -f "$HOME/.local/share/miniconda3/etc/profile.d/conda.sh" ]; then
#     . "$HOME/.local/share/miniconda3/etc/profile.d/conda.sh"
#   else
#     export PATH="$HOME/.local/share/miniconda3/bin:$PATH"
#   fi
# fi
# unset __conda_setup
# # <<< conda initialize <<<

true
