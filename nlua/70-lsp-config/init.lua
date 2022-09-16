return {
  setup = {
    {
      "williamboman/mason.nvim",
      requires = {
        "williamboman/mason-lspconfig.nvim",
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        "hrsh7th/cmp-nvim-lsp",
        "neovim/nvim-lspconfig", -- enable LSP
        {
          "jose-elias-alvarez/null-ls.nvim", -- linter
          commit = "76d0573fc159839a9c4e62a0ac4f1046845cdd50",
        },
        { "glepnir/lspsaga.nvim", branch = "main" },
        "andrewferrier/textobj-diagnostic.nvim",
      },
    },
    "ray-x/lsp_signature.nvim", -- show hints when writing function arguments
    "j-hui/fidget.nvim", -- print linting progress
    { "kevinhwang91/nvim-ufo", requires = "kevinhwang91/promise-async" },
  },
}
