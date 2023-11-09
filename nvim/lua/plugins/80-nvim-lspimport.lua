return {
  "stevanmilic/nvim-lspimport",
  keys = {
    {
      vim.g.personal_options.prefix.lsp .. "a",
      function()
        require("lspimport").import()
      end,
      noremap = true,
      silent = true,
    },
  },
}
