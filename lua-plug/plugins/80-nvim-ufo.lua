return {
  "kevinhwang91/nvim-ufo",
  event = { "BufRead" },
  dependencies = {
    { "kevinhwang91/promise-async" },
    { "nvim-treesitter/nvim-treesitter" },
  },
  config = {
    provider_selector = function(_, _, _)
      return { 'treesitter', 'indent' }
    end
  },
}
