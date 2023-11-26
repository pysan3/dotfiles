return {
  "numToStr/Navigator.nvim",
  keys = {
    {
      "<A-h>",
      function()
        require("Navigator").left()
      end,
      desc = "Navigator: left",
      mode = { "n", "v", "o", "i", "c", "t" },
    },
    {
      "<A-l>",
      function()
        require("Navigator").right()
      end,
      desc = "Navigator: right",
      mode = { "n", "v", "o", "i", "c", "t" },
    },
    {
      "<A-k>",
      function()
        require("Navigator").up()
      end,
      desc = "Navigator: up",
      mode = { "n", "v", "o", "i", "c", "t" },
    },
    {
      "<A-j>",
      function()
        require("Navigator").down()
      end,
      desc = "Navigator: down",
      mode = { "n", "v", "o", "i", "c", "t" },
    },
    {
      "<A-p>",
      function()
        require("Navigator").previous()
      end,
      desc = "Navigator: previous",
      mode = { "n", "v", "o", "i", "c", "t" },
    },
  },
  opts = {},
}
