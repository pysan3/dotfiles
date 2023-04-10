return {
  "Yggdroot/indentLine", -- show indent line with |
  event = "VeryLazy",
  init = function()
    vim.g.indentLine_char = "▏"
    vim.g.indentLine_concealcursor = ""
    vim.g.indentLine_bufTypeExclude = { "help", "terminal", "neo-tree" }
    vim.g.indentLine_fileTypeExclude = { "noice" }
  end,
}
