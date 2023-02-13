return {
  "declancm/maximize.nvim",
  keys = {
    {
      "<Leader>mz",
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
