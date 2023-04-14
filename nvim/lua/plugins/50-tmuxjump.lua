return {
  "shivamashtikar/tmuxjump.vim",
  cond = string.len(vim.env.TMUX or "") > 0,
  dependencies = {
    { "nvim-telescope/telescope.nvim" },
  },
  keys = {
    { vim.g.personal_options.prefix.telescope .. "t", "<Cmd>TmuxJumpFile<CR>" },
    { vim.g.personal_options.prefix.telescope .. ";", "<Cmd>TmuxJumpFirst<CR>" },
  },
  init = function()
    vim.g.tmuxjump_telescope = true
  end,
}
