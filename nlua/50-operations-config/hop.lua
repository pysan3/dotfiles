-- https://github.com/phaazon/hop.nvim/wiki/Configuration
require("hop").setup({
  { keys = "qwertyuiopasdfghjklzxcvbnm" },
  jump_on_sole_occurrence = true,
  multi_windows = true,
})

vim.keymap.set({ "n", "v" }, "<leader>jw", "<Cmd>HopWord<CR>", { silent = true, desc = "<Cmd>HopWord<CR>" })
vim.keymap.set({ "n", "v" }, "<leader>jl", "<Cmd>HopLine<CR>", { silent = true, desc = "<Cmd>HopLine<CR>" })
vim.keymap.set({ "n", "v" }, "s", "<Cmd>HopChar1<CR>", { silent = true, desc = "<Cmd>HopChar1<CR>" })
vim.keymap.set({ "n", "v" }, "S", "<Cmd>HopChar2<CR>", { silent = true, desc = "<Cmd>HopChar2<CR>" })
