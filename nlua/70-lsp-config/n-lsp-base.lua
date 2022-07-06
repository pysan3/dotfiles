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

M.lsp_highlight_document = function(client)
  if client.server_capabilities.documentFormattingProvider then
    vim.api.nvim_exec(
      [[
      augroup lsp_document_highlight
      autocmd! * <buffer>
      autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
      autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      augroup END
    ]],
      false
    )
  end
end

M.lsp_keymaps = function(bufnr)
  local function getopts(desc)
    return { noremap = true, silent = true, buffer = bufnr, desc = desc }
  end
  vim.keymap.set("n", "gD", vim.lsp.buf.declaration, getopts("vim.lsp.buf.declaration"))
  vim.keymap.set("n", "gd", vim.lsp.buf.definition, getopts("vim.lsp.buf.definition"))
  vim.keymap.set("n", "gi", vim.lsp.buf.implementation, getopts("vim.lsp.buf.implementation"))
  vim.keymap.set("n", "K", vim.lsp.buf.hover, getopts("vim.lsp.buf.hover"))
  vim.keymap.set("n", "<leader>nh", vim.lsp.buf.signature_help, getopts("vim.lsp.buf.signature_help"))
  vim.keymap.set("n", "<leader>cn", vim.lsp.buf.rename, getopts("vim.lsp.buf.rename"))
  vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, getopts("vim.lsp.buf.references"))
  vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, getopts("vim.lsp.buf.code_action"))
  vim.keymap.set("n", "<leader>k", vim.diagnostic.open_float, getopts("vim.diagnostic.open_float"))
  vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, getopts("vim.diagnostic.goto_prev"))
  vim.keymap.set("n", "]d", vim.diagnostic.goto_next, getopts("vim.diagnostic.goto_next"))
  vim.keymap.set("n", "gl", vim.diagnostic.open_float, getopts("vim.diagnostic.open_float"))
  vim.keymap.set("n", "<leader>nl", vim.diagnostic.setloclist, getopts("vim.diagnostic.setloclist"))
  vim.cmd([[ command! Format execute 'lua vim.lsp.buf.formatting()' ]])
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
M.capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)

return M
