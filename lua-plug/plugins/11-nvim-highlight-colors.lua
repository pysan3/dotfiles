return {
  "brenoprata10/nvim-highlight-colors",
  event = { "VeryLazy" },
  config = function()
    require("nvim-highlight-colors").setup({
      render = "background", -- or 'foreground' or 'first_column' or 'background'
      enable_named_colors = true,
      enable_tailwind = true,
    })
    require("nvim-highlight-colors").turnOn()
  end,
}
