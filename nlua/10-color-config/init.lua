local function set_colorscheme(extends)
  return function()
    vim.cmd(string.format("colorscheme %s", vim.g.personal_options.colorscheme))
    if extends ~= nil then
      extends()
    end
  end
end

return {
  install = {
    {
      "christianchiarulli/nvcode-color-schemes.vim",
      cond = vim.g.personal_options.colorscheme == "nvcode",
      config = set_colorscheme(),
    },
    {
      "ellisonleao/gruvbox.nvim",
      cond = vim.g.personal_options.colorscheme == "gruvbox",
      config = set_colorscheme(),
    },
    {
      "Mofiqul/vscode.nvim",
      cond = vim.g.personal_options.colorscheme == "vscode",
      config = set_colorscheme(function()
        vim.g.vscode_transparent = 1
        vim.g.vscode_italic_comment = 1
      end),
    },
    {
      "mhartington/oceanic-next",
      cond = vim.g.personal_options.colorscheme == "OceanicNext",
      config = set_colorscheme(function()
        vim.g.oceanic_next_terminal_bold = 1
        vim.g.oceanic_next_terminal_italic = 1
      end),
    },
    -- "EdenEast/nightfox.nvim",
    -- "joshdick/onedark.vim",
    -- "lunarvim/darkplus.nvim",
    -- "ulwlu/elly.vim",
    -- "tomasiser/vim-code-dark",
    -- "arcticicestudio/nord-vim",
    -- "chriskempson/vim-tomorrow-theme",
    -- "doki-theme/doki-theme-vim",
  },
}
