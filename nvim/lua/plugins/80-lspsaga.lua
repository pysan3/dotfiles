local M = {
  "glepnir/lspsaga.nvim",
  enabled = vim.g.personal_options.lsp_saga.enable,
  cmd = { "Lspsaga" },
  event = "BufRead",
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
  -- show hover doc
  lsp_map("K", "hover_doc", true),
  -- overwrite gd
  lsp_map("gd", "goto_definition", true),
  -- Outline
  lsp_map("o", "outline"),
  -- rename
  lsp_map("r", "rename"),
  lsp_map("R", "rename ++project"),
  -- preview definition
  lsp_map("k", "peek_definition"),
  -- diagnostic
  lsp_map("d", "show_line_diagnostics"),
  -- jump diagnostic
  lsp_map("[d", "diagnostic_jump_prev", true),
  lsp_map("]d", "diagnostic_jump_next", true),
}

M.opts = {
  preview = {
    lines_above = 20,
    lines_below = 20,
  },
  request_timeout = 5000,
  finder = {
    max_height = 0.9,
    keys = {
      jump_to = "p",
      edit = { "e", "<CR>" },
      vsplit = "v",
      split = "s",
      tabe = "t",
      quit = { "q", "<ESC>" },
      close_in_preview = "<ESC>",
    },
  },
  lightbulb = {
    enable = true,
    enable_in_insert = true,
    sign = true,
    sign_priority = 40,
    virtual_text = true,
  },
  code_action = {
    num_shortcut = true,
    keys = {
      quit = "q",
      exec = "<CR>",
    },
  },
  symbol_in_winbar = {
    in_custom = false,
    enable = vim.g.personal_options.lsp_saga.winbar,
    separator = "  ",
    hide_keyword = false,
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
  outline = {
    win_position = "right",
    win_with = "",
    win_width = 40,
    show_detail = true,
    auto_preview = true,
    auto_refresh = true,
    auto_close = true,
    custom_sort = nil,
    keys = {
      jump = "o",
      expand_collaspe = "u",
      quit = "q",
    },
  },
  callhierarchy = {
    show_detail = true,
  },
  ui = {
    colors = {
      normal_bg = vim.api.nvim_get_hl_by_name("Normal", true).background,
    },
  },
}

return M
