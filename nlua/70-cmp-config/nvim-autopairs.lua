require("nvim-autopairs").setup({
  disable_filetype = { "TelescopePrompt", "vim", "toggleterm" },
  enable_check_bracket_line = false,
  ignored_next_char = "[%w%.]", -- will ignore alphanumeric and `.` symbol
  fast_wrap = {
    map = "<M-e>",
    chars = { "{", "[", "(", '"', "'" },
    pattern = string.gsub([[ [%'%"%)%>%]%)%}%,] ]], "%s+", ""),
    offset = 0, -- Offset from pattern match
    end_key = "$",
    keys = "qwertyuiopzxcvbnmasdfghjkl",
    check_comma = true,
    highlight = "Search",
    highlight_grey = "Comment",
  },
})

local Rule = require("nvim-autopairs.rule")
local npairs = require("nvim-autopairs")

npairs.add_rule(Rule("$$", "$$", "tex"))

local cond = require("nvim-autopairs.conds")
npairs.add_rules({
  Rule("$", "$", { "tex", "latex" })-- don't add a pair if the next character is %
      :with_pair(cond.not_after_regex("%%"))-- don't add a pair if  the previous character is xxx
      :with_pair(cond.not_before_regex("xxx", 3))-- don't move right when repeat character
      :with_move(cond.none())-- don't delete if the next character is xx
      :with_del(cond.not_after_regex("xx"))-- disable adding a newline when you press <cr>
      :with_cr(cond.none()),
})

npairs.add_rules({
  Rule("$$", "$$", "tex"):with_pair(function(opts)
    if opts.line == "aa $$" then
      return false
    end
  end),
})

-- you can use regex. (u1234 => u1234number)
npairs.add_rules({
  Rule("u%d%d%d%d$", "number", "lua"):use_regex(true),
})

-- press x1234 => x12341234
npairs.add_rules({
  Rule("x%d%d%d%d$", "number", "lua"):use_regex(true):replace_endpair(function(opts)
    -- print(vim.inspect(opts))
    return opts.prev_char:sub(#opts.prev_char - 3, #opts.prev_char)
  end),
})

-- you can do anything with regex +special key
-- example press tab to uppercase text:
-- press b1234s<tab> => B1234S1234S
npairs.add_rules({
  Rule("b%d%d%d%d%w$", "", "vim"):use_regex(true, "<tab>"):replace_endpair(function(opts)
    return opts.prev_char:sub(#opts.prev_char - 4, #opts.prev_char) .. "<esc>viwU"
  end),
})

-- you can exclude filetypes
npairs.add_rule(Rule("$$", "$$"):with_pair(cond.not_filetypes({ "lua" })))
