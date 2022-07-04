return {
  setup = {
    "stevearc/aerial.nvim",
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
    "nvim-telescope/telescope-symbols.nvim",
  },
}
