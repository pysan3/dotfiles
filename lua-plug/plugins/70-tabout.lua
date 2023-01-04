return {
  "abecodes/tabout.nvim",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "hrsh7th/nvim-cmp",
  },
  event = "InsertEnter",
  config = function()
    require("cmp") -- preload nvim-cmp
    require("tabout").setup({})
  end,
}
