return {
  {
    "zirrostig/vim-schlepp", -- dragvisuals
    init = function()
      vim.g["Schlepp#allowSquishingLines"] = 1
      vim.g["Schlepp#allowSquishingBlock"] = 1
      vim.g["Schlepp#trimWS"] = 0
    end,
    keys = {
      { "<up>", "<Plug>SchleppUp", remap = true, mode = "x" },
      { "<down>", "<Plug>SchleppDown", remap = true, mode = "x" },
      { "<left>", "<Plug>SchleppLeft", remap = true, mode = "x" },
      { "<right>", "<Plug>SchleppRight", remap = true, mode = "x" },
      { "D", "<Plug>SchleppDup", remap = true, mode = "x" },
      { "Dk", "<Plug>SchleppDupUp", remap = true, mode = "x" },
      { "Dj", "<Plug>SchleppDupDown", remap = true, mode = "x" },
      { "Dh", "<Plug>SchleppDupLeft", remap = true, mode = "x" },
      { "Dl", "<Plug>SchleppDupRight", remap = true, mode = "x" },
    },
  },
  {
    "famiu/bufdelete.nvim",
    keys = {
      { "<Leader><Leader>q", function()
        require("bufdelete").bufdelete(0, false)
      end, desc = "bufdelete" },
    },
  },
  {
    "nixon/vim-vmath",
    keys = {
      { "++", "vip++", remap = true },
      { "++", function()
        vim.api.nvim_call_function("VMATH_YankAndAnalyse", {})
      end, mode = "x", expr = true },
    },
  },
  {
    "romainl/vim-qf", -- quickfix list
    keys = {
      { "<C-p>", "<Plug>(qf_qf_previous)", remap = true },
      { "<C-n>", "<Plug>(qf_qf_next)", remap = true },
      { "<Leader>xq", "<Plug>(qf_qf_toggle)", remap = true },
    },
  },
  {
    "xorid/asciitree.nvim", -- `:AsciiTree <tab size> <indent symbol>`
    cmd = { "AsciiTree" },
  },
  {
    "folke/zen-mode.nvim", -- zenmode
    cmd = "ZenMode",
    config = {},
  },
}
