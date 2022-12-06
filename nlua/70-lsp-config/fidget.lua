require("fidget").setup({
  text = {
    -- spinner list: https://github.com/j-hui/fidget.nvim/blob/main/lua/fidget/spinners.lua
    spinner = "dots_pulse", -- dots, line, dots_bounce, ...
    done = " ",
    commenced = " ",
    completed = " ",
  },
  timer = {
    fidget_decay = 500,
    task_decay = 500,
  },
})
