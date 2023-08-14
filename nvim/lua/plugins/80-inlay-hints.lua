return {
  "simrat39/inlay-hints.nvim",
  opts = {
    only_current_line = true,
    renderer = "inlay-hints.render.eol",
    eol = {
      right_align = false,
      right_align_padding = 7,
      parameter = {
        separator = ", ",
        format = function(hints)
          return string.format(" <- (%s)", hints)
        end,
      },
      type = {
        separator = ", ",
        format = function(hints)
          return string.format(" » (%s)", hints)
        end,
      },
    },
  },
}
