local null_ls = require("null-ls")

-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/formatting
local fmt = null_ls.builtins.formatting
-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
local diag = null_ls.builtins.diagnostics

local M = {}

M.setup = function(_)
  null_ls.setup({
    on_attach = function(client)
      if client.server_capabilities.documentFormattingProvider then
        vim.cmd([[
          augroup LspFormatting
          autocmd! * <buffer>
          autocmd BufWritePre <buffer> lua vim.lsp.buf.format({ sync = true, timeout_ms = 5000 })
          augroup END
        ]])
      end
    end,
    debug = true,
    sources = {
      -- js, ts
      fmt.prettier,
      diag.eslint,
      fmt.eslint,
      -- python
      fmt.autopep8.with({ extra_args = { "--max-line-length=120", "--aggressive", "--aggressive" } }),
      diag.flake8.with({ extra_args = { "--max-line-length=120", "--ignore=F405" } }),
      -- lua
      fmt.stylua.with({ extra_args = { "--search-parent-directories" } }),
      -- rust
      fmt.rustfmt,
    },
  })
end

return M
