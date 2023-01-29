return {
  "andymass/vim-matchup",
  event = { "VeryLazy" },
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  init = function()
    vim.g.matchup_surround_enabled = 1
    vim.g.matchup_delim_noskips = 1 -- recognize symbols within comments
    vim.g.matchup_matchparen_enabled = 1
    vim.g.matchup_matchparen_offscreen = { method = "popup" }
  end,
  config = function()
    require("nvim-treesitter.configs").setup({
      matchup = {
        enable = true,
        disable_virtual_text = false,
        include_match_words = true,
      },
    })
  end,
}
