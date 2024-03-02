return {
  "pysan3/autosession.nvim", -- restore previous session
  event = "VeryLazy",
  lazy = false,
  init = function()
    vim.api.nvim_create_user_command("CL", "AutoSessionSave <bar> :wqa", {})
    vim.api.nvim_create_user_command("A", ":qa", {})
  end,
  opts = {
    restore_on_setup = true,
    autosave_on_quit = true,
    sessionfile_name = ".vim/session.vim",
    warn_on_setup = false,
  },
}
