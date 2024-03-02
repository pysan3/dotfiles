return {
  "HakonHarnes/img-clip.nvim",
  cmd = "PasteImage",
  event = "BufEnter",
  enabled = not vim.env.SSH_TTY,
  opts = {
    norg = {
      template = [[.image $FILE_PATH$CURSOR]],
    },
  },
}
