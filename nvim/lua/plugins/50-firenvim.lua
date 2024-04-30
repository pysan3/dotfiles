if vim.env.MYENV == "WSL" then
  return {}
end

local M = {
  "glacambre/firenvim",
  lazy = not vim.g.started_by_firenvim,
}

M.build = function()
  vim.fn["firenvim#install"](0)
end

M.init = function()
  if vim.g.started_by_firenvim then
    vim.g.firenvim_config = {
      localSettings = {
        [".*"] = {
          cmdline = "none",
          takeover = "never",
        },
      },
    }
    vim.opt.laststatus = 0
    local firenvim_aug = vim.api.nvim_create_augroup("FireNvimAuG", { clear = true })
    vim.api.nvim_create_autocmd("UIEnter", {
      once = true,
      group = firenvim_aug,
      callback = function()
        vim.go.lines = 20
      end,
    })
    vim.api.nvim_create_autocmd("BufEnter", {
      pattern = "github.com_*.txt",
      group = firenvim_aug,
      command = "set filetype=markdown",
    })
  end
end

M.config = function()
  if vim.g.started_by_firenvim then
    vim.cmd.startinsert()
    vim.cmd([[set spell spelllang=en_us,cjk<CR>]])
  end
end

return M
