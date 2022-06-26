return {
  setup = {
    {
      "neovim/nvim-lspconfig", -- enable LSP
      requires = {
        "hrsh7th/cmp-nvim-lsp",
        "williamboman/nvim-lsp-installer", -- language server installer
        "jose-elias-alvarez/null-ls.nvim", -- linter
      },
    },
    "ray-x/lsp_signature.nvim", -- show hints when writing function arguments
    "j-hui/fidget.nvim", -- print linting progress
  },
}
