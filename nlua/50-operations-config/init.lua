local function be(plugin)
  plugin.event = { "BufRead", "BufNewFile", "BufEnter" }
  return plugin
end

return {
  {
    "terryma/vim-expand-region", -- + to expand, _ to shrink
    keys = { "<Plug>(expand_region_expand)", "<Plug>(expand_region_shrink)" },
  },
  be({ "kylechui/nvim-surround" }), -- s is motion, ys to add
  be({ "ggandor/leap.nvim" }), -- s, S to jump anywhere
  be({ "tpope/vim-repeat" }), -- better repetition
  be({ "christoomey/vim-titlecase", keys = { "gzz" } }), -- gzz
  be({ "christoomey/vim-sort-motion" }), -- gs<motion> eg. gs2j => sort 3 lines
  be({ "michaeljsmith/vim-indent-object" }), -- ai, ii, aI, iI: object of same indent (i; above, a; above and below)
  be({ "wellle/targets.vim" }), -- 2i, 2a for more inner and outer selection
}
