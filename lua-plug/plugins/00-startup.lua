local function nolazy(plugin)
  plugin.lazy = false
  plugin.priority = 100
  return plugin
end

return {
  nolazy({ "dstein64/vim-startuptime" }),
  nolazy({ "nvim-lua/popup.nvim" }),
  nolazy({ "nvim-lua/plenary.nvim" }),
  {
    "dstein64/vim-startuptime",
    cmd = "StartupTime",
    config = function()
      vim.g.startuptime_tries = 10
    end,
  },
}
