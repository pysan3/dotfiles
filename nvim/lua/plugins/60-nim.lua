return {
  "alaviss/nim.nvim",
  ft = { "nim" },
  config = function()
    local aug = vim.api.nvim_create_augroup("NimRestartKeybinds", { clear = true })
    vim.api.nvim_create_autocmd("Filetype", {
      pattern = "nim",
      group = aug,
      desc = "Assign keybind to reset lang server attached to this buffer.",
      callback = function()
        vim.keymap.set("n", "<Leader>r", "<Cmd>LspStart<CR>", { buffer = 0, silent = true })
        vim.keymap.set("n", "<Leader>R", "<Cmd>LspRestart<CR>", { buffer = 0, silent = true })
      end,
    })
  end,
}
