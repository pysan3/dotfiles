require("notify").setup({
  stages = "static", -- fade_in_slide_out, fade, slide, static
  render = "default",
  timeout = 1200,
  background_colour = "Normal",
  minimum_width = 50,
  icons = { ERROR = "", WARN = "", INFO = "", DEBUG = "", TRACE = "✎" },
})

vim.notify = require("notify")
