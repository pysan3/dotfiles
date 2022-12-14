local en = "keyboard-us"
require("fcitx5").setup({
  imname = {
    norm = en,
    ins = en,
    cmd = en,
  },
  remember_prior = true,
  define_autocmd = true,
  log = "warn",
})
