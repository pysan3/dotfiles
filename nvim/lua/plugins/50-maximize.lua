return {
  "declancm/maximize.nvim",
  keys = {
    {
      "<C-w>z",
      function()
        require("maximize").toggle()
      end,
      silent = true,
      noremap = true,
      desc = "Maximize: toggle",
    },
  },
  opts = {
    default_keymaps = false,
  },
}
