require("Navigator").setup()

-- Keybindings
local all_modes = { "n", "v", "o", "i", "c", "t" }
vim.keymap.set(all_modes, "<A-h>", "<CMD>NavigatorLeft<CR>")
vim.keymap.set(all_modes, "<A-l>", "<CMD>NavigatorRight<CR>")
vim.keymap.set(all_modes, "<A-k>", "<CMD>NavigatorUp<CR>")
vim.keymap.set(all_modes, "<A-j>", "<CMD>NavigatorDown<CR>")
vim.keymap.set(all_modes, "<A-p>", "<CMD>NavigatorPrevious<CR>")
