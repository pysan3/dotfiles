require("hop").setup({
  { keys = "qwertyuiopasdfghjklzxcvbnm" },
})

vim.keymap.set({ "n", "v" }, "<leader>jw", "<Cmd>HopWord<CR>", { silent = true, desc = "<Cmd>HopWord<CR>" })
vim.keymap.set({ "n", "v" }, "<leader>jl", "<Cmd>HopLine<CR>", { silent = true, desc = "<Cmd>HopLine<CR>" })
vim.keymap.set({ "n", "v" }, "<leader>jf", "<Cmd>HopChar1<CR>", { silent = true, desc = "<Cmd>HopChar1<CR>" })
vim.keymap.set({ "n", "v" }, "s", "<Cmd>HopChar2<CR>", { silent = true, desc = "<Cmd>HopChar2<CR>" })
