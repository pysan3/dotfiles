return {
  "folke/neodev.nvim",
  config = {
    override = function(root_dir, options)
      if root_dir:find("dotfiles") then
        options.enabled = true
      end
    end,
  },
}
