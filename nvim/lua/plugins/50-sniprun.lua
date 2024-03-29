return {
  "michaelb/sniprun",
  build = "sh ./install.sh 1",
  version = false,
  enabled = false,
  keys = {
    { "<Leader>rf", "<Plug>SnipRun" },
    { "<Leader>r", "<Plug>SnipRunOperator" },
    { "<Leader>r", "<Plug>SnipRun", mode = { "v" } },
  },
  opts = {
    display = {
      "VirtualTextOk",
      "TerminalWithCode",
      "NvimNotify",
    },
  },
}
