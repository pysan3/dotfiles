return {
  "famiu/bufdelete.nvim",
  keys = {
    {
      "<Leader>Q",
      function()
        require("bufdelete").bufdelete(0, true)
      end,
      desc = "BufDelete: force delete current buffer",
    },
  },
}
