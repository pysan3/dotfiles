local function getopts(desc)
  return { noremap = true, silent = true, desc = desc }
end
vim.keymap.set("n", "<leader><leader>c", "<cmd>PickColor<cr>", getopts("<cmd>PickColor<cr>"))

require("color-picker").setup({
  ["keymap"] = {
    ["U"] = "<Plug>Slider5Decrease",
    ["O"] = "<Plug>Slider5Increase",
  },
})

vim.cmd([[hi FloatBorder guibg=NONE]])
