return {
  -- "smjonas/snippet-converter.nvim", -- Use to convert snippet files. See `nlua/lsp-config/snippet-converter.lua`
  {
    "windwp/nvim-autopairs",
    module = "nvim-autopairs",
    event = { "InsertEnter" },
  },
  {
    "numToStr/Comment.nvim",
    module = "Comment",
    event = { "BufReadPre", "FocusLost", "CursorHold" },
    requires = { { "JoosepAlviste/nvim-ts-context-commentstring", opt = true } },
    wants = { "nvim-ts-context-commentstring" },
  },
  {
    "L3MON4D3/LuaSnip",
    module = "luasnip",
    event = { "InsertEnter" },
    requires = {
      { "rafamadriz/friendly-snippets", opt = true },
      { "honza/vim-snippets", rtp = ".", opt = true },
      { "molleweide/LuaSnip-snippets.nvim", opt = true },
      { "gisphm/vim-gitignore", opt = true },
    },
    wants = { "friendly-snippets", "vim-snippets", "LuaSnip-snippets.nvim", "vim-gitignore" },
  },
  {
    "hrsh7th/nvim-cmp",
    module = "cmp",
    requires = {
      { "hrsh7th/cmp-buffer", event = { "InsertEnter" } }, -- buffer completions
      { "hrsh7th/cmp-path", event = { "InsertEnter" } }, -- path completions
      { "hrsh7th/cmp-cmdline", event = { "InsertEnter" } }, -- cmdline completions
      { "hrsh7th/cmp-nvim-lua", event = { "InsertEnter" } }, -- nvim lua config completion
      { "hrsh7th/cmp-calc", event = { "InsertEnter" } },
      { "f3fora/cmp-spell", event = { "InsertEnter" } },
      { "hrsh7th/cmp-cmdline", event = { "InsertEnter" } },
      { "saadparwaiz1/cmp_luasnip", event = { "InsertEnter" } },
    },
    wants = { "nvim-autopairs", "LuaSnip" },
  },
  {
    "uga-rosa/cmp-dictionary",
    event = { "InsertEnter" }
  },
  {
    "petertriho/cmp-git",
    event = { "InsertEnter" },
    config = function()
      require("cmp_git").setup({ filetypes = { "NeogitCommitMessage", "gitcommit", "octo" } })
    end,
  },
}
