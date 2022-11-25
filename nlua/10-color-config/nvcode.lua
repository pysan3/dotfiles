-- configure nvcode-color-schemes
vim.g.nvcode_termcolors = 256

vim.opt.syntax = "on"

local colorscheme = "nvcode"
local status_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme) ---@diagnostic disable-line
if not status_ok then
  vim.notify("colorscheme " .. colorscheme .. " not found!")
  return
end
vim.g.airline_theme = colorscheme

vim.cmd([[
if (has("termguicolors"))
  set termguicolors
  hi LineNr ctermbg=NONE guibg=NONE
endif
]])
