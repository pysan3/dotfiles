vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undofile = true
vim.opt.undodir = vim.fn.stdpath("data") .. "/undodir"
for _, value in ipairs(vim.opt.undodir:get()) do
  vim.fn.mkdir(value, "p")
end

vim.cmd([[ nnoremap <Leader>u :UndotreeShow<CR> ]])
