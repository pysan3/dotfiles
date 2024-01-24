return {
  "kaplanz/retrail.nvim",
  event = "BufEnter",
  cmds = { "RetrailTrimWhitespace", "RetrailEnable", "RetrailDisable", "RetrailToggle" },
  opts = {
    hlgroup = "NvimInternalError",
    trim = {
      auto = true,
      whitespace = true,
      blanklines = false,
    },
  },
}
