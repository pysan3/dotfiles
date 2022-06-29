return {
  setup = {
    {
      "nvim-telescope/telescope.nvim",
      requires = {
        "BurntSushi/ripgrep",
        { "nvim-telescope/telescope-fzf-native.nvim", run = "make" },
        "nvim-telescope/telescope-media-files.nvim",
        "nvim-telescope/telescope-dap.nvim",
      },
    },
  },
  install = {
    {
      "stevearc/aerial.nvim",
      config = function()
        require("25-telescope-config.aerial-setup")
      end,
    },
    "nvim-telescope/telescope-symbols.nvim",
  },
}
