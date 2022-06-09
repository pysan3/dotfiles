local bufdelete = require("bufdelete")

vim.keymap.set("n", "<leader>q", function()
  bufdelete.bufdelete(0, false)
end)
