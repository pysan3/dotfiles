local events = {
  "WinResized",
  "BufWinEnter",
  "CursorHold",
  "InsertLeave",
}

return {
  "utilyre/barbecue.nvim",
  name = "barbecue",
  version = "*",
  dependencies = {
    "SmiteshP/nvim-navic",
    "nvim-tree/nvim-web-devicons", -- optional dependency
  },
  event = events,
  init = function()
    vim.api.nvim_create_autocmd(events, {
      group = vim.api.nvim_create_augroup("barbecue.updater", {}),
      callback = function()
        require("barbecue")
        require("barbecue.ui").update()
      end,
    })
  end,
  opts = {
    create_autocmd = false, -- prevent barbecue from updating itself automatically
    attach_navic = false, -- prevent barbecue from automatically attaching nvim-navic
    context_follow_icon_color = false,
    symbols = {
      modified = "● ",
      ellipsis = "… ",
      separator = " ",
    },
    kinds = vim.g.personal_options.lsp_icons,
  },
}
