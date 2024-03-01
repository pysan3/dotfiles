return {
  "rcarriga/nvim-notify",
  event = "VeryLazy",
  opts = {
    stages = "static", -- fade_in_slide_out, fade, slide, static
    render = "default",
    timeout = 1200,
    background_colour = "Normal",
    minimum_width = 50,
    icons = { ERROR = "", WARN = "", INFO = "", DEBUG = "", TRACE = "✎" },
    level = vim.log.levels.INFO,
    fps = 20,
    on_open = function(win)
      vim.api.nvim_win_set_config(win, { zindex = 100 })
    end,
  },
}
