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
  {
    "monaqa/dial.nvim",
    keys = {
      { "<C-a>", "<Plug>(dial-increment)", mode = { "n", "v" }, remap = true, desc = "<Plug>(dial-increment)" },
      { "<C-x>", "<Plug>(dial-decrement)", mode = { "n", "v" }, remap = true, desc = "<Plug>(dial-decrement)" },
      { "g<C-a>", "g<Plug>(dial-increment)", mode = "v", remap = true, desc = "g<Plug>(dial-increment)" },
      { "g<C-x>", "g<Plug>(dial-decrement)", mode = "v", remap = true, desc = "g<Plug>(dial-decrement)" },
    },
  },
}
