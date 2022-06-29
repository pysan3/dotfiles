local opts = { noremap = true, silent = true }
local map = "<leader><leader>c"
vim.keymap.set("n", map, "<cmd>PickColor<cr>", opts)
vim.keymap.set("i", map, "<cmd>PickColorInsert<cr>", opts)

require("color-picker").setup({
  ["keymap"] = {
    ["U"] = "<Plug>Slider5Decrease",
    ["O"] = "<Plug>Slider5Increase",
  },
})

vim.cmd([[hi FloatBorder guibg=NONE]])
