return {
  "gorbit99/codewindow.nvim",
  keys = {
    {
      "<Leader>mm",
      function()
        require("codewindow").toggle_minimap()
      end,
      desc = "CodeWindow toggle_minimap()",
    },
  },
  opts = {
    auto_enable = false,
    exclude_filetypes = { "neo-tree", "terminal", "toggleterm", "qf", "lazy", "mason", "diff", "unite", "fugitive" },
  },
}
