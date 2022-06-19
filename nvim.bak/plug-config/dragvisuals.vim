" go left and squish
let g:Schlepp#allowSquishingLines = 1
let g:Schlepp#allowSquishingBlock = 1

let g:Schlepp#trimWS = 0 " do not trim whitespace

xmap <unique> <up>    <Plug>SchleppUp
xmap <unique> <down>  <Plug>SchleppDown
xmap <unique> <left>  <Plug>SchleppLeft
xmap <unique> <right> <Plug>SchleppRight

xmap <unique> D <Plug>SchleppDup
xmap <unique> Dk <Plug>SchleppDupUp
xmap <unique> Dj <Plug>SchleppDupDown
xmap <unique> Dh <Plug>SchleppDupLeft
xmap <unique> Dl <Plug>SchleppDupRight

