return {
  "ThePrimeagen/refactoring.nvim",
  dependencies = {
    { "nvim-lua/plenary.nvim" },
    { "nvim-treesitter/nvim-treesitter" },
  },
  keys = {
    {
      vim.g.personal_options.prefix.language .. "r",
      function()
        local suc, _ = pcall(require("refactoring").select_refactor)
        if not suc then
          vim.notify("Error in refactoring")
        end
      end,
      mode = "v",
      noremap = true,
      silent = true,
      expr = false,
    },
  },
}
