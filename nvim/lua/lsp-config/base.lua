local M = {}

M.lsp_list = {
  -- "bashls",
  "clangd",
  "cmake",
  "emmet_language_server",
  "eslint",
  "gopls",
  "jsonls",
  "ts_ls",
  "texlab",
  "lua_ls",
  "protols",
  "pyright",
  "ruff",
  "taplo",
  "vimls",
  -- "volar",
}

M.modify_server_capability = {
  ts_ls = { documentFormattingProvider = false },
  vuels = { documentFormattingProvider = false },
  eslint = { documentFormattingProvider = true },
  ruff = { hoverProvider = false },
  pyright = { documentFormattingProvider = false },
  pylsp = { documentFormattingProvider = false },
  protols = {
    semanticTokensProvider = false,
    documentFormattingProvider = false,
  },
  gopls = { semanticTokensProvider = false },
}

M.setup = function(_)
  local signs = {
    { name = "DiagnosticSignError", text = "" },
    { name = "DiagnosticSignWarn", text = "" },
    { name = "DiagnosticSignHint", text = "" },
    { name = "DiagnosticSignInfo", text = "" },
  }
  vim.diagnostic.config({
    virtual_text = true,
    signs = { active = signs },
    update_in_insert = false,
    underline = true,
    severity_sort = true,
    float = {
      focusable = false,
      style = "minimal",
      border = "rounded",
      source = true,
      header = "",
      prefix = "",
    },
  })
  vim.lsp.set_log_level(vim.g.personal_options.debug.lsp and "debug" or "off")
end

-- Automatically go to first definition even when multiple found
local function go_to_definition(is_type, open_split)
  return function()
    vim.lsp.buf[is_type and "type_definition" or "definition"]({
      reuse_win = true,
      on_list = function(opts)
        if #opts.items < 1 then
          return
        end
        local item = opts.items[1]
        for _, _item in ipairs(opts.items) do
          if string.find(_item.text or "", "[=(]") then
            item = _item
            break
          end
        end
        vim.cmd([[normal! m']])
        vim.g.personal_module.move_to_buf_pos(
          item.filename,
          false,
          { line = item.lnum, col = item.col - 1 },
          open_split
        )
      end,
    })
  end
end

local function diagnostic_jump(count)
  return function()
    return vim.diagnostic.jump({ count = count, float = true })
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
  keyn("gd", go_to_definition(false), getopts("vim.lsp.buf.definition"))
  keyn("GD", go_to_definition(false, true), getopts("vim.lsp.buf.definition"))
  keyn("K", vim.lsp.buf.hover, getopts("vim.lsp.buf.hover"))
  keyn(pfx .. "h", vim.lsp.buf.signature_help, getopts("vim.lsp.buf.signature_help"))
  keyn(pfx .. "r", vim.lsp.buf.rename, getopts("vim.lsp.buf.rename"))
  keyn(pfx .. "c", vim.lsp.buf.code_action, getopts("vim.lsp.buf.code_action"))
  keyn("[d", diagnostic_jump(-1), getopts("vim.diagnostic.goto_prev"))
  keyn("]d", diagnostic_jump(1), getopts("vim.diagnostic.goto_next"))
end

M.capabilities = function()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities.textDocument.foldingRange = {
    dynamicRegistration = false,
    lineFoldingOnly = true,
  }
  return require("cmp_nvim_lsp").default_capabilities(capabilities)
end

M.on_attach = function(client, bufnr)
  M.lsp_keymaps(bufnr)
  require("lsp-format").on_attach(client)
  for k, v in pairs(M.modify_server_capability[client.name] or {}) do
    if v == false then
      client.server_capabilities[k] = nil
    else
      client.server_capabilities[k] = v
    end
  end
  if client.server_capabilities.documentSymbolProvider then
    require("nvim-navic").attach(client, bufnr)
  end
end

return M
