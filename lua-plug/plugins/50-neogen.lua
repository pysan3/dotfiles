return {
  "danymat/neogen", -- create docstring for several languages
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "L3MON4D3/LuaSnip",
  },
  config = {
    snippet_engine = "luasnip",
  },
}
