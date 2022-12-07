require("color-picker").setup({
  ["keymap"] = {
    ["U"] = "<Plug>Slider5Decrease",
    ["O"] = "<Plug>Slider5Increase",
  },
})

vim.cmd([[hi FloatBorder guibg=NONE]])
