return {
  "m-demare/hlargs.nvim",
  event = "VeryLazy",
  opts = {
    color = vim.g.personal_options.hlargs_lookup[vim.g.personal_options.colorscheme],
    excluded_argnames = {
      usages = {
        lua = { "self", "use" },
      },
    },
  },
}
