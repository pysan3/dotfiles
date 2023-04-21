return {
  "famiu/bufdelete.nvim",
  keys = {
    {
      "<Leader>q",
      function()
        require("bufdelete").bufdelete(0, true)
      end,
      desc = "BufDelete: force delete current buffer",
    },
    { "<Leader>Q", ":silent bd!<CR>" },
  },
}
