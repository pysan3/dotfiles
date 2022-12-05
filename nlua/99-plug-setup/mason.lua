local function getopts(is_noremap, desc)
  return { silent = true, noremap = is_noremap, desc = desc }
end

local lsp_prefix = "<leader>k"
---kmapset: Set keybinds for lspsaga
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
  vim.cmd("<Cmd>Lspsaga range_code_action<CR>")
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
