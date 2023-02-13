local en = "keyboard-us"

return {
  "pysan3/fcitx5.nvim",
  cond = vim.fn.executable("fcitx5-remote") == 1,
  event = { "ModeChanged" },
  opts = {
    imname = {
      norm = en,
      ins = en,
      cmd = en,
    },
    remember_prior = true,
    define_autocmd = true,
    log = "warn",
  },
}
