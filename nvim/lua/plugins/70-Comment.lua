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

---Operator function to invert comments on each line
-- taken from: https://github.com/numToStr/Comment.nvim/issues/17#issuecomment-1268650042
function _G.__flip_flop_comment()
  local U = require("Comment.utils")
  local s = vim.api.nvim_buf_get_mark(0, "[")
  local e = vim.api.nvim_buf_get_mark(0, "]")
  local range = { srow = s[1], scol = s[2], erow = e[1], ecol = e[2] }
  local ctx = {
    ctype = U.ctype.linewise,
    range = range,
  }
  local cstr = require("Comment.ft").calculate(ctx) or vim.bo.commentstring
  local ll, rr = U.unwrap_cstr(cstr)
  local padding = true
  local is_commented = U.is_commented(ll, rr, padding)

  local rcom = {} -- ranges of commented lines
  local cl = s[1] -- current line
  local rs, re = nil, nil -- range start and end
  local lines = U.get_lines(range)
  for _, line in ipairs(lines) do
    if #line == 0 or not is_commented(line) then -- empty or uncommented line
      if rs ~= nil then
        table.insert(rcom, { rs, re })
        rs, re = nil, nil
      end
    else
      rs = rs or cl -- set range start if not set
      re = cl -- update range end
    end
    cl = cl + 1
  end
  if rs ~= nil then
    table.insert(rcom, { rs, re })
  end

  local cursor_position = vim.api.nvim_win_get_cursor(0)
  local vmark_start = vim.api.nvim_buf_get_mark(0, "<")
  local vmark_end = vim.api.nvim_buf_get_mark(0, ">")

  ---Toggle comments on a range of lines
  ---@param sl integer: starting line
  ---@param el integer: ending line
  local toggle_lines = function(sl, el)
    vim.api.nvim_win_set_cursor(0, { sl, 0 }) -- idk why it's needed to prevent one-line ranges from being substituted with line under cursor
    vim.api.nvim_buf_set_mark(0, "[", sl, 0, {})
    vim.api.nvim_buf_set_mark(0, "]", el, 0, {})
    require("Comment.api").locked("toggle.linewise")("line")
  end

  toggle_lines(s[1], e[1])
  for _, r in ipairs(rcom) do
    toggle_lines(r[1], r[2]) -- uncomment lines twice to remove previous comment
    toggle_lines(r[1], r[2])
  end

  vim.api.nvim_win_set_cursor(0, cursor_position)
  vim.api.nvim_buf_set_mark(0, "<", vmark_start[1], vmark_start[2], {})
  vim.api.nvim_buf_set_mark(0, ">", vmark_end[1], vmark_end[2], {})
  vim.o.operatorfunc = "v:lua.__flip_flop_comment" -- make it dot-repeatable
end

local function silent(t)
  t.silent = true
  return t
end

local M = {
  "numToStr/Comment.nvim",
  dependencies = {
    "JoosepAlviste/nvim-ts-context-commentstring",
  },
  keys = {
    silent({ "gcc", nil, mode = "n", desc = "Comment: toggle" }),
    silent({ "gc", nil, mode = "v", desc = "Comment: toggle visual" }),
    silent({ "gcb", "yyPgccj", mode = "n", desc = "Comment: create backup", remap = true }),
    silent({ "gcb", "ypgvgcj", mode = "v", desc = "Comment: create backup", remap = true }),
    silent({
      "gC",
      "<Cmd>set operatorfunc=v:lua.__flip_flop_comment<CR>g@",
      mode = { "n", "x" },
      desc = "Invert comments",
    }),
    silent({ "gc", commented_lines_textobject, mode = "o", desc = "toggle adjacent comments" }),
    silent({ "u", commented_lines_textobject, mode = "o", desc = "toggle for adjacent comments" }),
  },
}

M.config = function()
  vim.g.skip_ts_context_commentstring_module = true
  require("Comment").setup({ ---@diagnostic disable-line
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
          location = location, ---@diagnostic disable-line
        })
      end
      return nil ---@diagnostic disable-line
    end,
  })
end

return M
