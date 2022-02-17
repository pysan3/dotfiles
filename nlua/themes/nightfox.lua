-- nordfox, dayfox, dawnfox, duskfox

local colorscheme = "duskfox"
require("nightfox").load(colorscheme)

local status_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
if not status_ok then
  vim.notify("colorscheme " .. colorscheme .. " not found!")
  return
end
vim.g.airline_theme = colorscheme

require("lualine").setup({
  options = {
    -- ... your lualine config
    theme = "nightfox",
  },
})
