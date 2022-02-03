local null_ls_status_ok, null_ls = pcall(require, "null-ls")
if not null_ls_status_ok then
  return
end

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
        autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()
        augroup END
      ]])
    end
  end,
  debug = false,
  sources = {
    fmt.prettier.with({ extra_args = { "--no-semi", "--single-quote", "--jsx-single-quote" } }),
    fmt.autopep8.with({ extra_args = { "--max-line-length=120", "--aggressive", "--aggressive" } }),
    fmt.stylua.with({
      extra_args = {
        "--indent-width=2",
        "--indent-type=Spaces",
        "--quote-style=AutoPreferDouble",
      },
    }),
    diag.flake8.with({ extra_args = { "--max-line-length=120", "--ignore=F405" } }),
  },
})
