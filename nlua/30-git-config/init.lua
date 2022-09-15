return {
  setup = {
    "lewis6991/gitsigns.nvim",
    "TimUntersberger/neogit",
    { "tpope/vim-fugitive", keys = "<leader>l" },
    {
      "ldelossa/gh.nvim",
      requires = { { "ldelossa/litee.nvim" } },
    },
  },
  install = {
    "sindrets/diffview.nvim",
    "rhysd/conflict-marker.vim",
  },
}
