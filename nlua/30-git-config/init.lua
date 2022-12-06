return {
  {
    "lewis6991/gitsigns.nvim",
    event = { "FocusLost", "CursorHold" },
    cmd = { "Gitsigns" },
    module = { "gitsigns" },
  },
  {
    "TimUntersberger/neogit",
    event = { "FocusLost", "CursorHold" },
    cmd = { "Neogit", "DiffviewOpen" },
    module = { "neogit" },
    requires = {
      { "sindrets/diffview.nvim", opt = true },
      { "rhysd/conflict-marker.vim", opt = true }
    },
    wants = { "diffview.nvim", "conflict-marker.vim" },
  },
  { "tpope/vim-fugitive", keys = "<leader>l" },
  {
    "ldelossa/gh.nvim",
    requires = { { "ldelossa/litee.nvim", opt = true } },
    wants = { "litee.nvim" },
    cmd = { "GH" },
  },

}
