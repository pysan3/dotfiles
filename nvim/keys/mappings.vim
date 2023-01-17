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

" Search results always on center
nnoremap n nzz
nnoremap N Nzz
nnoremap * *Nzz
nnoremap # #nzz
nnoremap g* g*zz

" Move while in insert mode
inoremap <C-j> <Down>
inoremap <C-k> <Up>
inoremap <C-h> <Left>
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
nnoremap <Leader>o o<Esc>
nnoremap <Leader>O O<Esc>

" Easy interaction with the clipboard
xnoremap <silent> y y`]
xnoremap <silent> p p`]
nnoremap <silent> P P`]
noremap gV `[v`]
noremap <Leader>y "+y
noremap <Leader>p "+p
noremap <Leader>P "+P

" Do not update the register
noremap x "_x
noremap <Leader>d "_d
noremap <Leader>c "_c
