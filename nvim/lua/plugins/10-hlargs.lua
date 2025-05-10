return {
  "m-demare/hlargs.nvim",
  enabled = false,
  event = "VeryLazy",
  opts = {
    color = vim.g.personal_lookup.get("hlargs", vim.g.personal_options.colorscheme),
    hl_priority = 10000,
    extras = {
      named_parameters = true,
    },
    excluded_argnames = {
      usages = {
        lua = { "self", "use" },
      },
    },
  },
}
