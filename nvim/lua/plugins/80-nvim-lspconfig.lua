local M = {
  "neovim/nvim-lspconfig", -- enable LSP
  event = "BufReadPre",
  version = false,
  dependencies = {
    { "hrsh7th/cmp-nvim-lsp" },
    { "SmiteshP/nvim-navic" },
    { "folke/neoconf.nvim" },
    { "lukas-reineke/lsp-format.nvim" },
    {
      "andrewferrier/textobj-diagnostic.nvim",
      opts = {},
      keys = {
        { "ig", mode = { "o", "v" }, desc = "Textobj diagnostic: next_diag_inclusive" },
        { "]g", mode = { "o", "v" }, desc = "Textobj diagnostic: next_diag" },
        { "[g", mode = { "o", "v" }, desc = "Textobj diagnostic: prev_diag" },
      },
    },
    { "folke/neodev.nvim" },
    { "williamboman/mason-lspconfig.nvim" },
  },
}

local lsp_list = {
  "bashls",
  "clangd",
  "cmake",
  "emmet_language_server",
  "gopls",
  "jsonls",
  -- "tsserver",
  "texlab",
  "lua_ls",
  "protols",
  "pyright",
  "ruff",
  "rust_analyzer",
  "taplo",
  "vimls",
  "volar",
}

local modify_server_capability = {
  tsserver = { documentFormattingProvider = false },
  vuels = { documentFormattingProvider = false },
  eslint = { documentFormattingProvider = true },
  ruff = { hoverProvider = false },
  pyright = { documentFormattingProvider = false },
  pylsp = { documentFormattingProvider = false },
  protols = { semanticTokensProvider = false },
  gopls = { semanticTokensProvider = false },
}

local function combine_opts(server_name, global_opts)
  if require("neoconf").get("lspconfig." .. server_name .. ".disabled") then
    return
  end
  local opts = global_opts
  local config_path = "lsp-config.settings." .. server_name
  if vim.g.personal_module.exists(config_path, true) then
    opts = vim.tbl_deep_extend("force", opts, require(config_path))
  end
  return opts
end

M.config = function()
  require("lsp-format").setup({})

  local lsp_base = require("lsp-config.base")
  lsp_base.setup({})
  local global_opts = {
    capabilities = lsp_base.capabilities(),
    on_attach = function(client, bufnr)
      lsp_base.lsp_keymaps(bufnr)
      require("lsp-format").on_attach(client)
      for k, v in pairs(modify_server_capability[client.name] or {}) do
        if v == false then
          client.server_capabilities[k] = nil
        else
          client.server_capabilities[k] = v
        end
      end
      if client.server_capabilities.documentSymbolProvider then
        require("nvim-navic").attach(client, bufnr)
      end
    end,
  }
  if vim.env.NVIM_LANG_NIM ~= nil then
    lsp_list[#lsp_list + 1] = "nim_langserver"
    vim.g.personal_module.null_register({ "f.nimpretty" })
  end

  for _, server_name in ipairs(lsp_list) do
    vim.lsp.config(server_name, combine_opts(server_name, global_opts))
  end
  require("mason-lspconfig").setup({
    ensure_installed = lsp_list,
    automatic_installation = true,
    automatic_enable = true,
  })
end

return M
