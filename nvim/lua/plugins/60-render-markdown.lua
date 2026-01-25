local default_width = 88

local function block(opts, min_width)
  opts.width = opts.width or "block"
  opts.left_pad = opts.left_pad or 0
  opts.right_pad = opts.right_pad or 4
  opts.min_width = opts.min_width or min_width or default_width
  return opts
end

return {
  "MeanderingProgrammer/render-markdown.nvim",
  ft = { "markdown" },
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons",
  },
  opts = {
    sign = { enabled = false },
    heading = block({
      sign = false,
      position = "inline",
      icons = { "# ", "## ", "### ", "#### ", "##### ", "###### " },
    }),
    code = block({
      sign = false,
      style = "language",
    }),
    dash = {
      width = default_width,
    },
    quote = {
      repeat_linebreak = true,
    },
    pipe_table = {
      style = "normal",
    },
    win_options = { -- required for quote with linebreak to work properly
      showbreak = {
        default = "",
        rendered = "  ",
      },
      breakindent = {
        default = false,
        rendered = true,
      },
      breakindentopt = {
        default = "",
        rendered = "",
      },
    },
  },
}
