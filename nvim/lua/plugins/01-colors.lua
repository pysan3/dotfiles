local function nolazy(plugin)
  plugin.lazy = false
  plugin.priority = 100
  plugin.cond = plugin.cond and not vim.g.started_by_firenvim
  return plugin
end

local function set_colorscheme(extends)
  return function()
    if extends ~= nil then
      extends()
    end
    vim.cmd("colorscheme " .. vim.g.personal_options.colorscheme)
  end
end

return {
  nolazy({
    "metalelf0/jellybeans-nvim",
    dependencies = { "rktjmp/lush.nvim" },
    cond = vim.g.personal_options.colorscheme == "jellybeans-nvim",
    config = set_colorscheme(),
  }),
  nolazy({
    "rebelot/kanagawa.nvim",
    cond = vim.g.personal_options.colorscheme == "kanagawa",
    config = set_colorscheme(function()
      require("kanagawa").setup({
        globalStatus = true,
      })
    end),
  }),
  nolazy({
    "christianchiarulli/nvcode-color-schemes.vim",
    cond = vim.g.personal_options.colorscheme == "nvcode",
    config = set_colorscheme(),
  }),
  nolazy({
    "ellisonleao/gruvbox.nvim",
    cond = vim.g.personal_options.colorscheme == "gruvbox",
    config = set_colorscheme(),
  }),
  nolazy({
    "Mofiqul/vscode.nvim",
    cond = vim.g.personal_options.colorscheme == "vscode",
    config = set_colorscheme(function()
      require("vscode").setup({
        transparent = true, -- Enable transparent background
        italic_comments = true, -- Enable italic comment
      })
    end),
  }),
  nolazy({
    "mhartington/oceanic-next",
    cond = vim.g.personal_options.colorscheme == "OceanicNext",
    config = set_colorscheme(function()
      vim.g.oceanic_next_terminal_bold = 1
      vim.g.oceanic_next_terminal_italic = 1
    end),
  }),
}
