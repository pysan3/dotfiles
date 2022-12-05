local function set_config(_)
  require("lspsaga").init_lsp_saga({
    border_style = "rounded", -- "single" | "double" | "rounded" | "bold" | "plus"
    diagnostic_header = { " ", " ", " ", "ﴞ " },
    preview_lines_above = 4,
    max_preview_lines = 20,
    code_action_lightbulb = {
      sign = false,
    },
    finder_action_keys = {
      open = "e",
      vsplit = "s",
      split = "i",
      tabe = "t",
      quit = "q",
      scroll_down = "<C-f>",
      scroll_up = "<C-b>",
    },
    code_action_keys = {
      quit = "q",
      exec = "e",
    },
    symbol_in_winbar = {
      in_custom = false,
      enable = vim.g.personal_options.lsp_saga.winbar,
      separator = "  ",
      show_file = true,
      click_support = function(node, clicks, button, modifiers) ---@diagnostic disable-line
        local st = node.range.start
        local en = node.range["end"]
        if button == "l" then -- left click: jump to start
          vim.fn.cursor({ st.line + 1, st.character + 1 })
        elseif button == "r" then -- right click: jump to end
          vim.fn.cursor({ en.line + 1, en.character + 1 })
        elseif button == "m" then -- select whole region
          vim.fn.cursor({ st.line + 1, st.character + 1 })
          vim.cmd("normal v")
          vim.fn.cursor({ en.line + 1, en.character + 1 })
        end
      end,
    },
    show_outline = {
      jump_key = "o",
      auto_refresh = true,
      win_width = 40,
    },
  })
end

return {
  setup = set_config,
}
