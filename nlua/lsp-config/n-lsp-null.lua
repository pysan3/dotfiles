local null_ls = require("null-ls")

-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/formatting
local fmt = null_ls.builtins.formatting
-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
local diag = null_ls.builtins.diagnostics

null_ls.setup({
  on_attach = function(client)
    if client.resolved_capabilities.document_formatting then
      vim.cmd([[
        augroup LspFormatting
        autocmd! * <buffer>
        autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync(nil, 5000)
        augroup END
      ]])
    end
  end,
  debug = false,
  sources = {
    -- js, ts
    fmt.prettier,
    diag.eslint,
    -- python
    fmt.autopep8.with({ extra_args = { "--max-line-length=120", "--aggressive", "--aggressive" } }),
    diag.flake8.with({ extra_args = { "--max-line-length=120", "--ignore=F405" } }),
    -- lua
    fmt.stylua.with({
      extra_args = {
        "--indent-width=2",
        "--indent-type=Spaces",
        "--quote-style=AutoPreferDouble",
      },
    }),
  },
})
