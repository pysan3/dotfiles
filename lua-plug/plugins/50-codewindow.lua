return {
  "gorbit99/codewindow.nvim",
  keys = {
    { "<Leader>mm", function()
      require("codewindow").toggle_minimap()
    end },
  },
  config = {
    auto_enable = false,
  },
}
