return {
  "windwp/nvim-autopairs",
  opts = {
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
  },
  config = function(_, opts)
    local npairs = require("nvim-autopairs")
    local Rule = require("nvim-autopairs.rule")
    local cond = require("nvim-autopairs.conds")
    npairs.setup(opts)
    npairs.add_rules({
      Rule("$$", "$$", "tex"),
      Rule(".", ".", "nim"):with_pair(cond.before_text("{")),
      Rule("$$", "$$", "norg"),
    })
    npairs.add_rule(Rule("<", ">", {
      -- Exclude these filetypes from this rule so that it doesn't conflict with nvim-ts-autotag
      "-html",
      "-javascriptreact",
      "-typescriptreact",
    }):with_pair(cond.before_regex("%a+:?:?$", 3)):with_move(function(ops)
      return ops.char == ">"
    end))
  end,
}
