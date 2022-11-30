-- https://github.com/phaazon/hop.nvim/wiki/Configuration
local hop = require("hop")
hop.setup({
  { keys = "qwertyuiopasdfghjklzxcvbnm" },
  jump_on_sole_occurrence = true,
  multi_windows = true,
  uppercase_labels = true,
})

vim.keymap.set({ "n", "x" }, "<leader>jw", hop.hint_words, { silent = true, desc = "<Cmd>HopWord<CR>" })
vim.keymap.set({ "n", "x" }, "<leader>jl", hop.hint_lines, { silent = true, desc = "<Cmd>HopLine<CR>" })
vim.keymap.set({ "n", "x" }, "S", hop.hint_char1, { silent = true, desc = "<Cmd>HopChar1<CR>" })
vim.keymap.set({ "n", "x" }, "s", hop.hint_char2, { silent = true, desc = "<Cmd>HopChar2<CR>" })
