return {
  setup = {
    {
      "nvim-treesitter/nvim-treesitter",
      run = ":TSUpdateSync",
      requires = "nvim-treesitter/nvim-treesitter-textobjects",
    },
  },
}
