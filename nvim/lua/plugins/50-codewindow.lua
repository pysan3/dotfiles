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
  config = {
    auto_enable = false,
  },
}
