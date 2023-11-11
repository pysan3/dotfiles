return {
  "wallpants/github-preview.nvim",
  cmd = { "GithubPreviewToggle" },
  keys = {
    { "<leader>mt", "<Cmd>GithubPreviewToggle<CR>", silent = true },
  },
  opts = {
    cursor_line = {
      disable = false,
    },
  },
}
