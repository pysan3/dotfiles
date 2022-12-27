local iron_prefix = "<Leader>r"

vim.keymap.set("n", iron_prefix .. "s", "<Cmd>IronRepl<CR>")
vim.keymap.set("n", iron_prefix .. "r", "<Cmd>IronRestart<CR>")
vim.keymap.set("n", iron_prefix .. "f", "<Cmd>IronFocus<CR>")
vim.keymap.set("n", iron_prefix .. "h", "<Cmd>IronHide<CR>")
