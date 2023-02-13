return {
  "m-demare/hlargs.nvim",
  event = "VeryLazy",
  opts = {
    excluded_argnames = {
      usages = {
        lua = { "self", "use" },
      },
    },
  },
}
