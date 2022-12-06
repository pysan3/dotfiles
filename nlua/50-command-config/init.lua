return {
  { "zirrostig/vim-schlepp", event = { "ModeChanged" }, keys = { "<Plug>Schlepp" } }, -- dragvisuals
  { "famiu/bufdelete.nvim", module = { "bufdelete" } },
  { "nixon/vim-vmath", fn = { "VMATH_YankAndAnalyse" } },
  { "mg979/vim-visual-multi", keys = { "<Plug>(VM-Find-Subword-Under)", "<Plug>(VM-Find-Under)" } }, -- multi cursors in normal mode
  { "romainl/vim-qf", keys = { "<Plug>(qf_qf_previous)", "<Plug>(qf_qf_next)", "<Plug>(qf_qf_toggle)" } }, -- quickfix list
  { "folke/zen-mode.nvim", module = { "zen-mode" }, cmd = { "ZenMode" } }, -- zenmode
  -- { "chipsenkbeil/distant.nvim" }, -- distant.nvim (remote file edit)
  { "ntpeters/vim-better-whitespace", cmd = { "StripWhitespace" }, event = { "BufRead", "BufNewFile" } }, -- highlight trailing whitespace
  { "michaelb/sniprun", run = "bash install.sh", module = { "sniprun" },
    keys = { "<Plug>SnipRun", "<Plug>SnipRunOperator" } },
}
