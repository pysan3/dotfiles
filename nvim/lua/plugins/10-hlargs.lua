return {
  "m-demare/hlargs.nvim",
  event = "VeryLazy",
  config = {
    excluded_argnames = {
      usages = {
        lua = { "self", "use" },
      },
    },
  },
}
