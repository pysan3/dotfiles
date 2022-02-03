vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undofile = true
vim.opt.undodir = (os.getenv("XDG_CONFIG_HOME") or "~/.config") .. "/nvim/undodir"

vim.cmd [[ nnoremap <Leader>u :UndotreeShow<CR> ]]

