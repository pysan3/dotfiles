local function getopts(desc)
  return { noremap = true, silent = true, desc = desc }
end
local map = "\\\\c"
vim.keymap.set("n", map, "<cmd>PickColor<cr>", getopts("<cmd>PickColor<cr>"))
vim.keymap.set("i", map, "<cmd>PickColorInsert<cr>", getopts("<cmd>PickColorInsert<cr>"))

require("color-picker").setup({
  ["keymap"] = {
    ["U"] = "<Plug>Slider5Decrease",
    ["O"] = "<Plug>Slider5Increase",
  },
})

vim.cmd([[hi FloatBorder guibg=NONE]])
