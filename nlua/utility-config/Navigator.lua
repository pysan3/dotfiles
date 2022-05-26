require("Navigator").setup()

-- Keybindings
vim.keymap.set({ "n", "v", "i" }, "<A-h>", "<CMD>NavigatorLeft<CR>")
vim.keymap.set({ "n", "v", "i" }, "<A-l>", "<CMD>NavigatorRight<CR>")
vim.keymap.set({ "n", "v", "i" }, "<A-k>", "<CMD>NavigatorUp<CR>")
vim.keymap.set({ "n", "v", "i" }, "<A-j>", "<CMD>NavigatorDown<CR>")
-- vim.keymap.set({ "n", "v", "i" }, "<A-p>", "<CMD>NavigatorPrevious<CR>")
