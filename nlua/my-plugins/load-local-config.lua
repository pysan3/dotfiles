local M = {}

local basef = require("my-plugins.base-functions")

M.SourceLocalConfig = function()
  local cwd = vim.fn.getcwd()
  local projectfile = basef.FullPath(cwd .. "/.vim/local.vim")
  if basef.file_exist(projectfile) then
    vim.cmd("so " .. projectfile)
  end
end

vim.cmd([[
augroup MyAutoCmds
  autocmd BufRead,BufNewFile * call SourceLocalConfig()
  autocmd BufRead,BufNewFile * lua require('my-plugins.load-local-config').SourceLocalConfig()

  if has('nvim')
    autocmd DirChanged * lua require('my-plugins.load-local-config').SourceLocalConfig()
  endif
augroup END
]])

return M
