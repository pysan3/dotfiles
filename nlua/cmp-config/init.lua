return {
  setup = {
    -- "smjonas/snippet-converter.nvim", -- Use to convert snippet files. See `nlua/lsp-config/snippet-converter.lua`
    "windwp/nvim-autopairs",
    {
      "numToStr/Comment.nvim",
      requires = "JoosepAlviste/nvim-ts-context-commentstring",
    },
    -- { "SirVer/ultisnips", requires = { { "honza/vim-snippets", rtp = "." } } },
    {
      "L3MON4D3/LuaSnip",
      requires = {
        "rafamadriz/friendly-snippets",
        { "honza/vim-snippets", rtp = "." },
        "molleweide/LuaSnip-snippets.nvim",
        "gisphm/vim-gitignore",
      },
    },
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
        "saadparwaiz1/cmp_luasnip",
        -- "quangnguyen30192/cmp-nvim-ultisnips",
      },
    },
  },
}
