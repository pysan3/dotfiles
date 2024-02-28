return {
  "danymat/neogen", -- create docstring for several languages
  cmd = { "Neogen" },
  dependencies = {
    "nvim-treesitter",
    "LuaSnip",
  },
  opts = {
    snippet_engine = "luasnip",
  },
}
