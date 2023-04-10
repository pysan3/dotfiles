local color_lookup = {
  kanagawa = "#E6C384",
}

return {
  "m-demare/hlargs.nvim",
  event = "VeryLazy",
  opts = {
    color = color_lookup[vim.g.personal_options.colorscheme],
    excluded_argnames = {
      usages = {
        lua = { "self", "use" },
      },
    },
  },
}
