---Textobject for adjacent commented lines
-- taken from: https://github.com/numToStr/Comment.nvim/issues/22#issuecomment-1272569139
local function commented_lines_textobject()
  local U = require("Comment.utils")
  local cl = vim.api.nvim_win_get_cursor(0)[1] -- current line
  local range = { srow = cl, scol = 0, erow = cl, ecol = 0 }
  local ctx = {
    ctype = U.ctype.linewise,
    range = range,
  }
  local cstr = require("Comment.ft").calculate(ctx) or vim.bo.commentstring
  local ll, rr = U.unwrap_cstr(cstr)
  local padding = true
  local is_commented = U.is_commented(ll, rr, padding)
  local line = vim.api.nvim_buf_get_lines(0, cl - 1, cl, false)
  if next(line) == nil or not is_commented(line[1]) then
    return
  end
  local rs, re = cl, cl -- range start and end
  repeat
    rs = rs - 1
    line = vim.api.nvim_buf_get_lines(0, rs - 1, rs, false)
  until next(line) == nil or not is_commented(line[1])
  rs = rs + 1
  repeat
    re = re + 1
    line = vim.api.nvim_buf_get_lines(0, re - 1, re, false)
  until next(line) == nil or not is_commented(line[1])
  re = re - 1
  vim.fn.execute("normal! " .. rs .. "GV" .. re .. "G")
end

local M = {
  "numToStr/Comment.nvim",
  dependencies = {
    "JoosepAlviste/nvim-ts-context-commentstring",
  },
  keys = {
    { "gcc", nil, mode = "n" },
    { "gc", nil, mode = "v" },
    { "gC", ":normal gcc<CR>", mode = "x", noremap = true },
    { "gc", commented_lines_textobject, mode = "o", silent = true, desc = "textobj for adjacent comments" },
    { "u", commented_lines_textobject, mode = "o", silent = true, desc = "textobj for adjacent comments" },
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
