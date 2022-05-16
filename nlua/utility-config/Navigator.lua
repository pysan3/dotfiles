require("Navigator").setup()

-- Keybindings
vim.keymap.set("n", "<A-h>", "<CMD>NavigatorLeft<CR>")
vim.keymap.set("n", "<A-l>", "<CMD>NavigatorRight<CR>")
vim.keymap.set("n", "<A-k>", "<CMD>NavigatorUp<CR>")
vim.keymap.set("n", "<A-j>", "<CMD>NavigatorDown<CR>")
-- vim.keymap.set("n", "<A-p>", "<CMD>NavigatorPrevious<CR>")
