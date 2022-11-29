# zmodload zsh/zprof
# source () {
#   if [[ ! "$1.zwc" -nt "$1" ]]; then
#     echo "$1 not compiled"
#   fi
#   builtin source $@
# }
# . () {
#   if [[ ! "$1.zwc" -nt "$1" ]]; then
#     echo "$1 not compiled"
#   fi
#   builtin . $@
# }

mkdir -p "$XDG_CONFIG_HOME"
mkdir -p "$XDG_CACHE_HOME"
mkdir -p "$XDG_DATA_HOME"
mkdir -p "$XDG_STATE_HOME"
mkdir -p "$XDG_BIN_HOME"

export LANG=en_US.utf8

export EDITOR='vim'
export XDG_CONFIG_HOME="$HOME/.config"
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"


# History
# dont store duplicate lines in the history file
setopt HIST_SAVE_NO_DUPS
setopt HIST_IGNORE_ALL_DUPS
# write and import history on every command
setopt SHARE_HISTORY
setopt HIST_FIND_NO_DUPS
# Ignore histories starting with space
setopt hist_ignore_space # Ignore histories starting with space
HISTORY_IGNORE='([bf]g *|l[alsh]#( *)#|n#vim# *|conda i*|v[]|(cd|cat|less|dust|git|p|pip|curl|wget|grep|rm|mv|cp|ln) *|v[mzvarlsceh]|vlocal)'
HISTFILE="$XDG_CACHE_HOME/zsh/.zsh_history"
HISTSIZE=10000
SAVEHIST=10000
HISTTIMEFORMAT="[%Y/%M/%D %H:%M:%S] "
HISTCONTROL=ignoreboth

# Other
setopt auto_param_slash # if completed parameter is a directory, add a trailing slash
setopt magic_equal_subst # コマンドラインの引数で --prefix=/usr などの = 以降でも補完できる
setopt auto_pushd # 遷移したディレクトリをスタックする
setopt pushd_ignore_dups # 重複したディレクトリはスタックしない
setopt sh_word_split # enable word splitting of unquoted expansion in for loop
setopt AUTO_LIST # automatically list choices on ambiguous completion
setopt AUTO_MENU # show completion menu on a successive tab press
setopt COMPLETE_IN_WORD # complete from the cursor rather than from the end of the word
setopt NO_MENU_COMPLETE # do not autoselect the first completion entry
setopt ALWAYS_TO_END # Always place the cursor to the end of the word completed.
setopt INTERACTIVE_COMMENTS # allow comments in command line
setopt NO_FLOW_CONTROL  # Disable Ctrl+S and Ctrl+Q

# ${fg[blue]}等で色が利用できるようにする
autoload -Uz colors
export TERM=screen-256color
colors
# PROMPTの色
PROMPT="%{${fg_bold[green]}%}@%m%{${fg_bold[yellow]}%}>%{${fg_bold[red]}%}>%{${reset_color}%} "

# Completion for files
autoload -Uz compinit
compinit -d $ZDOTDIR/.zcompdump
_comp_options+=(globdots)		# Include hidden files.
export LS_COLORS='di=36:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
zstyle ':completion:*' use-cache true # キャッシュによる補完の高速化
zstyle ':completion:*' cache-path $XDG_CACHE_HOME/zsh/zcompcache
zstyle ':completion:*:default' menu select=2 # 補完後、メニュー選択モードになり左右キーで移動が出来る
zstyle ':completion:*' completer _expand _complete _history _prefix # 補完の出し方
zstyle ':completion:*' matcher-list "m:{a-z}={A-Z}" # 補完で大文字にもマッチ
zstyle ':completion:*' verbose true # 補完を詳細に表示
zstyle ':completion:*:messages' format "%{${fg_bold[yellow]}%}%d%{${reset_color}%}"
zstyle ':completion:*:warnings' format "%{${fg_bold[red]}%}No matches for:%{${fg_bold[yellow]}%} %d%{${reset_color}%}"
zstyle ':completion:*:descriptions' format "%{${fg_bold[yellow]}%}completing %B%d%b%{${reset_color}%}"
zstyle ':completion:*:corrections' format "%{${fg_bold[yellow]}%}%B%d ""%{${fg_bold[red]}%}(errors: %e)%b%{${reset_color}%}"
zstyle ':completion:*:options' description 'yes'
zstyle -e ':completion:*:(ssh|scp|sftp|rsh|rsync):hosts' hosts 'reply=(${=${${(f)"$(cat {/etc/ssh_,~/.ssh/known_}hosts(|2)(N) /dev/null)"}%% [# ]*}//,/ })'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS} # 補完候補に色を付ける
# git completions and information
RPROMPT="%{${fg[cyan]}%}[%~]%{${fg[blue]}%}[%*]%{${reset_color}%}"
autoload -Uz vcs_info
setopt prompt_subst
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' stagedstr "%{${fg_bold[yellow]}%}!"
zstyle ':vcs_info:git:*' unstagedstr "%{${fg_bold[red]}%}+"
zstyle ':vcs_info:*' formats "%{${fg_bold[green]}%}%c%u[%b]%f%{${reset_color}%}"
zstyle ':vcs_info:*' actionformats '[%b|%a]'
precmd () { vcs_info }
RPROMPT=$RPROMPT'${vcs_info_msg_0_}'

# vi mode
bindkey -v
export KEYTIMEOUT=20
bindkey -M viins 'jk' vi-cmd-mode
bindkey '^[[Z' reverse-menu-complete # shift-tab to go backward in menu
# use the vi navigation keys in menu completion
zmodload zsh/complist
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey '^k' up-history
bindkey '^j' down-history
bindkey -M viins '^b' insert-last-word
# Disable keybinds starting with <Esc>
bindkey -M vicmd '^[' undefined-key
bindkey -M vicmd -r "^[OA"    # up-line-or-history
bindkey -M vicmd -r "^[OB"    # down-line-or-history
bindkey -M vicmd -r "^[OC"    # vi-forward-char
bindkey -M vicmd -r "^[OD"    # vi-backward-char
bindkey -M vicmd -r "^[[200~" # bracketed-paste
bindkey -M vicmd -r "^[[A"    # up-line-or-history
bindkey -M vicmd -r "^[[B"    # down-line-or-history
bindkey -M vicmd -r "^[[C"    # vi-forward-char
bindkey -M vicmd -r "^[[D"    # vi-backward-char

# Change cursor shape for different vi modes.
function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] || [[ $1 = 'block' ]]; then
    echo -ne '\e[1 q'
  elif [[ ${KEYMAP} == main ]] || [[ ${KEYMAP} == viins ]] || [[ ${KEYMAP} = '' ]] || [[ $1 = 'beam' ]]; then
    echo -ne '\e[5 q'
  fi
} && zle -N zle-keymap-select
zle-line-init() { echo -ne "\e[5 q" } && zle -N zle-line-init
echo -ne '\e[5 q' # Use beam shape cursor on startup.
# Edit line in vim with ctrl-q:
autoload edit-command-line; zle -N edit-command-line
bindkey '^q' edit-command-line

# use BackSpace, Delete key
stty erase ""
bindkey "^?" backward-delete-char
bindkey "^[[3~" delete-char

[ -f "$ZDOTDIR/local_rc.zsh" ] && source "$ZDOTDIR/local_rc.zsh"
[ -f "$ZDOTDIR/rust_rc.zsh" ] && source "$ZDOTDIR/rust_rc.zsh"
[ -f "$ZDOTDIR/aliases_rc.zsh" ] && source "$ZDOTDIR/aliases_rc.zsh"

export ZSH_AUTOSUGGEST_MANUAL_REBIND=1
source "$XDG_DATA_HOME"/zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source "$XDG_DATA_HOME"/zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source "$XDG_CONFIG_HOME"/fzf/fzf.zsh
# keybinds for plugins
bindkey '^l' autosuggest-accept

[ -f "$ZDOTDIR/scripts_rc.zsh" ] && source "$ZDOTDIR/scripts_rc.zsh"

if ! [[ $PATH == "$XDG_BIN_HOME"* ]]; then
  export PATH="$XDG_BIN_HOME:$PATH"
fi

# zprof
true
