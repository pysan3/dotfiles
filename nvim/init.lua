vim.cmd([[
source $HOME/.config/nvim/general/settings.vim
source $HOME/.config/nvim/keys/mappings.vim
]])

require("config.general")
require("config.lazy-plug")
vim.cmd.colorscheme(vim.g.personal_options.colorscheme)
vim.cmd("hi default link WinSeparator VertSplit")
vim.cmd("hi! link WinBar StatusLineNC")
vim.cmd("hi! link WinBarNC WinBar")

pcall(require, "local") -- load "$HOME/.config/nvim/local.lua" if exists
require("config.after")
