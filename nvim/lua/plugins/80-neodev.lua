return {
  "folke/neodev.nvim", -- sumneko_lua extension for nvim development
  config = {
    override = function(root_dir, options)
      if root_dir:find("dotfiles") then
        options.enabled = true
      end
    end
  },
}
