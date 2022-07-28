local tools = {
  -- LSP
  "bash-language-server",
  "cmake-language-server",
  "clangd",
  "dockerfile-language-server",
  "emmet-ls",
  "eslint-lsp",
  "html-lsp",
  "jdtls",
  "json-lsp",
  "lua-language-server",
  "opencl-language-server",
  "pyright",
  "taplo",
  "texlab",
  "typescript-language-server",
  "vim-language-server",
  "vetur-vls",
  "vue-language-server",
  "yaml-language-server",

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
