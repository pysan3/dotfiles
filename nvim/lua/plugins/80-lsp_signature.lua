return {
  "ray-x/lsp_signature.nvim", -- show hints when writing function arguments
  dependencies = {
    "neovim/nvim-lspconfig",
    "folke/noice.nvim",
  },
  event = { "InsertEnter", "VeryLazy" },
  opts = {
    bind = true,
    noice = true,
    max_height = 20,
    zindex = 1,
    always_trigger = true,
    floating_window_above_cur_line = true,
    floating_window_off_x = function(info)
      local cur_pos = vim.api.nvim_win_get_cursor(0)[2] + 1
      local x_off = info.x_off or -vim.trim(vim.api.nvim_get_current_line():sub(1, cur_pos)):len()
      local win_width = vim.api.nvim_win_get_width(0) - vim.g.personal_options.signcolumn_length
      local origin = math.min(120, win_width)
      return origin - x_off - cur_pos
    end,
    extra_trigger_chars = { "(", ",", "\n" },
  },
}
