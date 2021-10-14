" set leader key
let g:mapleader = "\<Space>"

"----------------------------------------------------------
" Color schema
"----------------------------------------------------------
set t_Co=256                            " Set color sceme work properly
set t_ut=
syntax enable                           " Enables syntax highlighing

"----------------------------------------------------------
" Extentions
"----------------------------------------------------------
filetype plugin on

"----------------------------------------------------------
" Fonts and letters
"----------------------------------------------------------
set encoding=utf-8                      " The encoding displayed
scriptencoding utf-8
set fileencoding=utf-8                  " The encoding written to file
set fileencodings=utf-8,ucs-boms,euc-jp,cp932 " 読み込み時の文字コードの自動判別. 左側が優先される
set fileformats=unix,dos,mac " 改行コードの自動判別. 左側が優先される
set ambiwidth=double " □や○文字が崩れる問題を解決

"----------------------------------------------------------
" Cursor
"----------------------------------------------------------
set whichwrap=b,s,h,l,<,>,[,],~ " カーソルの左右移動で行末から次の行の行頭への移動が可能になる
set cursorline " カーソルラインをハイライト
set backspace=indent,eol,start

set hidden                              " Required to keep multiple buffers open multiple buffers
set number relativenumber
set nu rnu
set mouse=a                             " Enable your mouse
set showbreak=↪
set iskeyword+=-                      	" treat dash separated words as a word text object"
set scrolloff=16

"----------------------------------------------------------
" Window
"----------------------------------------------------------
set pumheight=10                        " Makes popup menu smaller
set cmdheight=2                         " More space for displaying messages
set splitbelow                          " Horizontal splits will automatically be below
set splitright                          " Vertical splits will automatically be to the right
set background=dark                     " tell vim what the background color looks like

"----------------------------------------------------------
" Search
"----------------------------------------------------------
set incsearch " インクリメンタルサーチ. １文字入力毎に検索を行う
set ignorecase " 検索パターンに大文字小文字を区別しない
set smartcase " 検索パターンに大文字を含んでいたら大文字小文字を区別する
set hlsearch " 検索結果をハイライト

"----------------------------------------------------------
" Tab, Intent
"----------------------------------------------------------
set expandtab " タブ入力を複数の空白入力に置き換える
set tabstop=4 " 画面上でタブ文字が占める幅
set softtabstop=4 " 連続した空白に対してタブキーやバックスペースキーでカーソルが動く幅
set autoindent " 改行時に前の行のインデントを継続する
set smartindent " 改行時に前の行の構文をチェックし次の行のインデントを増減する
set smarttab                            " Makes tabbing smarter will realize you have 2 vs 4
set shiftwidth=4 " smartindentで増減する幅
set showtabline=2                       " Always show tabs
set formatoptions-=cro
set colorcolumn=120

"----------------------------------------------------------
" Trailing Spaces
"----------------------------------------------------------
set conceallevel=2                      " So that I can see `` in markdown files
set concealcursor=""

"----------------------------------------------------------
" Coc configs
"----------------------------------------------------------
set nobackup                            " This is recommended by coc
set nowritebackup                       " This is recommended by coc

"----------------------------------------------------------
" Vim commands wait time
"----------------------------------------------------------
set updatetime=300                      " Faster completion
set timeoutlen=500                      " By default timeoutlen is 1000 ms
" set autochdir                           " Your working directory will always be the same as your working directory

"----------------------------------------------------------
" Command mode
"----------------------------------------------------------
set wildmenu " コマンドモードの補完
set history=5000 " 保存するコマンド履歴の数

"----------------------------------------------------------
" Command mode
"----------------------------------------------------------
autocmd TermOpen * setlocal nonumber norelativenumber

"----------------------------------------------------------
" Toggle spell check
"----------------------------------------------------------
nnoremap <F6> :set spell! spelllang=en_us,cjk<CR>
nnoremap <F7> :set nospell!<CR>
nnoremap zg zg]s

" else
au! BufWritePost $MYVIMRC source %      " auto source when writing to init.vm alternatively you can run :source $MYVIMRC
let g:loaded_python_provider = 0
let g:python3_host_prog='/usr/bin/python3'
let g:python_host_prog='usr/bin/python2'

" You can't stop me
cmap w!! w !sudo tee %

" change shape of cursor
autocmd VimEnter * silent exec "! echo -ne '\e[1 q'"
autocmd VimLeave * silent exec "! echo -ne '\e[5 q'"
autocmd InsertEnter * silent execute "!echo -en '\e[5 q'"
autocmd InsertLeave * silent execute "!echo -en '\e[1 q'"
autocmd TermEnter * silent execute "!echo -en '\e[5 q'"
autocmd TermLeave * silent execute "!echo -en '\e[1 q'"

