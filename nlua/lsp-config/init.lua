return {
  setup = {
    {
      "numToStr/Comment.nvim",
      requires = "JoosepAlviste/nvim-ts-context-commentstring",
      after = "nvim-treesitter",
    },
    "windwp/nvim-autopairs",
    {
      "hrsh7th/nvim-cmp",
      after = "nvim-autopairs",
      requires = {
        "hrsh7th/cmp-buffer", -- buffer completions
        "hrsh7th/cmp-path", -- path completions
        "hrsh7th/cmp-cmdline", -- cmdline completions
        "hrsh7th/cmp-nvim-lua", -- nvim lua config completion
        "hrsh7th/cmp-calc",
        "hrsh7th/cmp-emoji",
        "f3fora/cmp-spell",
        "uga-rosa/cmp-dictionary",
        -- snippets
        {
          "SirVer/ultisnips",
          requires = { { "honza/vim-snippets", rtp = "." }, "quangnguyen30192/cmp-nvim-ultisnips" },
          config = function()
            vim.g.UltiSnipsExpandTrigger = "<Plug>(ultisnips_expand)"
            vim.g.UltiSnipsJumpForwardTrigger = "<Plug>(ultisnips_jump_forward)"
            vim.g.UltiSnipsJumpBackwardTrigger = "<Plug>(ultisnips_jump_backward)"
            vim.g.UltiSnipsListSnippets = "<c-x><c-s>"
            vim.g.UltiSnipsRemoveSelectModeMappings = 0
          end,
        },
      },
    },
    {
      "neovim/nvim-lspconfig", -- enable LSP
      after = "nvim-cmp",
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
