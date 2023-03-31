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

" move to start / end of line
noremap <C-h> ^
noremap <C-l> $

" command mode shortcuts and bindings
cnoremap <C-w> <S-Right>
cnoremap <C-b> <S-Left>
cnoremap <C-l> <Right>
cnoremap <C-h> <Left>
cnoremap <C-j> <Down>
cnoremap <C-k> <Up>
cnoremap <C-a> <C-e>
cnoremap <C-x> <Del>
cnoremap <C-d> <C-u>
cnoremap <C-p> <C-r>*

" move to next / previous buffer
nnoremap H :bprevious<CR>
nnoremap L :bnext<CR>

" Toggle wrap
nnoremap <silent> <Leader>ml :set wrap!<CR>

" save and quit
noremap <C-Q> :wq!<CR>
inoremap <C-Q> <Esc>:wq!<CR>
nnoremap <silent> <Leader>w :silent w<CR>
nnoremap <silent> <Leader>W :silent noa w<CR>
nnoremap <silent> <Leader>q :silent bd!<CR>
command! Q :q
command! WQ :wq
command! Wq :wq

" Better tabbing
xnoremap < <gv
xnoremap > >gv

" Search results always on center
nnoremap n nzz
nnoremap N Nzz
nnoremap * *Nzz
nnoremap # #nzz
nnoremap g* g*zz

" Move while in insert mode
inoremap <C-j> <Down>
inoremap <C-k> <Up>
inoremap <C-a> <Left>
inoremap <C-l> <Right>

" Move up and down with wrap
nnoremap j gj
nnoremap k gk
nnoremap <down> gj
nnoremap <up> gk
xnoremap j gj
xnoremap k gk
xnoremap <down> gj
xnoremap <up> gk

" Move the selected area
xnoremap J :m '>+1<CR>gv=gv
xnoremap K :m '<-2<CR>gv=gv

" Toggle spell check
nnoremap <F6> :set spell! spelllang=en_us,cjk<CR>
nnoremap zg zg]s
nnoremap zl 1z=]s

" add line within normal mode
nnoremap go o<Esc>
nnoremap gO O<Esc>

" Easy interaction with the clipboard
xnoremap <silent> y y`]
xnoremap <silent> Y Y`]
xnoremap <silent> p p`]
nnoremap <silent> P P`]
noremap gV `[v`]
noremap gy "+y
noremap gY "+Y
noremap gp "+p
noremap gP "+P

" tmux like movement of windows / tabs
nnoremap <silent> <Leader><C-b> :vs<CR>
nnoremap <silent> <Leader><C-v> :sp<CR>
nnoremap <silent> <Leader><C-t> :tabe<CR>
nnoremap <silent> <Leader>tq :tabclose<CR>
nnoremap <silent> <Leader><C-x> <C-w>o
nnoremap <silent> <Leader>; gt
nnoremap <silent> <Leader>, gT

" Do not update the register
noremap x "_x
noremap <Leader>d "_d
noremap <Leader>c "_c
