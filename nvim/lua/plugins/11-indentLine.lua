return {
  "Yggdroot/indentLine", -- show indent line with |
  event = "VeryLazy",
  init = function()
    vim.g.indentLine_char = "▏"
    vim.g.indentLine_bufTypeExclude = { "help", "terminal", "neo-tree" }
  end,
}
