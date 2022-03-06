let g:solarized_termcolors=256
syntax on
colorscheme codedark

" Switch to your current theme
let g:airline_theme = 'codedark'

" checks if your terminal has 24-bit color support
if (has("termguicolors"))
    set termguicolors
    highlight LineNr guifg=#2c4350
endif

