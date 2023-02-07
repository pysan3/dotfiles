return {
  "mbbill/undotree",
  cmd = { "UndotreeShow" },
  init = function()
    vim.opt.swapfile = false
    vim.opt.backup = false
    vim.opt.undofile = true
    vim.opt.undodir = vim.fn.stdpath("data") .. "/undodir"
  end,
  keys = {
    { "<Leader>u", "<Cmd>UndotreeShow<CR>", desc = "<Cmd>UndotreeShow<CR>" },
  },
}
