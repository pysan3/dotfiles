return {
  setup = {
    "norcalli/nvim-colorizer.lua",
    {
      "kyazdani42/nvim-web-devicons",
      setup = function()
        return vim.fn.has("termguicolors") == 1 and vim.cmd("set termguicolors")
      end,
    },
    "kyazdani42/nvim-tree.lua", -- nvim tree
    "akinsho/bufferline.nvim", -- bufferline
    "nvim-lualine/lualine.nvim", -- lualine
  },
  install = {
    "Yggdroot/indentLine", -- show indent line with |
    -- "lunarvim/darkplus.nvim",
    "christianchiarulli/nvcode-color-schemes.vim",
    -- "EdenEast/nightfox.nvim",
    -- "joshdick/onedark.vim",
    "ellisonleao/gruvbox.nvim",
    -- "ulwlu/elly.vim",
    -- "tomasiser/vim-code-dark",
    -- "arcticicestudio/nord-vim",
    -- "chriskempson/vim-tomorrow-theme",
    -- "doki-theme/doki-theme-vim",
  },
}
