return {
  "utilyre/barbecue.nvim",
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
    symbols = {
      modified = "● ",
      ellipsis = "… ",
      separator = " ",
    },
    kinds = vim.g.personal_options.lsp_icons,
  },
}
