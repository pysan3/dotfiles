require("autosession").setup({
  restore_on_setup = true,
  autosave_on_quit = true,
  force_autosave = true,
  sessionfile_name = ".vim/session.vim",
})

vim.cmd([[
command! CL AutoSessionAuto <bar> :wqa
command! A :qa
]])
