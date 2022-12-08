local function be(plugin)
  plugin.event = { "BufRead", "BufNewFile", "BufEnter" }
  return plugin
end

return {
  be({
    "folke/todo-comments.nvim",
    wants = { "plenary.nvim" },
    module = { "todo-comments" },
  }),
  be({ "andymass/vim-matchup" }),
  {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufRead", "BufNewFile", "InsertEnter" },
    run = ":TSUpdate",
    module = { "nvim-treesitter" },
    requires = {
      { "nvim-treesitter/nvim-treesitter-textobjects" },
    },
    wants = { "nvim-treesitter-textobjects", "vim-matchup" },
  },
  {
    "m-demare/hlargs.nvim",
    wants = { "nvim-treesitter" },
    event = { "BufRead", "BufNewFile", "InsertEnter" },
    module = { "hlargs" },
  }
}
