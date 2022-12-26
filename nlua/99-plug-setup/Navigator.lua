-- Keybindings
local all_modes = { "n", "v", "o", "i", "c", "t" }
vim.keymap.set(all_modes, "<A-h>", function()
  require("Navigator").left()
end, { desc = "<Cmd>NavigatorLeft<CR>" })
vim.keymap.set(all_modes, "<A-l>", function()
  require("Navigator").right()
end, { desc = "<Cmd>NavigatorRight<CR>" })
vim.keymap.set(all_modes, "<A-k>", function()
  require("Navigator").up()
end, { desc = "<Cmd>NavigatorUp<CR>" })
vim.keymap.set(all_modes, "<A-j>", function()
  require("Navigator").down()
end, { desc = "<Cmd>NavigatorDown<CR>" })
vim.keymap.set(all_modes, "<A-p>", function()
  require("Navigator").previous()
end, { desc = "<Cmd>NavigatorPrevious<CR>" })