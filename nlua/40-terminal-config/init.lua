return {
  {
    "akinsho/toggleterm.nvim",
    module = { "toggleterm" },
    cmd = { "ToggleTerm" },
    setup = function()
      vim.api.nvim_set_keymap("n", "<C-\\>", [[:ToggleTerm<CR>]], { desc = "toggleterm" })
    end
  },
}
