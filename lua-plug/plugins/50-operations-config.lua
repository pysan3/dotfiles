local function be(plugin)
  plugin.event = { "BufRead", "BufNewFile", "BufEnter" }
  return plugin
end

return {
  {
    "ggandor/leap.nvim", -- s, S to jump anywhere
    event = "VeryLazy",
    config = function()
      require("leap").add_default_mappings()
    end,
  },
  {
    "tpope/vim-repeat", -- better repetition
    lazy = false,
  },
  be({ "christoomey/vim-titlecase", keys = { "gzz" } }), -- gzz
  be({ "christoomey/vim-sort-motion" }), -- gs<motion> eg. gs2j => sort 3 lines
  be({ "michaeljsmith/vim-indent-object" }), -- ai, ii, aI, iI: object of same indent
  be({ "wellle/targets.vim" }), -- 2i, 2a for more inner and outer selection
}
