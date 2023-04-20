return {
  "danymat/neogen", -- create docstring for several languages
  cmd = { "Neogen" },
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "L3MON4D3/LuaSnip",
  },
  opts = {
    snippet_engine = "luasnip",
  },
}
