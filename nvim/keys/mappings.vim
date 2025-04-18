" I hate escape more than anything else
inoremap <silent> jk <Esc>
tnoremap <silent> jk <Esc>
cnoremap <silent> jk <Esc>
inoremap <silent> ｊｋ <Esc>
tnoremap <silent> ｊｋ <Esc>
cnoremap <silent> ｊｋ <Esc>

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

" move to next / previous punctuation
nnoremap <silent> H F.h
nnoremap <silent> L f.l

" Toggle wrap
nnoremap <silent> <Leader>ml :set wrap!<CR>

" Save Quit Load
nnoremap <silent> <Leader>E :e!<CR>
noremap  <silent> <C-Q> :wq!<CR>
inoremap <silent> <C-Q> <Esc>:wq!<CR>
nnoremap <silent> <Leader>w :silent w<CR>
nnoremap <silent> <Leader>W :silent noa w<CR>
nnoremap <silent> <Leader>q :silent bd!<CR>
nnoremap <silent> <Leader>Q :silent b # <bar> :silent bd! #<CR>
command! Q :q
command! WQ :wq
command! Wq :wq
command! CL :wqa!

" Better tabbing
xnoremap < <gv
xnoremap > >gv

" Search results always on center
nnoremap n nzz
nnoremap N Nzz
nnoremap * *Nzz
nnoremap # #nzz
nnoremap g* g*zz
nnoremap <expr> <Leader>. '<esc>' . repeat('.', v:count1)

" Move while in insert mode
inoremap <C-j> <Down>
inoremap <C-k> <Up>
inoremap <C-a> <Left>
inoremap <C-l> <Right>

" Move while in command mode
cnoremap <C-h> <S-Left>
cnoremap <C-l> <S-Right>
cnoremap <C-a> <C-b>

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
inoremap <M-CR> <C-o>o

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
nnoremap <silent> <Leader>, gT
nnoremap <silent> <Leader>; gt

" Easy access to some commands
nnoremap <Leader>:a :!zsh -ic '

" Do not update the register
noremap x "_x
noremap <Leader>c "_c

" noa everything
nnoremap <silent> .     <Cmd>execute "noautocmd norm! " . v:count1 . "."<CR>
nnoremap <silent> u     <Cmd>execute "noautocmd norm! " . v:count1 . "u"<CR>
nnoremap <silent> U     u
nnoremap <silent> <C-r> <Cmd>execute "noautocmd norm! " . v:count1 . "<C-r>"<CR>

" Repeat chars to make a heading
iabbrev <expr> 4= repeat('=', 4)
iabbrev <expr> 5= repeat('=', 5)
iabbrev <expr> 6= repeat('=', 6)
iabbrev <expr> 8= repeat('=', 8)
