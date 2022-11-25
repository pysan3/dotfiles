local M = {}

local saga = require("lspsaga")

local function set_config(_)
  saga.init_lsp_saga({
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

local function getopts(is_noremap, desc)
  return { silent = true, noremap = is_noremap, desc = desc }
end

local function set_keybinds()
  local lsp_prefix = "<leader>k"
  ---kmapset
  -- Set keybinds for lspsaga
  ---@param key string: key for keybind
  ---@param c string: command
  ---@param skip_prefix boolean | nil: if true, `lsp_prefix` not added to keybind
  local function kmapset(key, c, skip_prefix)
    vim.keymap.set('n', (skip_prefix and '' or lsp_prefix) .. key,
      string.sub(string.lower(c), 1, 5) == '<cmd>' and c or string.format("<Cmd>Lspsaga %s<CR>", c),
      getopts(true, c))
  end

  -- Async lsp finder: lsp finder to find the cursor word definition and reference
  kmapset('f', 'lsp_finder')

  -- Code Action
  kmapset('c', 'code_action')
  vim.keymap.set("v", lsp_prefix .. "c", function()
    vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<C-U>", true, false, true))
    vim.cmd("<Cmd><C-U>Lspsaga range_code_action<CR>")
  end, getopts(true, "lspsaga.codeaction.range_code_action()"))

  -- show hover doc
  -- kmapset('K', 'hover_doc', true)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover)

  -- Outline
  kmapset('o', "<Cmd>LSoutlineToggle<CR>")

  -- rename
  kmapset('r', 'rename')
  -- preview definition
  kmapset('k', 'peek_definition')

  -- diagnostic
  kmapset('d', 'show_line_diagnostics')
  -- jump diagnostic
  kmapset('[d', 'diagnostic_jump_prev', true)
  kmapset(']d', 'diagnostic_jump_next', true)
end

M.setup = function(opts)
  set_config(opts)
  set_keybinds()
end

return M
