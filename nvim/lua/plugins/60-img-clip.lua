return {
  "HakonHarnes/img-clip.nvim",
  cmd = "PasteImage",
  event = "BufEnter",
  opts = {
    norg = {
      template = [[.image $FILE_PATH$CURSOR]],
    },
  },
}
