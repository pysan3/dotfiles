local M = {
  "williamboman/mason.nvim",
  event = "VeryLazy",
  dependencies = {
    { "WhoIsSethDaniel/mason-tool-installer.nvim" },
  },
}

M.tools = {
  -- DAP
  "debugpy",
  -- "node-debug2-adapter",

  -- Linter
  "cmakelang",
  "cpplint",
  "eslint-lsp",
  "flake8",
  "markdownlint",
  "pylint",
  "yamllint",

  -- Formatter
  "autopep8",
  "black",
  "cmakelang",
  "isort",
  "prettier",
  "shfmt",
  "stylua",
}

M.config = function(_)
  require("mason").setup({
    PATH = "append",
  })
  require("mason-tool-installer").setup({
    ensure_installed = M.tools,
    auto_update = true,
    run_on_start = true,
  })
end

return M
