return {
  "m-demare/hlargs.nvim",
  event = "VeryLazy",
  opts = {
    color = vim.g.personal_lookup.get("hlargs", vim.g.personal_options.colorscheme),
    excluded_argnames = {
      usages = {
        lua = { "self", "use" },
      },
    },
  },
}
