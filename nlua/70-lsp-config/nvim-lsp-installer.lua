require("70-lsp-config.n-lsp-base").setup({})
require("70-lsp-config.n-lsp-install").setup({})
require("70-lsp-config.n-lsp-null").setup({})
if vim.g.personal_options.lsp_saga.enable then
  require("70-lsp-config.n-lsp-saga").setup({})
end
require("textobj-diagnostic").setup({})
