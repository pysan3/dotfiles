local function nolazy(plugin)
  if vim.g.personal_options.colorscheme == plugin.colorscheme and not vim.g.started_by_firenvim then
    plugin.lazy = false
    plugin.priority = 100
  else
    plugin.event = "VeryLazy"
  end
  return plugin
end

return {
  nolazy({
    "metalelf0/jellybeans-nvim",
    dependencies = { { "rktjmp/lush.nvim", version = false } },
    colorscheme = "jellybeans-nvim",
  }),
  nolazy({
    "folke/tokyonight.nvim",
    colorscheme = "tokyonight",
    opts = {
      style = "night",
      transparent = vim.g.personal_options.use_transparent,
    },
  }),
  nolazy({
    "EdenEast/nightfox.nvim",
    colorscheme = "carboxfox",
  }),
  nolazy({
    "dasupradyumna/midnight.nvim",
    colorscheme = "midnight",
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
      transparent = vim.g.personal_options.use_transparent,
      italic_comments = false,
      underline_links = true,
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
