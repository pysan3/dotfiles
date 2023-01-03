return {
  "declancm/maximize.nvim",
  keys = {
    { "<Leader>mz", function()
      require("maximize").toggle()
    end, silent = true, noremap = true },
  },
  config = {
    default_keymaps = false,
  },
}
