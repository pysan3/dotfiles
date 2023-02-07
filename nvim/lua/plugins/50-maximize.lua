return {
  "declancm/maximize.nvim",
  keys = {
    { "<Leader>mz", function()
      require("maximize").toggle()
    end, silent = true, noremap = true, desc = "Maximize: toggle" },
  },
  config = {
    default_keymaps = false,
  },
}
