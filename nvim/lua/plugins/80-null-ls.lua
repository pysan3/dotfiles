local M = {
  "jose-elias-alvarez/null-ls.nvim",
  dependencies = {
    { "lukas-reineke/lsp-format.nvim" },
    { "neovim/nvim-lspconfig" },
  },
  cmd = { "NullLsLog", "NullLsInfo" },
  event = "BufReadPre",
}

M.debug = vim.g.personal_options.debug.null

M.init = function()
  if M.debug then
    local log_file = vim.fn.stdpath("cache") .. "/null-ls.log"
    if vim.g.personal_module.exists(log_file) then
      vim.loop.fs_unlink(log_file)
    end
  end
end

M.config = function()
  local null_ls = require("null-ls")
  null_ls.setup({
    debug = M.debug,
    on_attach = function(client, _)
      require("lsp-format").on_attach(client)
    end,
  })
  require("lsp-config.null-helper").null_register({
    "f.autopep8",
    "f.stylua",
    "f.rustfmt",
  })
end

return M
