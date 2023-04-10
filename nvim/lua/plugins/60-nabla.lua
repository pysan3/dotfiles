return {
  "jbyuki/nabla.nvim",
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
