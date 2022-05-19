return {
  setup = {
    "windwp/nvim-autopairs",
    {
      "numToStr/Comment.nvim",
      requires = "JoosepAlviste/nvim-ts-context-commentstring",
    },
    { "SirVer/ultisnips", requires = { { "honza/vim-snippets", rtp = "." } } },
    {
      "hrsh7th/nvim-cmp",
      requires = {
        "hrsh7th/cmp-buffer", -- buffer completions
        "hrsh7th/cmp-path", -- path completions
        "hrsh7th/cmp-cmdline", -- cmdline completions
        "hrsh7th/cmp-nvim-lua", -- nvim lua config completion
        "hrsh7th/cmp-calc",
        "hrsh7th/cmp-emoji",
        "f3fora/cmp-spell",
        "uga-rosa/cmp-dictionary",
        "quangnguyen30192/cmp-nvim-ultisnips",
      },
    },
    {
      "neovim/nvim-lspconfig", -- enable LSP
      requires = {
        "hrsh7th/cmp-nvim-lsp",
        "williamboman/nvim-lsp-installer", -- language server installer
        "ray-x/lsp_signature.nvim", -- show hints when writing function arguments
        "jose-elias-alvarez/null-ls.nvim", -- linter
        "j-hui/fidget.nvim", -- print linting progress
      },
    },
  },
}
