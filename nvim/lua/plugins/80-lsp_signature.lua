return {
  "ray-x/lsp_signature.nvim", -- show hints when writing function arguments
  enabled = false,
  dependencies = {
    "neovim/nvim-lspconfig",
    "folke/noice.nvim",
  },
  event = { "InsertEnter", "VeryLazy" },
  opts = {
    bind = true,
    noice = true,
    max_height = 5,
    zindex = 1,
    floating_window_off_x = function() -- put lsp hints on colorcolumn
      return vim.fn.max(vim.opt.colorcolumn:get()) - vim.fn.getcurpos()[3]
    end,
    extra_trigger_chars = { "(", ",", "\n" },
  },
}
