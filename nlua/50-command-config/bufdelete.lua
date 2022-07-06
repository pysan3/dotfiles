local bufdelete = require("bufdelete")

vim.keymap.set("n", "<leader><leader>q", function()
  bufdelete.bufdelete(0, false)
end, { desc = "bufdelete.bufdelete(0, false)" })
