local M = {
  "numToStr/Comment.nvim",
  dependencies = {
    "JoosepAlviste/nvim-ts-context-commentstring",
  },
  keys = {
    { "gcc", nil, mode = "n" },
    { "gc", nil, mode = "v" },
    { "gC", ":normal gcc<CR>", mode = "x", noremap = true },
  },
}

M.config = function()
  require("Comment").setup({
    ignore = "^$",
    mappings = {
      basic = true,
      extra = true,
    },
    pre_hook = function(ctx)
      -- Only calculate commentstring for tsx filetypes
      if vim.bo.filetype == "typescriptreact" then
        local U, location = require("Comment.utils"), nil
        if ctx.ctype == U.ctype.blockwise then
          location = require("ts_context_commentstring.utils").get_cursor_location()
        elseif ctx.cmotion == U.cmotion.v or ctx.cmotion == U.cmotion.V then
          location = require("ts_context_commentstring.utils").get_visual_start_location()
        end
        return require("ts_context_commentstring.internal").calculate_commentstring({ ---@diagnostic disable-line
          key = ctx.ctype == U.ctype.linewise and "__default" or "__multiline",
          location = location,
        })
      end
      return nil ---@diagnostic disable-line
    end,
  })

  require("nvim-treesitter.configs").setup({
    context_commentstring = {
      enable = true,
      enable_autocmd = false,
    },
  })
end

return M
