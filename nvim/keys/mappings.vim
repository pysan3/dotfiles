" I hate escape more than anything else
inoremap <silent> jk <Esc>
tnoremap <silent> jk <Esc>
inoremap <silent> ｊｋ <Esc>
tnoremap <silent> ｊｋ <Esc>

" jump to the last edited file
nnoremap <C-6> <C-^>

" save undos on every space
inoremap <space> <C-]><C-g>u<space>
inoremap <CR> <C-]><C-g>u<CR>
inoremap . <C-g>u.
inoremap , <C-g>u,

" new line in insert mode
imap <C-o> <Esc>A<CR>
inoremap <C-e> <Esc>A,<Esc>o

" shift in insert mode
inoremap <C-f> <Esc><<a

" move to start / end of line
noremap <C-h> 0w
noremap <C-l> $

" move to next / previous buffer
nnoremap H :bprevious<CR>
nnoremap L :bnext<CR>

" save and quit
noremap <C-Q> :wq!<CR>
inoremap <C-Q> <Esc>:wq!<CR>
nnoremap <silent> <Leader>w :silent w<CR>
nnoremap <silent> <Leader>q :silent bd!<CR>
command! Q :q
command! WQ :wq
command! Wq :wq

" Better tabbing
xnoremap < <gv
xnoremap > >gv

" Move to center of the screen on jump
nnoremap <C-o> <C-o>zz
nnoremap <C-i> <C-i>zz

" Searching
nnoremap <ESC><ESC> :silent nohlsearch<CR>
" 検索語が画面の真ん中に来るようにする
nnoremap n nzz
nnoremap N Nzz
nnoremap * *Nzz
nnoremap # #nzz
nnoremap g* g*zz
" // で選択中のテキストを検索
xnoremap // y/\V<C-R>=escape(@",'/\')<CR><CR>

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
xnoremap j gj
xnoremap k gk
xnoremap <down> gj
xnoremap <up> gk

" 選択モードで上下に移動
xnoremap J :m '>+1<CR>gv=gv
xnoremap K :m '<-2<CR>gv=gv

" Toggle spell check
nnoremap <F6> :set spell! spelllang=en_us,cjk<CR>
nnoremap zg zg]s
nnoremap zl 1z=]s

" 対応括弧
nnoremap { {zz
nnoremap } }zz
nnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz

" add line within normal mode
nnoremap <Leader>o o<Esc>
nnoremap <Leader>O O<Esc>

" クリップボードからのペースト
xnoremap <silent> y y`]
xnoremap <silent> p p`]
nnoremap <silent> P P`]
noremap gV `[v`]
noremap <Leader>y "+y
noremap <Leader>p "+p
noremap <Leader>P "+P

" ノーマルモードのときにxキー、sキーで削除した文字をヤンクしない
nnoremap x "_x
" nnoremap s "_s
