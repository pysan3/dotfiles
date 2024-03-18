return {
  "bloznelis/before.nvim",
  dependencies = {
    "telescope.nvim",
  },
  keys = {
    {
      "<Leader>O",
      function()
        require("before").show_edits_in_telescope()
      end,
      desc = "Before: show_edits_in_telescope",
    },
  },
}
