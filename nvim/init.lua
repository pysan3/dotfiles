vim.cmd([[
source $HOME/.config/nvim/general/settings.vim
source $HOME/.config/nvim/keys/mappings.vim
]])

require("config.general")
require("config.lazy-plug")

pcall(require, "local") -- load "$HOME/.config/nvim/local.lua" if exists
