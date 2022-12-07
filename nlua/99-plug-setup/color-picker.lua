local function getopts(desc)
  return { noremap = true, silent = true, desc = desc }
end
vim.keymap.set("n", "<Leader><Leader>c", "<Cmd>PickColor<CR>", getopts("<Cmd>PickColor<CR>"))
