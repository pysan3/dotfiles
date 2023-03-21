local M = {}

M.setup = function(_)
  local signs = {
    { name = "DiagnosticSignError", text = "" },
    { name = "DiagnosticSignWarn", text = "" },
    { name = "DiagnosticSignHint", text = "" },
    { name = "DiagnosticSignInfo", text = "" },
  }
  for _, sign in ipairs(signs) do
    vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
  end
  vim.diagnostic.config({
    virtual_text = true,
    signs = {
      active = signs,
    },
    update_in_insert = true,
    underline = false,
    severity_sort = true,
    float = {
      focusable = false,
      style = "minimal",
      border = "rounded",
      source = "always",
      header = "",
      prefix = "",
    },
  })
  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
    border = "rounded",
  })
  vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
    border = "rounded",
  })
end

-- Automatically go to first definition even when multiple found
local function go_to_definition(is_type)
  return function()
    vim.lsp.buf[is_type and "type_definition" or "definition"]({
      reuse_win = true,
      on_list = function(opts)
        if #opts.items < 1 then
          return
        end
        local item = opts.items[1]
        vim.cmd([[normal! m']])
        vim.cmd.edit(item.filename)
        vim.api.nvim_win_set_cursor(0, { item.lnum, item.col - 1 })
      end,
    })
  end
end

M.lsp_keymaps = function(bufnr)
  local function getopts(desc)
    return { noremap = true, silent = true, buffer = bufnr, desc = desc }
  end
  local function keyn(key, func, opts)
    vim.keymap.set("n", key, func, opts)
  end

  local pfx = vim.g.personal_options.prefix.lsp
  keyn("gD", vim.lsp.buf.declaration, getopts("vim.lsp.buf.declaration"))
  keyn("gI", vim.lsp.buf.implementation, getopts("vim.lsp.buf.implementation"))
  keyn(pfx .. "l", vim.diagnostic.setloclist, getopts("vim.diagnostic.setloclist"))
  keyn(pfx .. "d", vim.diagnostic.open_float, getopts("vim.diagnostic.open_float"))
  vim.cmd([[ command! Format execute 'lua vim.lsp.buf.formatting()' ]])
  if vim.g.personal_options.lsp_saga.enable then
    -- conflicting keybinds with lspsaga
    return
  end
  keyn("gd", go_to_definition(false), getopts("vim.lsp.buf.definition"))
  keyn("K", vim.lsp.buf.hover, getopts("vim.lsp.buf.hover"))
  keyn(pfx .. "h", vim.lsp.buf.signature_help, getopts("vim.lsp.buf.signature_help"))
  keyn(pfx .. "r", vim.lsp.buf.rename, getopts("vim.lsp.buf.rename"))
  keyn(pfx .. "c", vim.lsp.buf.code_action, getopts("vim.lsp.buf.code_action"))
  keyn("[d", vim.diagnostic.goto_prev, getopts("vim.diagnostic.goto_prev"))
  keyn("]d", vim.diagnostic.goto_next, getopts("vim.diagnostic.goto_next"))
end

M.capabilities = function()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities.textDocument.foldingRange = {
    dynamicRegistration = false,
    lineFoldingOnly = true,
  }
  capabilities.offsetEncoding = { "utf-16" }
  return require("cmp_nvim_lsp").default_capabilities(capabilities)
end

return M
