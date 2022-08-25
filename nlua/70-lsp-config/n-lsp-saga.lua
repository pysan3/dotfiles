local M = {}

local saga = require("lspsaga")
local action = require("lspsaga.codeaction")

local function set_config(_)
  saga.init_lsp_saga({
    border_style = "rounded", -- "single" | "double" | "rounded" | "bold" | "plus"
    diagnostic_header = { " ", " ", " ", "ﴞ " },
    show_diagnostic_source = true,
    move_in_saga = { prev = "<C-p>", next = "<C-n>" },
    -- add bracket or something with diagnostic source, just have 2 elements
    diagnostic_source_bracket = {},
    code_action_lightbulb = {
      sign = false,
    },
    max_preview_lines = 10,
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
    rename_action_quit = "<C-c>",
    definition_preview_icon = "丨  ",
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
    server_filetype_map = {},
  })
end

local function set_keybinds()
  local function getopts(is_noremap, desc)
    return { silent = true, noremap = is_noremap, desc = desc }
  end

  local lsp_prefix = "<leader>k"

  -- Async lsp finder: lsp finder to find the cursor word definition and reference
  vim.keymap.set("n", lsp_prefix .. "f", require("lspsaga.finder").lsp_finder, getopts(true, "lspsaga.lsp_finder"))

  -- Code Action
  vim.keymap.set("n", lsp_prefix .. "c", action.code_action, getopts(true, "lspsaga.codeaction.code_action"))
  vim.keymap.set("v", lsp_prefix .. "c", function()
    vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<C-U>", true, false, true))
    action.range_code_action()
  end, getopts(true, "lspsaga.codeaction.range_code_action()"))

  -- show hover doc
  vim.keymap.set("n", "K", require("lspsaga.hover").render_hover_doc, getopts(false, "lspsaga.hover.render_hover_doc"))
  -- scroll down hover doc or scroll in definition preview
  vim.keymap.set("n", "<C-f>", function()
    action.smart_scroll_with_saga(1)
  end, getopts(false, "lspsaga.codeaction.smart_scroll_with_saga(1)"))
  -- scroll up hover doc
  vim.keymap.set("n", "<C-b>", function()
    action.smart_scroll_with_saga(-1)
  end, getopts(false, "lspsaga.codeaction.smart_scroll_with_saga(-1)"))

  -- show signature help
  -- vim.keymap.set(
  --   "n",
  --   lsp_prefix .. "s",
  --   require("lspsaga.signaturehelp").signature_help,
  --   getopts(true, "lspsaga.signature_help")
  -- )

  -- rename
  vim.keymap.set("n", lsp_prefix .. "r", require("lspsaga.rename").lsp_rename, getopts(true, "lspsaga.lsp_rename"))
  -- preview definition
  vim.keymap.set(
    "n",
    lsp_prefix .. "k",
    "<Cmd>Lspsaga preview_definition<CR>",
    getopts(true, "lspsaga.preview_definition")
  )

  -- diagnostic
  vim.keymap.set(
    "n",
    lsp_prefix .. "d",
    require("lspsaga.diagnostic").show_line_diagnostics,
    getopts(true, "lspsaga.show_line_diagnostics")
  )
  -- jump diagnostic
  vim.keymap.set("n", "[d", require("lspsaga.diagnostic").goto_prev, getopts(true, "lspsaga.diagnostic.goto_prev"))
  vim.keymap.set("n", "]d", require("lspsaga.diagnostic").goto_next, getopts(true, "lspsaga.diagnostic.goto_next"))
end

M.setup = function(opts)
  set_config(opts)
  set_keybinds()
end

return M
