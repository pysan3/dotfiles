return {
  { "zirrostig/vim-schlepp", event = { "ModeChanged" }, keys = { "<Plug>Schlepp" } }, -- dragvisuals
  { "famiu/bufdelete.nvim", module = { "bufdelete" } },
  { "nixon/vim-vmath", fn = { "VMATH_YankAndAnalyse" } },
  { "mg979/vim-visual-multi", keys = { "<Plug>(VM-Find-Subword-Under)", "<Plug>(VM-Find-Under)" } }, -- multi cursors in normal mode
  { "romainl/vim-qf", keys = { "<Plug>(qf_qf_previous)", "<Plug>(qf_qf_next)", "<Plug>(qf_qf_toggle)" } }, -- quickfix list
  { "folke/zen-mode.nvim", module = { "zen-mode" }, cmd = { "ZenMode" } }, -- zenmode
  { "ntpeters/vim-better-whitespace", cmd = { "StripWhitespace" }, event = { "FocusLost", "CursorHold" } }, -- highlight trailing whitespace
  { "xorid/asciitree.nvim", cmd = { "AsciiTree" } }, -- `:AsciiTree <tab size> <indent symbol>`
  {
    "danymat/neogen", -- create docstring for several languages
    requires = { "nvim-treesitter/nvim-treesitter" }, tag = "*",
    wants = { "nvim-treesitter" }, module = { "neogen" }, cmd = { "Neogen" },
  },
  {
    "jackMort/ChatGPT.nvim",
    requires = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim" },
    wants = { "nui.nvim", "plenary.nvim", "telescope.nvim" },
    cmd = { "ChatGPT", "ChatGPTActAs" },
  }
}
