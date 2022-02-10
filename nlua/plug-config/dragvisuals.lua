-- go left and squish
vim.g["Schlepp#allowSquishingLines"] = 1
vim.g["Schlepp#allowSquishingBlock"] = 1

vim.g["Schlepp#trimWS"] = 0 -- do not trim whitespace

vim.cmd([[
vmap <unique> <up>    <Plug>SchleppUp
vmap <unique> <down>  <Plug>SchleppDown
vmap <unique> <left>  <Plug>SchleppLeft
vmap <unique> <right> <Plug>SchleppRight

vmap <unique> D <Plug>SchleppDup
vmap <unique> Dk <Plug>SchleppDupUp
vmap <unique> Dj <Plug>SchleppDupDown
vmap <unique> Dh <Plug>SchleppDupLeft
vmap <unique> Dl <Plug>SchleppDupRight
]])
