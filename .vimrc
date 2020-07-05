set term=xterm-256color             " 256色で表示する
if exists('&termguicolors')
  set termguicolors
endif
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[38;2;%lu;%lu;%lum"
set encoding=utf-8                  " エンコーディングをUTF-8にする
set fileencodings=utf-8,sjis,cp932  " 設定の順番の文字コードでファイルを開く
set fileformats=unix,dos,mac        " 設定の順番で改行コードを開く
set nofixendofline                  " EOFを元のファイルと同じ状態にする

set ambiwidth=double                " ○文字や□文字でもカーソル位置を保持する
set nobackup                        " バックアップファイルは作成しない
set noswapfile                      " スワップファイルは作成しない
set autoread                        " 編集中のファイルが変更された場合、自動で読み直し
set showcmd                         " 入力コマンドをステータスに表示する

if !has('gui_running')              " CUI使用時
  set mouse=                        " マウス操作をOFFにする
  set ttimeoutlen=0                 " insertからnormalに戻るときの遅延を解消する
  set t_Co=256
endif

set autoindent                      " 改行時に前行のインデントを保持する
set smartindent                     " 改行時に前行末尾に合わせて、インデントを増減する
set tabstop=4                       " タブは設定文字数分で表示する
set shiftwidth=4                    " 自動インデントは4文字
set expandtab                       " タブを空白文字にする
set showmatch                       " 対応する括弧を強調表示する

noremap ^? ^H
noremap! ^? ^H
set backspace=indent,eol,start

set wildmenu                        " TABでファイル名を補完する
set wildmode=full                   " TABを押すごとに次のファイル名を補完する
set ignorecase                      " 検索に大文字小文字を区別しない
set smartcase                       " 検索に大文字を使うと、大文字小文字を区別する
set incsearch                       " リアルタイム検索する
set wrapscan                        " 最後まで検索すると、最初に戻る
set hlsearch                        " 検索結果をハイライト表示する
hi Search ctermbg=cyan              " ハイライトの背景をシアン
hi Search ctermfg=white             " ハイライト文字を白

set scrolloff=3                     " 3行前から画面をスクロールする
set nowrap                          " テキストの折返しをしない
set ruler                           " ルーラーを表示する
set number                          " 行番号を表示する
set relativenumber                  " 行番号を相対表示する
" カラムラインを120列目に引く
if (exists('+colorcolumn'))
    let &colorcolumn=join(range(121,999),",")
    hi ColorColumn ctermbg=235 guibg=#2c2d27
endif

" undoを保存する
if has('persistent_undo')
    set undodir=~/.vim/undo
    set undofile
endif

let mapleader = "\<Space>"            " <leader>を<Space>にする
" grepした結果をquickfixに表示する
augroup grepwindow
    autocmd!
    au QuickFixCmdPost *grep* cwindow
augroup END

syntax enable                       " シンタックスをONにする

set laststatus=2                    " ステータスラインを常に表示する
set cmdheight=1                     " ステータスライン下のメッセージ表示行数

if filereadable($HOME.'/.vim/autoload/plug.vim')
  " curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  call plug#begin()
    "Plug 'SirVer/ultisnips'                     " スニペット
    " goのスニペット -> https://github.com/fatih/vim-go/blob/master/gosnippets/UltiSnips/go.snippets
    Plug 'bronson/vim-trailing-whitespace'      " 行末のスペースをハイライト
    Plug 'Yggdroot/indentLine'                  " インデントを見やすくする
    Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }   " あいまい検索
    Plug 'junegunn/fzf.vim'
    Plug 'cohama/lexima.vim'                    " 括弧の補完
    Plug 'itchyny/lightline.vim'                " ステータスライン拡張
    Plug 'othree/yajs.vim', { 'for': ['javascript', 'javascript.jsx'] }
    Plug 'pangloss/vim-javascript', { 'for': ['javascript', 'javascript.jsx'] }
    Plug 'othree/es.next.syntax.vim', { 'for': ['javascript', 'javascript.jsx'] }
    Plug 'othree/javascript-libraries-syntax.vim', { 'for': ['javascript', 'javascript.jsx'] }
    Plug 'othree/html5.vim'
    Plug 'maxmellon/vim-jsx-pretty', { 'for': ['javascript', 'javascript.jsx'] }
    " jsbeautifyの設定 -> https://github.com/maksimr/vim-jsbeautify#examples
    Plug 'maksimr/vim-jsbeautify'
    Plug 'nvie/vim-flake8'                      " Python Flake8
    Plug 'tpope/vim-markdown'                   " markdown編集
    Plug 'previm/previm'                        " markdown preview
    Plug 'alvan/vim-closetag'                   " html, xml tag auto closed
    Plug 'simeji/winresizer'                    " resize window
    Plug 'prabirshrestha/async.vim'
    Plug 'prabirshrestha/asyncomplete.vim'
    Plug 'prabirshrestha/asyncomplete-lsp.vim'
    Plug 'prabirshrestha/vim-lsp'
    Plug 'mattn/vim-lsp-settings'
    Plug 'mattn/vim-lsp-icons'
    Plug 'mattn/vim-goimports'
    "Plug 'hrsh7th/vim-vsnip'
    "Plug 'hrsh7th/vim-vsnip-integ'
    Plug 'xavierchow/vim-swagger-preview'       " swagger preview in browser
  call plug#end()
endif

" 設定読み込み
call map(sort(split(globpath(&runtimepath, '_config/*.vim'))), {->[execute('exec "so" v:val')]})
