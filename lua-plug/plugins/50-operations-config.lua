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
  { "tpope/vim-repeat", lazy = false }, -- better repetition
  be({ "christoomey/vim-titlecase", keys = { "gzz" } }), -- gzz
  be({ "christoomey/vim-sort-motion" }), -- gs<motion> eg. gs2j => sort 3 lines
}
