return {
  {
    "zirrostig/vim-schlepp", -- dragvisuals
    init = function()
      vim.g["Schlepp#allowSquishingLines"] = 1
      vim.g["Schlepp#allowSquishingBlock"] = 1
      vim.g["Schlepp#trimWS"] = 0
    end,
    keys = {
      { "<up>", "<Plug>SchleppUp", remap = true, mode = "x", desc = "<Plug>SchleppUp" },
      { "<down>", "<Plug>SchleppDown", remap = true, mode = "x", desc = "<Plug>SchleppDown" },
      { "<left>", "<Plug>SchleppLeft", remap = true, mode = "x", desc = "<Plug>SchleppLeft" },
      { "<right>", "<Plug>SchleppRight", remap = true, mode = "x", desc = "<Plug>SchleppRight" },
      { "D", "<Plug>SchleppDup", remap = true, mode = "x", desc = "<Plug>SchleppDup" },
      { "Dk", "<Plug>SchleppDupUp", remap = true, mode = "x", desc = "<Plug>SchleppDupUp" },
      { "Dj", "<Plug>SchleppDupDown", remap = true, mode = "x", desc = "<Plug>SchleppDupDown" },
      { "Dh", "<Plug>SchleppDupLeft", remap = true, mode = "x", desc = "<Plug>SchleppDupLeft" },
      { "Dl", "<Plug>SchleppDupRight", remap = true, mode = "x", desc = "<Plug>SchleppDupRight" },
    },
  },
  {
    "nixon/vim-vmath",
    keys = {
      { "++", "vip++", remap = true, desc = "Vim-vmath: inner paragraph VMATH_YankAndAnalyse" },
      { "++", function()
        vim.api.nvim_call_function("VMATH_YankAndAnalyse", {})
      end, mode = "x", expr = true, desc = "Vim-vmath: VMATH_YankAndAnalyse" },
    },
  },
  {
    "romainl/vim-qf", -- quickfix list
    keys = {
      { "<C-p>", "<Plug>(qf_qf_previous)", remap = true, desc = "<Plug>(qf_qf_previous)" },
      { "<C-n>", "<Plug>(qf_qf_next)", remap = true, desc = "<Plug>(qf_qf_next)" },
      { "<Leader>xq", "<Plug>(qf_qf_toggle)", remap = true, desc = "<Plug>(qf_qf_toggle)" },
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
