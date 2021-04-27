" auto-install vim-plug
if empty(glob('~/.config/nvim/autoload/plug.vim'))
    silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall
    " autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

call plug#begin('~/.config/nvim/autoload/plugged')

    " Better Syntax Support
    Plug 'sheerun/vim-polyglot'
    " show how many occurance found
    Plug 'google/vim-searchindex'
    " Use * in visual mode
    Plug 'inkarkat/vim-ingo-library'
    Plug 'inkarkat/vim-SearchHighlighting'
    " Undo Tree
    Plug 'mbbill/undotree'
    " Auto pairs for '(' '[' '{'
    Plug 'jiangmiao/auto-pairs'
    " calculate sum, average, max, min in selected area
    Plug 'nixon/vim-vmath'
    " drag things selected visually
    Plug 'joshukraine/dragvisuals'
    " Comments
    Plug 'tpope/vim-commentary'
    Plug 'jbgutierrez/vim-better-comments'
    " Custom operations
    Plug 'christoomey/vim-titlecase'
    Plug 'christoomey/vim-sort-motion'
    Plug 'tpope/vim-surround'
    Plug 'terryma/vim-expand-region'
    Plug 'vim-scripts/ReplaceWithRegister'
    " Custom Text Objects
    Plug 'michaeljsmith/vim-indent-object'
    " quick search in Google and put link in selected letter
    Plug 'mattn/webapi-vim'
    Plug 'christoomey/vim-quicklink'
    " 末尾の全角半角空白文字を赤くハイライト
    Plug 'bronson/vim-trailing-whitespace'
    " インデントの可視化
    Plug 'Yggdroot/indentLine'
    " better scroll
    " Plug 'yuttie/comfortable-motion.vim'
    " Stable version of coc
    Plug 'neoclide/coc.nvim', {'branch': 'release'}
    " Keeping up to date with master
    Plug 'neoclide/coc.nvim', {'do': 'yarn install --frozen-lockfile'}
    " color theme
    Plug 'joshdick/onedark.vim'
    Plug 'ulwlu/elly.vim'
    Plug 'tomasiser/vim-code-dark'
    Plug 'arcticicestudio/nord-vim'
    " Airline
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'
    " Fzf
    Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
    Plug 'junegunn/fzf.vim'
    " Startify
    Plug 'mhinz/vim-startify'
    " git stuff
    Plug 'mhinz/vim-signify'
    Plug 'tpope/vim-fugitive'
    Plug 'tpope/vim-rhubarb'
    Plug 'stsewd/fzf-checkout.vim'
    Plug 'airblade/vim-rooter'
    Plug 'junegunn/gv.vim'
    " vim-which-key
    " Plug 'liuchengxu/vim-which-key'
    " vim sneak
    Plug 'justinmk/vim-sneak'
    " Snippets
    Plug 'honza/vim-snippets'
    " Floaterm
    Plug 'voldikss/vim-floaterm'

    " language specific
    Plug 'pixelneo/vim-python-docstring'
    Plug 'uarun/vim-protobuf'
call plug#end()
