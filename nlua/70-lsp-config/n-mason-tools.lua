local tools = {
  -- DAP
  "debugpy",
  -- "node-debug2-adapter",

  -- Linter
  "cmakelang",
  "cpplint",
  "eslint_d",
  "flake8",
  "luacheck",
  "markdownlint",
  "pylint",
  "yamllint",

  -- Formatter
  "autopep8",
  "cmakelang",
  "isort",
  "luaformatter",
  "prettier",
  "shfmt",
  "stylua",
}

local M = {}

M.setup = function(_)
  require("mason-tool-installer").setup({
    ensure_installed = tools,
    auto_update = true,
    run_on_start = true,
  })
end

return M
