return {
  "folke/neodev.nvim",
  opts = {
    override = function(root_dir, options)
      if root_dir:find("dotfiles") then
        options.enabled = true
      elseif vim.g.personal_module.exists(root_dir .. "/.nvim.lua") then
        options.enabled = true
      end
    end,
  },
}
