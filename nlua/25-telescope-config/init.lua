return {
  {
    "nvim-telescope/telescope.nvim",
    module = { "telescope" },
    requires = {
      { "BurntSushi/ripgrep", opt = true },
      { "nvim-telescope/telescope-fzf-native.nvim", run = "make", opt = true },
      { "nvim-telescope/telescope-media-files.nvim", opt = true },
      { "nvim-telescope/telescope-symbols.nvim", opt = true },
    },
    wants = {
      "ripgrep",
      "telescope-fzf-native.nvim",
      "telescope-media-files.nvim",
      "telescope-symbols.nvim"
    },
  },
}
