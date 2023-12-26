return {
  "wallpants/github-preview.nvim",
  cmd = {
    "GithubPreviewToggle",
    "GithubPreviewStart",
  },
  keys = {
    { "<leader>mt", "<Cmd>GithubPreviewToggle<CR>", silent = true },
  },
  opts = {
    cursor_line = {
      disable = false,
    },
  },
}
