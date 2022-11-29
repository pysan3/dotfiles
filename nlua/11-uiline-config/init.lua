return {
  setup = {
    "norcalli/nvim-colorizer.lua",
    "kyazdani42/nvim-web-devicons",
    -- "kyazdani42/nvim-tree.lua", -- nvim tree
    {
      "nvim-neo-tree/neo-tree.nvim",
      branch = "v2.x",
      -- "~/Git/neo-tree.nvim",
      -- branch = "main",
      requires = {
        "MunifTanjim/nui.nvim",
        { "s1n7ax/nvim-window-picker", tag = "1.*" },
      },
    },
    "akinsho/bufferline.nvim", -- bufferline
    "nvim-lualine/lualine.nvim", -- lualine
    "Yggdroot/indentLine", -- show indent line with |
  },
}
