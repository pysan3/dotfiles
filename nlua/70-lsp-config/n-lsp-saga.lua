local M = {}

local saga = require("lspsaga")
local action = require("lspsaga.codeaction")

local function set_config(_)
  saga.init_lsp_saga({
    border_style = "rounded", -- "single" | "double" | "rounded" | "bold" | "plus"
    -- { bufnr, code, col, end_col, end_lnum, lnum, message, severity, source }
    diagnostic_header = { " ", " ", " ", "ﴞ " },
    move_in_saga = { prev = "<C-p>", next = "<C-n>" },
    show_diagnostic_source = true,
    -- add bracket or something with diagnostic source, just have 2 elements
    diagnostic_source_bracket = {},
    code_action_icon = "💡",
    -- if true can press number to execute the codeaction in codeaction window
    code_action_num_shortcut = true,
    code_action_lightbulb = {
      enable = true,
      sign = true,
      sign_priority = 20,
      virtual_text = true,
    },
    finder_separator = "  ",
    max_preview_lines = 10,
    finder_action_keys = {
      open = "o",
      vsplit = "s",
      split = "i",
      tabe = "t",
      quit = "q",
      scroll_down = "<C-f>",
      scroll_up = "<C-b>", -- quit can be a table
    },
    code_action_keys = {
      quit = "q",
      exec = "<CR>",
    },
    rename_action_quit = "<C-c>",
    definition_preview_icon = "丨  ",
    symbol_in_winbar = false, -- winbar support is too buggy for now
    winbar_separator = " > ",
    winbar_show_file = true,
    server_filetype_map = {},
  })
end

local function set_keybinds()
  local opt_silent = { silent = true }
  local opt_noremap = { silent = true, noremap = true }
  local lsp_prefix = "<leader>e"

  -- Async lsp finder: lsp finder to find the cursor word definition and reference
  vim.keymap.set("n", lsp_prefix .. "f", require("lspsaga.finder").lsp_finder, opt_noremap)

  -- Code Action
  vim.keymap.set("n", lsp_prefix .. "c", action.code_action, opt_noremap)
  vim.keymap.set("v", lsp_prefix .. "c", function()
    vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<C-U>", true, false, true))
    action.range_code_action()
  end, opt_noremap)

  -- show hover doc
  vim.keymap.set("n", "K", require("lspsaga.hover").render_hover_doc, opt_silent)
  -- scroll down hover doc or scroll in definition preview
  vim.keymap.set("n", "<C-f>", function()
    action.smart_scroll_with_saga(1)
  end, opt_silent)
  -- scroll up hover doc
  vim.keymap.set("n", "<C-b>", function()
    action.smart_scroll_with_saga(-1)
  end, opt_silent)

  -- show signature help
  vim.keymap.set("n", lsp_prefix .. "s", require("lspsaga.signaturehelp").signature_help, opt_noremap)

  -- rename
  vim.keymap.set("n", lsp_prefix .. "r", require("lspsaga.rename").lsp_rename, opt_noremap)
  -- preview definition
  vim.keymap.set("n", lsp_prefix .. "k", require("lspsaga.definition").preview_definition, opt_noremap)

  -- diagnostic
  vim.keymap.set("n", lsp_prefix .. "d", require("lspsaga.diagnostic").show_line_diagnostics, opt_noremap)
  -- jump diagnostic
  vim.keymap.set("n", "[d", require("lspsaga.diagnostic").goto_prev, opt_noremap)
  vim.keymap.set("n", "]d", require("lspsaga.diagnostic").goto_next, opt_noremap)
end

M.setup = function(opts)
  set_config(opts)
  set_keybinds()
end

return M
