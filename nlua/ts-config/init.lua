return {
  setup = {
    {
      "nvim-treesitter/nvim-treesitter",
      run = ":TSUpdate",
      requires = "nvim-treesitter/nvim-treesitter-textobjects",
    },
  },
}
