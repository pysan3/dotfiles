return {
  commands = {
    RuffAutofix = {
      function()
        vim.lsp.buf.code_action({
          context = {
            only = { "source.fixAll.ruff" },
          },
          apply = true,
        })
      end,
      description = "Ruff: Fix all auto-fixable problems",
    },
    RuffOrganizeImports = {
      function()
        vim.lsp.buf.code_action({
          context = {
            only = { "source.organizeImports.ruff" },
          },
          apply = true,
        })
      end,
      description = "Ruff: Format imports",
    },
  },
}
