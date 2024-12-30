return {
  "nvimdev/indentmini.nvim", -- show indent line with |
  event = "VeryLazy",
  config = function()
    require("indentmini").setup({
      char = "▏",
      exclude = { "noice", "neo-tree", "norg" },
    })
    vim.cmd.highlight("IndentLine guifg=gray30")
    vim.cmd.highlight("IndentLineCurrent guifg=gray70")
  end,
}
