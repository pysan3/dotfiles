return {
  "folke/todo-comments.nvim",
  cmd = { "TodoTrouble", "TodoTelescope" },
  event = "VeryLazy",
  keys = {
    { "]t", function() require("todo-comments").jump_next() end, desc = "Next todo comment" },
    { "[t", function() require("todo-comments").jump_prev() end, desc = "Previous todo comment" },
  },
  config = {
    signs = true,
    sign_priority = 8,
    keywords = { -- keywords recognized as todo comments
      FIX = { icon = " ", color = "error", alt = { "FIXME", "BUG", "FIXIT", "ISSUE" } },
      TODO = { icon = " ", color = "info" },
      HACK = { icon = " ", color = "warning" },
      WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
      PERF = { icon = " ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
      NOTE = { icon = " ", color = "hint", alt = { "INFO", "HINT" } },
    },
    merge_keywords = true,
    highlight = {
      before = "",
      keyword = "wide",
      after = "fg",
      pattern = [[.*<(KEYWORDS)\s*:]],
      comments_only = true,
      max_line_len = 400,
      exclude = {},
    },
    colors = {
      error = { "DiagnosticError", "ErrorMsg", "#DC2626" },
      warning = { "DiagnosticWarn", "WarningMsg", "#FBBF24" },
      info = { "#0db9d7" }, -- or "DiagnosticInfo"
      hint = { "DiagnosticHint", "#10B981" },
      default = { "Identifier", "#7C3AED" },
    },
    search = {
      command = "rg",
      args = { "--color=never", "--no-heading", "--with-filename", "--line-number", "--column" },
      pattern = [[\b(KEYWORDS):]],
    },
  },
}

-- TODO: test this line whether the highlighting is done correctly. <10-07-22, pysan3>
-- PERF: fully optimized
-- NOTE: adding a note
-- HACK: this should be implemented more carefully
-- FIX: this needs fixing
-- HINT: hoge
-- WARNING: ???
