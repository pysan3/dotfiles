return {
  "zeioth/garbage-day.nvim",
  dependencies = "neovim/nvim-lspconfig",
  event = "LspAttach",
  opts = {
    notifications = true,
    excluded_lsp_clients = {
      "null-ls",
      "jdtls",
      "lua_ls",
    },
  },
}
