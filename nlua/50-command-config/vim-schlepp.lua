-- go left and squish
vim.g["Schlepp#allowSquishingLines"] = 1
vim.g["Schlepp#allowSquishingBlock"] = 1

vim.g["Schlepp#trimWS"] = 0 -- do not trim whitespace

vim.cmd([[
xmap <up>    <Plug>SchleppUp
xmap <down>  <Plug>SchleppDown
xmap <left>  <Plug>SchleppLeft
xmap <right> <Plug>SchleppRight

xmap D <Plug>SchleppDup
xmap Dk <Plug>SchleppDupUp
xmap Dj <Plug>SchleppDupDown
xmap Dh <Plug>SchleppDupLeft
xmap Dl <Plug>SchleppDupRight
]])
