local M = {
  "nvimtools/none-ls.nvim",
  dependencies = {
    "nvim-lspconfig",
    { "lukas-reineke/lsp-format.nvim" },
    { "nvimtools/none-ls-extras.nvim" },
  },
  cmd = { "NullLsLog", "NullLsInfo" },
  event = "BufReadPre",
}

local debug = vim.g.personal_options.debug.null

M.init = function()
  if debug then
    local log_file = vim.fn.stdpath("cache") .. "/null-ls.log"
    if vim.g.personal_module.exists(log_file) then
      vim.loop.fs_unlink(log_file) ---@diagnostic disable-line
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
    "f.isort",
    "f.black",
    -- "f.ruff_format",
    "d.mypy",
    -- "d.flake8",
    "f.stylua",
    "f.buildifier",
    "d.buildifier",
    "f.sqlfluff",
    "d.sqlfluff",
  })
end

return M
