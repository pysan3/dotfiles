local M = {
  "jose-elias-alvarez/null-ls.nvim",
  dependencies = {
    { "lukas-reineke/lsp-format.nvim" },
    { "neovim/nvim-lspconfig" },
  },
  cmd = { "NullLsLog", "NullLsInfo" },
  event = "BufReadPre",
}

M.debug = false

M.config = function()
  if M.debug then
    local log_file = string.format([[%s/%s]], vim.fn.stdpath("cache"), "null-ls.log")
    if vim.g.personal_module.exists(log_file) then
      vim.loop.fs_unlink(log_file)
    end
  end

  local null_ls = require("null-ls")
  -- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/formatting
  local fmt = null_ls.builtins.formatting
  -- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
  local diag = null_ls.builtins.diagnostics

  local sources = {
    -- js, ts
    fmt.prettier,
    diag.eslint,
    fmt.eslint,
    -- python
    fmt.autopep8.with({
      extra_args = { "--max-line-length=120", "--aggressive", "--aggressive" },
    }),
    diag.flake8.with({ extra_args = { "--max-line-length=120", "--ignore=F405,W503" } }),
    -- lua
    fmt.stylua,
    -- rust
    fmt.rustfmt,
  }
  -- Add optional langs
  if vim.env.NVIM_LANG_NIM then -- nim
    sources[#sources + 1] = fmt.nimpretty.with({ extra_args = { "--maxLineLen:120" } })
  end

  null_ls.setup({
    debug = M.debug,
    on_attach = function(client, _)
      require("lsp-format").on_attach(client)
    end,
    sources = sources,
  })
end

return M
