return {
  "jbyuki/nabla.nvim",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
  },
  keys = {
    {
      vim.g.personal_options.prefix.lsp .. "n",
      function()
        require("nabla").popup()
      end,
      desc = "Nabla: popup",
    },
  },
}
