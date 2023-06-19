local function be(plugin)
  plugin.event = { "BufRead", "BufNewFile", "BufEnter" }
  return plugin
end

return {
  { "tpope/vim-repeat", lazy = false }, -- better repetition
  be({ "christoomey/vim-titlecase", keys = { "gzz" } }), -- gzz
  be({ "christoomey/vim-sort-motion" }), -- gs<motion> eg. gs2j => sort 3 lines
  { "RutaTang/compter.nvim", opts = {} }, -- better <C-a> and <C-x>
}
