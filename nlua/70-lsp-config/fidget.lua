require("fidget").setup({
  text = {
    -- spinner list: https://github.com/j-hui/fidget.nvim/blob/main/lua/fidget/spinners.lua
    spinner = "dots_pulse", -- dots, line, dots_bounce, ...
    done = "",
    commenced = "",
    completed = "",
  },
  timer = {
    fidget_decay = 500,
    task_decay = 500,
  },
  fmt = {
    fidget = function(fig_name, spinner)
      require("autosession").add_win_open_timer(500)
      return string.format("%s %s", spinner, fig_name)
    end,
    task = function(task_name, msg, perc)
      require("autosession").add_win_open_timer(500)
      return string.format("%s%s %s", msg, perc and string.format(" %s%%", perc) or "", task_name)
    end,
  },
})
