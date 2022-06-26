require("lsp_signature").setup({
  max_height = 5,
  zindex = 1,
  floating_window_off_x = vim.api.nvim_get_option("columns"), -- max horizontally to the right
  extra_trigger_chars = { "(", ",", "\n" },
})
