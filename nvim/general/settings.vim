" set leader key
let g:mapleader = "\<Space>"

"----------------------------------------------------------
" Color schema
"----------------------------------------------------------
set t_Co=256                            " Set color sceme work properly
set t_ut=
syntax enable                           " Turn on syntax highlighting
set termguicolors                       " Terminal supports more colors
if version >= 900
  colorscheme habamax
else
  colorscheme evening
endif

"----------------------------------------------------------
" Extentions
"----------------------------------------------------------
filetype plugin on                      " Allow plugin loading of file types

"----------------------------------------------------------
" Fonts and letters
"----------------------------------------------------------
set encoding=utf-8                            " Set the character encoding used internally by nvim
scriptencoding utf-8
set fileencoding=utf-8                        " Set the character encoding of the file where the current buffer is located
set fileencodings=utf-8,ucs-boms,euc-jp,cp932 " Order of file encoding guesses
set fileformats=unix,dos,mac                  " Order of eol type guesses (\r\n, \n)
set ambiwidth=single                          " Patch for multi-byte letters to appear correctly
set tildeop

"----------------------------------------------------------
" Cursor
"----------------------------------------------------------
set whichwrap=b,s,h,l,<,>,[,],~         " Move to the next line with these commands
set cursorline                          " Highlight the current line
set backspace=indent,eol,start
set updatetime=1000                     " Change how long to wait for `CursorHold`

set hidden                              " Allow switching from unsaved buffers
" set number                            " Allow absolute line numbers
set relativenumber                      " Allow relative line numbers
set numberwidth=1                       " Set the width of the number column, default is 4
set mouse=a                             " Enable your mouse
" set showbreak=↪
set iskeyword+=-                      	" treat dash separated words as a word text object
set scrolloff=16                        " Set how many lines are always displayed on the upper and lower sides of the cursor
set nowrap
set sidescrolloff=12                    " Set how many columns are always displayed to the left and right of the cursor

"----------------------------------------------------------
" Memory Usage
"----------------------------------------------------------
set mmp=2000000

"----------------------------------------------------------
" Window
"----------------------------------------------------------
set pumheight=10                        " Set the height of the completion menu
set cmdheight=1                         " More space for displaying messages
set showcmd                             " Show command line
set splitbelow                          " Horizontal splits will automatically be below
set splitright                          " Vertical splits will automatically be to the right
set background=dark                     " Set background mode
set title                               " Allow the window to display the edited filename
set autoread                            " Automatically read files modified in other editors

"----------------------------------------------------------
" Session
"----------------------------------------------------------
set sessionoptions=buffers,curdir,folds,help,tabpages,winsize,globals " Set options for saving sessions

"----------------------------------------------------------
" Search
"----------------------------------------------------------
set incsearch   " Highlight while searching
set ignorecase  " Ignore case when searching
set smartcase   " Intelligent case sensitivity when searching (if there is upper case, turn off case ignoring)
set hlsearch    " Allow search highlighting
set wrapscan    " Allows to search the entire file repeatedly

"----------------------------------------------------------
" Tab, Intent
"----------------------------------------------------------
set expandtab                           " Use spaces instead of tabs
set tabstop=4                           " Width of a tab displayed
set softtabstop=4                       " Delete 4 spaces at once
set autoindent                          " Auto-indent, press o on the current line, the new line is always aligned with the current line
set smartindent                         " Set smart indent
set smarttab                            " Makes tabbing smarter will realize you have 2 vs 4
set shiftwidth=4                        " The width of indentation
set formatoptions-=cro
set colorcolumn=100,120
set signcolumn=yes                      " Set the width of the symbol column, if not set, it will cause an exception when displaying the icon

"----------------------------------------------------------
" Trailing Spaces
"----------------------------------------------------------
set conceallevel=2                      " So that I can see `` in markdown files
set concealcursor=
set foldenable                          " Open fold
set foldmethod=indent                   " Set the folding method
set foldcolumn=0                        " Show collapsed hierarchy in symbol column
set foldlevel=100                       " Maximum folding level

"----------------------------------------------------------
" Backup, Swapfile
"----------------------------------------------------------
set nobackup                            " Whether to create a backup file
set nowritebackup                       " Whether to create backups when writing files
set noswapfile                          " Whether to create a swap file

"----------------------------------------------------------
" Status Line
"----------------------------------------------------------
set shortmess=aoOsWTAIcCFS

"----------------------------------------------------------
" Command mode
"----------------------------------------------------------
set wildmenu                            " Set completion in command mode to appear as a menu
set history=5000                        " Number of command history saved

"----------------------------------------------------------
" Others
"----------------------------------------------------------
let g:loaded_python_provider = 0

" You can't stop me
cmap w!! w !sudo tee %
