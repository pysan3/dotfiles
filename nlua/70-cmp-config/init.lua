local function c(plugin)
  plugin.event = { "InsertEnter", "CmdlineEnter", "CursorHold", "FocusLost" }
  return plugin
end

return {
  -- "smjonas/snippet-converter.nvim", -- Use to convert snippet files. See `nlua/lsp-config/snippet-converter.lua`
  c({ "windwp/nvim-autopairs", module = { "nvim-autopairs" } }),
  c({
    "numToStr/Comment.nvim",
    module = { "Comment" },
    requires = { { "JoosepAlviste/nvim-ts-context-commentstring", opt = true } },
    wants = { "nvim-treesitter", "nvim-ts-context-commentstring" },
  }),
  c({
    "L3MON4D3/LuaSnip",
    module = { "luasnip" },
    requires = {
      { "rafamadriz/friendly-snippets", opt = true },
      { "honza/vim-snippets", rtp = ".", opt = true },
      { "molleweide/LuaSnip-snippets.nvim", opt = true },
      { "gisphm/vim-gitignore", opt = true },
    },
    wants = { "nvim-treesitter", "friendly-snippets", "vim-snippets", "LuaSnip-snippets.nvim", "vim-gitignore" },
  }),
  {
    "hrsh7th/nvim-cmp",
    module = { "cmp" },
    requires = {
      c({ "hrsh7th/cmp-buffer" }), -- buffer completions
      c({ "hrsh7th/cmp-path" }), -- path completions
      c({ "hrsh7th/cmp-cmdline" }), -- cmdline completions
      c({ "hrsh7th/cmp-nvim-lua" }), -- nvim lua config completion
      c({ "hrsh7th/cmp-calc" }),
      c({ "f3fora/cmp-spell" }),
      c({ "hrsh7th/cmp-cmdline" }),
      c({ "saadparwaiz1/cmp_luasnip" }),
    },
    wants = { "nvim-autopairs", "LuaSnip" },
  },
  c({ "uga-rosa/cmp-dictionary" }),
  c({
    "petertriho/cmp-git",
    config = function()
      require("cmp_git").setup({ filetypes = { "NeogitCommitMessage", "gitcommit", "octo" } })
    end,
  }),
}
