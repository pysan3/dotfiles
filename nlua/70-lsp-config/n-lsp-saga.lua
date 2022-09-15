local M = {}

local saga = require("lspsaga")
local action = require("lspsaga.codeaction")

local function set_config(_)
  saga.init_lsp_saga({
    border_style = "rounded", -- "single" | "double" | "rounded" | "bold" | "plus"
    diagnostic_header = { " ", " ", " ", "ﴞ " },
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
      click_support = function(node, clicks, button, modifiers)
        local st = node.range.start
        local en = node.range["end"]
        if button == "l" then -- left click: jump to start
          vim.fn.cursor(st.line + 1, st.character + 1)
        elseif button == "r" then -- right click: jump to end
          vim.fn.cursor(en.line + 1, en.character + 1)
        elseif button == "m" then -- select whole region
          vim.fn.cursor(st.line + 1, st.character + 1)
          vim.cmd("normal v")
          vim.fn.cursor(en.line + 1, en.character + 1)
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
  local function cmd(c)
    return string.format("<Cmd>Lspsaga %s<CR>", c)
  end

  local lsp_prefix = "<leader>k"

  -- Async lsp finder: lsp finder to find the cursor word definition and reference
  vim.keymap.set("n", lsp_prefix .. "f", cmd("lsp_finder"), getopts(true, "lspsaga.lsp_finder"))

  -- Code Action
  vim.keymap.set("n", lsp_prefix .. "c", cmd("code_action"), getopts(true, "lspsaga.codeaction.code_action"))
  vim.keymap.set("v", lsp_prefix .. "c", function()
    vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<C-U>", true, false, true))
    vim.cmd("<Cmd><C-U>Lspsaga range_code_action<CR>")
  end, getopts(true, "lspsaga.codeaction.range_code_action()"))

  -- show hover doc
  vim.keymap.set("n", "K", cmd("hover_doc"), getopts(false, "lspsaga.hover.render_hover_doc"))
  -- scroll down hover doc or scroll in definition preview
  vim.keymap.set("n", "<C-f>", function()
    action.smart_scroll_with_saga(1)
  end, getopts(false, "lspsaga.codeaction.smart_scroll_with_saga(1)"))
  -- scroll up hover doc
  vim.keymap.set("n", "<C-b>", function()
    action.smart_scroll_with_saga(-1)
  end, getopts(false, "lspsaga.codeaction.smart_scroll_with_saga(-1)"))

  -- Outline
  vim.keymap.set("n", lsp_prefix .. "o", "<Cmd>LSoutlineToggle<CR>", getopts(true, "lspsaga.outline_toggle"))

  -- rename
  vim.keymap.set("n", lsp_prefix .. "r", cmd("rename"), getopts(true, "lspsaga.lsp_rename"))
  -- preview definition
  vim.keymap.set("n", lsp_prefix .. "k", cmd("preview_definition"), getopts(true, "lspsaga.preview_definition"))

  -- diagnostic
  vim.keymap.set("n", lsp_prefix .. "d", cmd("show_line_diagnostics"), getopts(true, "lspsaga.show_line_diagnostics"))
  -- jump diagnostic
  vim.keymap.set("n", "[d", cmd("diagnostic_jump_prev"), getopts(true, "lspsaga.diagnostic.goto_prev"))
  vim.keymap.set("n", "]d", cmd("diagnostic_jump_next"), getopts(true, "lspsaga.diagnostic.goto_next"))
end

M.setup = function(opts)
  set_config(opts)
  set_keybinds()
end

return M
