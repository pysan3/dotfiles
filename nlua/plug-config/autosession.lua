require("autosession").setup({
  restore_on_setup = true,
  autosave_on_quit = true,
  sessionfile_name = ".session.vim",
})

vim.cmd([[
command! CL AutoSessionAuto <bar> :qa
]])
