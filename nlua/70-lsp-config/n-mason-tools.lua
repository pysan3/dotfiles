local tools = {
  -- LSP
  { "bash-language-server", auto_update = true },
  "html-lsp",
  "lua-language-server",
  "vim-language-server",
  "vue-language-server",
  "yaml-language-server",

  -- DAP
  "debugpy",
  "node-debug2-adapter",

  -- Linter
  "cmakelang",
  "cpplint",
  "eslint_d",
  "flake8",
  "luacheck",
  "markdownlint",

  -- Formatter
  "cmakelang",
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
