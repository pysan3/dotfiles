return {
  setup = {
    {
      "williamboman/nvim-lsp-installer", -- language server installer
      requires = {
        "hrsh7th/cmp-nvim-lsp",
        "neovim/nvim-lspconfig", -- enable LSP
        "jose-elias-alvarez/null-ls.nvim", -- linter
      },
    },
    "ray-x/lsp_signature.nvim", -- show hints when writing function arguments
    "j-hui/fidget.nvim", -- print linting progress
  },
}
