local function nolazy(plugin)
  plugin.lazy = false
  plugin.priority = 100
  return plugin
end

return {
  nolazy({ "nvim-lua/popup.nvim" }),
  nolazy({ "nvim-lua/plenary.nvim" }),
  nolazy({
    "dstein64/vim-startuptime",
    cmd = "StartupTime",
    enabled = false,
    init = function()
      vim.g.startuptime_tries = 10
    end,
  }),
  nolazy({ "folke/lsp-colors.nvim" }),
  {
    "m4xshen/hardtime.nvim",
    -- enabled = false,
    lazy = false,
    opts = {
      disable_mouse = false,
      allow_different_key = true,
      disabled_filetypes = { "qf", "NvimTree", "lazy", "mason", "neo-tree" },
      disabled_keys = {},
    },
  },
}
