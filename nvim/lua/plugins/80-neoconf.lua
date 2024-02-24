return {
  "folke/neoconf.nvim",
  cmd = { "Neoconf" },
  opts = {
    override = function(root_dir, options)
      if vim.loop.fs_stat(root_dir .. "/lua") then
        options.plugins = true
        options.enabled = true
      end
    end,
    plugins = {
      lua_ls = {
        enabled = true,
      },
    },
  },
}
