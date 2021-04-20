" Better nav for omnicomplete
inoremap <expr> <c-j> ("\<C-n>")
inoremap <expr> <c-k> ("\<C-p>")

" I hate escape more than anything else
inoremap <silent> jk <Esc>
tmap <silent> jk <Esc>

" save undos on every space
inoremap <space> <space><C-g>u
inoremap <CR> <CR><C-g>u

" new line in insert mode
imap <C-o> <Esc>o

" Easy CAPS
inoremap <c-u> <ESC>viwUi
nnoremap <c-u> viwU<Esc>

" move to next / previous buffer
nnoremap <F2> :bprevious<CR>
nnoremap <F3> :bnext<CR>

" Alternate way to save
nnoremap <C-s> :w<CR>
" Alternate way to quit
nnoremap <C-Q> :wq<CR>
inoremap <C-Q> <Esc>:wq<CR>
nnoremap <silent> <Leader>w :w<CR>
nnoremap <silent> <Leader>q :bd!<CR>
" Use control-c instead of escape
nnoremap <C-c> <Esc>
inoremap <C-c> <Esc>

" Better tabbing
vnoremap < <gv
vnoremap > >gv

" Searching
nnoremap <ESC><ESC> :nohlsearch<CR>
"検索語が画面の真ん中に来るようにする
nnoremap n nzz
nnoremap N Nzz
nnoremap * *Nzz
nnoremap # #nzz
nnoremap g* g*zz

" Better window navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
" 入力モードでのカーソル移動
inoremap <C-j> <Down>
inoremap <C-k> <Up>
inoremap <C-h> <Left>
inoremap <C-l> <Right>

" 行が折り返し表示されていた場合、行単位ではなく表示行単位でカーソルを移動する
nnoremap j gj
nnoremap k gk
nnoremap <down> gj
nnoremap <up> gk

" 選択モードで上下に移動
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

" 対応括弧
nnoremap { {zz
nnoremap } }zz
nnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz

" add line within normal mode
nnoremap <Leader>o o<Esc>
nnoremap <Leader>O O<Esc>

" vim-expand-region用スニペット
vmap v <Plug>(expand_region_expand)
vmap <C-v> <Plug>(expand_region_shrink)

" クリップボードからのペースト
vnoremap <silent> y y`]
vnoremap <silent> p p`]
nnoremap <silent> P P`]
noremap gV `[v`]
noremap <Leader>y "+y
noremap <Leader>p "+p
noremap <Leader>P "+P

" ノーマルモードのときにxキー、sキーで削除した文字をヤンクしない
nnoremap x "_x
nnoremap s "_s

" Trailing Spaces
:command T FixWhitespace

" Python Docs
nnoremap <Leader>ss :Docstring<CR>
