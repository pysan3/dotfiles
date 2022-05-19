return {
  setup = {
    "norcalli/nvim-colorizer.lua",
    { "kyazdani42/nvim-tree.lua", requires = "nvim-web-devicons" }, -- nvim tree
    { "akinsho/bufferline.nvim", requires = "nvim-web-devicons" }, -- bufferline
    { "nvim-lualine/lualine.nvim", requires = { "nvim-web-devicons", "nvim-treesitter" } }, -- lualine
  },
  install = {
    {
      "kyazdani42/nvim-web-devicons",
      requires = {
        "lunarvim/darkplus.nvim",
        { "christianchiarulli/nvcode-color-schemes.vim", requires = "nvim-treesitter" },
        "EdenEast/nightfox.nvim",
        "joshdick/onedark.vim",
        "ulwlu/elly.vim",
        "tomasiser/vim-code-dark",
        "arcticicestudio/nord-vim",
        "chriskempson/vim-tomorrow-theme",
        "doki-theme/doki-theme-vim",
      },
      setup = function()
        return vim.fn.has("termguicolors") == 1 and vim.cmd("set termguicolors")
      end,
      config = function()
        require("uiline-config.nvim-icons")
        require("themes.envtheme")
      end,
    },
    "Yggdroot/indentLine", -- show indent line with |
  },
}
