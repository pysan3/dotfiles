require("lsp_signature").setup({
  max_height = 5,
  zindex = 1,
  floating_window_off_x = vim.fn.max(vim.opt.colorcolumn:get()) - vim.fn.getcurpos()[3], -- put lsp hints on colorcolumn
  extra_trigger_chars = { "(", ",", "\n" },
})
