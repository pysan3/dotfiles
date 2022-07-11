return {
  setup = {
    "folke/todo-comments.nvim",
    "andymass/vim-matchup",
    {
      "nvim-treesitter/nvim-treesitter",
      requires = {
        "nvim-treesitter/nvim-treesitter-textobjects",
        "andymass/vim-matchup",
      },
    },
    "m-demare/hlargs.nvim",
  },
}
