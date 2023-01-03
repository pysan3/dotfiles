local M = {
  "glepnir/lspsaga.nvim",
  branch = "main",
  cmd = { "Lspsaga", "LSoutlineToggle" },
  event = "BufReadPre",
}

local function getopts(key_info, is_noremap, desc)
  return vim.tbl_deep_extend("keep", key_info, { silent = true, noremap = is_noremap, desc = desc })
end

local function lsp_map(key, c, skip_prefix, skip_cmd)
  return getopts({
    (skip_prefix and "" or vim.g.personal_options.prefix.lsp) .. key,
    skip_cmd and c or string.format("<Cmd>Lspsaga %s<CR>", c),
  }, true, c)
end

M.keys = {
  -- Async lsp finder: lsp finder to find the cursor word definition and reference
  lsp_map("f", "lsp_finder"),
  -- Code Action
  lsp_map("c", "code_action"),
  getopts({ vim.g.personal_options.prefix.lsp .. "c", function()
    vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<C-U>", true, false, true))
    vim.cmd("<Cmd>Lspsaga range_code_action<CR>")
  end }, true, "lspsaga.codeaction.range_code_action()"),
  -- show hover doc
  lsp_map("K", "hover_doc", true),
  -- Outline
  lsp_map("o", "<Cmd>LSoutlineToggle<CR>", false, true),
  -- rename
  lsp_map("r", "rename"),
  -- preview definition
  lsp_map("k", "peek_definition"),
  -- diagnostic
  lsp_map("d", "show_line_diagnostics"),
  -- jump diagnostic
  lsp_map("[d", "diagnostic_jump_prev", true),
  lsp_map("]d", "diagnostic_jump_next", true),
}

M.config = function()
  if not vim.g.personal_options.lsp_saga.enable then
    return
  end
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

return M
