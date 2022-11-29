vim.g.solarized_termcolors = 256
vim.opt.syntax = "on"

local colorscheme = "gruvbox"

local status_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme) ---@diagnostic disable-line
if not status_ok then
  vim.notify("colorscheme " .. colorscheme .. " not found!")
  return
end
vim.g.airline_theme = colorscheme

vim.opt.termguicolors = true
-- vim.cmd("highlight LineNr guifg=#2c4350")
