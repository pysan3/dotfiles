
fix_interop() {
    for i in $(pstree -np -s $$ | grep -o -E '[0-9]+'); do
        if [[ -e "/run/WSL/${i}_interop" ]]; then
            export WSL_INTEROP=/run/WSL/${i}_interop
        fi
    done
}

fix_interop
[ -z "$PS1" ] && return

export LANG=ja_JP.UTF-8

# ${fg[blue]}等で色が利用できるようにする
autoload -Uz colors
export TERM=screen-256color
colors
# 補完を利用
plugins=(… zsh-completions)
autoload -Uz compinit
compinit
_comp_options+=(globdots)		# Include hidden files.

# vi mode
bindkey -v
export KEYTIMEOUT=1

# Change cursor shape for different vi modes.
function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] ||
     [[ $1 = 'block' ]]; then
    echo -ne '\e[1 q'
  elif [[ ${KEYMAP} == main ]] ||
       [[ ${KEYMAP} == viins ]] ||
       [[ ${KEYMAP} = '' ]] ||
       [[ $1 = 'beam' ]]; then
    echo -ne '\e[5 q'
  fi
}
zle -N zle-keymap-select
zle-line-init() {
    zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
    echo -ne "\e[5 q"
}
zle -N zle-line-init
echo -ne '\e[5 q' # Use beam shape cursor on startup.

# Edit line in vim with ctrl-o:
autoload edit-command-line; zle -N edit-command-line
bindkey '^o' edit-command-line

setopt share_history # 他ターミナルとヒストリを共有
setopt histignorealldups # ヒストリを重複表示しない
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
HISTTIMEFORMAT="[%Y/%M/%D %H:%M:%S] "

setopt auto_param_slash # ディレクトリ名の補完で末尾に / を付加
setopt magic_equal_subst # コマンドラインの引数で --prefix=/usr などの = 以降でも補完できる

setopt auto_pushd # 遷移したディレクトリをスタックする
setopt pushd_ignore_dups # 重複したディレクトリはスタックしない

# backspace,deleteキーを使えるように
stty erase ^H
bindkey "^[[3~" delete-char

# 区切り文字の設定
autoload -Uz select-word-style
select-word-style default
zstyle ':zle:*' word-chars "_-./;@"
zstyle ':zle:*' word-style unspecified

PROMPT="%{${fg_bold[green]}%}@%m%{${fg_bold[yellow]}%}>%{${fg_bold[red]}%}>%{${reset_color}%} "

local DEFAULT=$'%{^[[m%}'$
local RED=$'%{^[[1;31m%}'$
local YELLOW=$'%{^[[1;33m%}'$

zstyle ':completion:*:default' menu select=2 # 補完後、メニュー選択モードになり左右キーで移動が出来る
# zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' # 補完で大文字にもマッチ
zstyle ':completion:*' verbose true # 補完を詳細に表示
zstyle ':completion:*' use-cache true # キャッシュによる補完の高速化
zstyle ':completion:*' completer _expand _complete _history _prefix # 補完の出し方
zstyle ':completion:*:messages' format '%F{YELLOW}%d%F{DEFAULT}'
zstyle ':completion:*:warnings' format '%F{RED}No matches for:''%F{YELLOW} %d%F{DEFAULT}'
zstyle ':completion:*:descriptions' format '%F{YELLOW}completing %B%d%b%F{DEFAULT}'
zstyle ':completion:*:corrections' format '%F{YELLOW}%B%d ''%F{RED}(errors: %e)%b%F{DEFAULT}'
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*' group-name ''

zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS} # 補完候補に色を付ける
export LS_COLORS='di=36:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'

bindkey -M viins '^j' vi-cmd-mode
export EDITOR='vim'
export XDG_CONFIG_HOME="$HOME/.config"

# 複数ファイルのmv 例　zmv *.txt *.txt.bk
autoload -Uz zmv
alias zmv='noglob zmv -W'

# git設定
RPROMPT="%{${fg[cyan]}%}[%~]%{${reset_color}%}"
autoload -Uz vcs_info
setopt prompt_subst
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' stagedstr "%{${fg_bold[yellow]}%}!"
zstyle ':vcs_info:git:*' unstagedstr "%{${fg_bold[red]}%}+"
zstyle ':vcs_info:*' formats "%{${fg_bold[green]}%}%c%u[%b]%f%{${reset_color}%}"
zstyle ':vcs_info:*' actionformats '[%b|%a]'
precmd () { vcs_info }
RPROMPT=$RPROMPT'${vcs_info_msg_0_}'

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

if [ -f ~/.zsh_local ]; then
   . ~/.zsh_local
fi
if [ -f ~/.zsh_aliases ]; then
   . ~/.zsh_aliases
fi

# expansion: =mv -> /bin/mv
unsetopt equals

# backspaceが認識されない問題を解決
stty erase ""
bindkey "^?" backward-delete-char

if [ ! -f "/usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]; then
  sudo git clone git://github.com/zsh-users/zsh-syntax-highlighting.git /usr/share/zsh/plugins/zsh-syntax-highlighting
fi
source "/usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
