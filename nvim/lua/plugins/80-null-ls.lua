local M = {
  "nvimtools/none-ls.nvim",
  dependencies = {
    { "lukas-reineke/lsp-format.nvim" },
    { "neovim/nvim-lspconfig" },
  },
  cmd = { "NullLsLog", "NullLsInfo" },
  event = "BufReadPre",
}

local debug = vim.g.personal_options.debug.null

M.init = function()
  if debug then
    local log_file = vim.fn.stdpath("cache") .. "/null-ls.log"
    if vim.g.personal_module.exists(log_file) then
      vim.loop.fs_unlink(log_file)
    end
  end
end

M.config = function()
  local null_ls = require("null-ls")
  null_ls.setup({
    debug = debug,
    on_attach = function(client, _)
      require("lsp-format").on_attach(client)
    end,
  })
  require("lsp-config.null-helper").null_register({
    -- "f.autopep8",
    -- "d.flake8",
    "f.stylua",
  })
end

return M
