vim.keymap.set("n", "<leader><leader>q", function()
  require("bufdelete").bufdelete(0, false)
end, { desc = "bufdelete.bufdelete(0, false)" })
