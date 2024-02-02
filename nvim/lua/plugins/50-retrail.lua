return {
  "kaplanz/retrail.nvim",
  event = "BufEnter",
  cmd = { "RetrailTrimWhitespace", "RetrailEnable", "RetrailDisable", "RetrailToggle" },
  opts = {
    hlgroup = "NvimInternalError",
    trim = {
      auto = true,
      whitespace = true,
      blanklines = false,
    },
  },
}
