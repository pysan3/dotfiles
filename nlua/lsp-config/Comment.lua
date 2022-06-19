local comment = require("Comment")

comment.setup({
  ignore = "^$",
  mappings = {
    extended = true,
  },
  pre_hook = function(ctx)
    local U = require("Comment.utils")

    local location = nil
    if ctx.ctype == U.ctype.block then
      location = require("ts_context_commentstring.utils").get_cursor_location()
    elseif ctx.cmotion == U.cmotion.v or ctx.cmotion == U.cmotion.V then
      location = require("ts_context_commentstring.utils").get_visual_start_location()
    end

    return require("ts_context_commentstring.internal").calculate_commentstring({
      key = ctx.ctype == U.ctype.line and "__default" or "__multiline",
      location = location,
    })
  end,
})

require("nvim-treesitter.configs").setup({
  context_commentstring = {
    enable = true,
    enable_autocmd = false,
  },
})

vim.cmd([[
xnoremap gC :normal gcc<CR>
]])
