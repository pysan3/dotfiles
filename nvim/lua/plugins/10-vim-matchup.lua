return {
  "andymass/vim-matchup",
  event = { "VeryLazy" },
  version = false,
  dependencies = { "nvim-treesitter" },
  init = function()
    vim.g.matchup_surround_enabled = 1
    vim.g.matchup_delim_noskips = 1 -- recognize symbols within comments
    vim.g.matchup_matchparen_enabled = 1
    vim.g.matchup_matchparen_offscreen = { method = "popup" }
    vim.g.matchup_matchparen_deferred = 1
    vim.g.matchup_matchparen_timeout = 300
    vim.g.matchup_matchparen_insert_timeout = 60
  end,
  config = function()
    require("nvim-treesitter.configs").setup({ ---@diagnostic disable-line
      matchup = {
        enable = true,
        disable_virtual_text = false,
        include_match_words = true,
      },
    })
  end,
}
