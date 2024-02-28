return {
  "kevinhwang91/nvim-ufo",
  event = { "BufRead" },
  dependencies = {
    "nvim-treesitter",
    "nvim-lspconfig",
    { "kevinhwang91/promise-async" },
  },
  opts = {
    provider_selector = function(_, _, _)
      return { "treesitter", "indent" }
    end,
  },
}
