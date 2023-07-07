return {
  "jiaoshijie/undotree",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  init = function()
    vim.opt.swapfile = false
    vim.opt.backup = false
    vim.opt.undofile = true
    vim.opt.undodir = vim.fn.stdpath("data") .. "/undodir"
  end,
  opts = {},
  keys = {
    {
      "<Leader>u",
      function()
        require("undotree").toggle()
      end,
      desc = "Undotree: toggle",
    },
  },
}
