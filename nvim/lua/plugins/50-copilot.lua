return {
  "zbirenbaum/copilot.lua",
  cmd = "Copilot",
  event = "InsertEnter",
  opts = {
    panel = {
      enabled = false,
      auto_refresh = true,
      keymap = {
        jump_prev = "[[",
        jump_next = "]]",
        accept = "<CR>",
        refresh = "gr",
        open = false,
      },
    },
    suggestion = {
      enabled = true,
      auto_trigger = true,
      hide_during_completion = false,
      keymap = {
        accept = "<M-CR>",
        accept_word = false,
        accept_line = false,
        next = "<M-]>",
        prev = "<M-[>",
        dismiss = "<C-]>",
      },
    },
    filetypes = {
      yaml = false,
      markdown = true,
      help = false,
      gitcommit = true,
      gitrebase = true,
      hgcommit = true,
      svn = false,
      cvs = false,
      ["."] = false,
    },
    should_attach = function(bufnr, _)
      if vim.bo[bufnr].buftype ~= "" then
        return false
      end
      return true
    end,
  },
}
