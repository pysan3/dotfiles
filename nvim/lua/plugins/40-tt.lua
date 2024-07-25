return {
  "distek/tt.nvim",
  enabled = false,
  opts = {
    termlist = {
      enabled = false,
    },
  },
  keys = {
    { "<esc>", [[<C-\><C-n>]], noremap = true, mode = "t" },
    { "jk", [[<C-\><C-n>]], noremap = true, mode = "t" },
    { "<C-h>", [[<C-\><C-n><C-W>h]], noremap = true, mode = "t" },
    { "<C-j>", [[<C-\><C-n><C-W>j]], noremap = true, mode = "t" },
    { "<C-k>", [[<C-\><C-n><C-W>k]], noremap = true, mode = "t" },
    { "<C-l>", [[<C-\><C-n><C-W>l]], noremap = true, mode = "t" },
    {
      [[<C-\>]],
      function()
        require("tt.terminal"):Toggle()
      end,
      desc = "<Cmd>ToggleTerm<CR>",
      mode = { "t", "n" },
    },
  },
}
