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
  },
}
