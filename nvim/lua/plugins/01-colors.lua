local function nolazy(plugin)
  plugin.lazy = false
  plugin.priority = 100
  plugin.cond = vim.g.personal_options.colorscheme == plugin.colorscheme and not vim.g.started_by_firenvim
  return plugin
end

return {
  nolazy({
    "metalelf0/jellybeans-nvim",
    dependencies = { "rktjmp/lush.nvim" },
    colorscheme = "jellybeans-nvim",
  }),
  nolazy({
    "rebelot/kanagawa.nvim",
    colorscheme = "kanagawa",
    opts = {
      globalStatus = true,
      transparent = vim.g.personal_options.use_transparent,
    },
  }),
  nolazy({
    "christianchiarulli/nvcode-color-schemes.vim",
    colorscheme = "nvcode",
  }),
  nolazy({
    "ellisonleao/gruvbox.nvim",
    colorscheme = "gruvbox",
  }),
  nolazy({
    "nyngwang/nvimgelion",
    colorscheme = "nvimgelion",
  }),
  nolazy({
    "Mofiqul/vscode.nvim",
    colorscheme = "vscode",
    opts = {
      transparent = vim.g.personal_options.use_transparent, -- Enable transparent background
      italic_comments = true, -- Enable italic comment
    },
  }),
  nolazy({
    "mhartington/oceanic-next",
    colorscheme = "OceanicNext",
    init = function()
      vim.g.oceanic_next_terminal_bold = 1
      vim.g.oceanic_next_terminal_italic = 1
    end,
  }),
}
