return {
  "utilyre/barbecue.nvim",
  cond = not vim.g.started_by_firenvim and not vim.g.personal_options.start_light_env,
  dependencies = {
    "SmiteshP/nvim-navic",
    "nvim-tree/nvim-web-devicons",
  },
  event = {
    "BufWinEnter",
    "CursorHold",
    "InsertLeave",
  },
  opts = {
    create_autocmd = true,
    attach_navic = true,
    context_follow_icon_color = false,
    exclude_filetypes = { "toggleterm", "bash", "zsh" },
    symbols = {
      modified = "● ",
      ellipsis = "… ",
      separator = " ",
    },
    kinds = vim.g.personal_options.lsp_icons,
  },
}
