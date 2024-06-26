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
  "jsonls",
  "tsserver",
  "texlab",
  "lua_ls",
  "pyright",
  "pylsp",
  "rust_analyzer",
  "taplo",
  "vimls",
  "volar",
}

local stop_lsp_fmt = {
  tsserver = true,
  vuels = true,
  eslint = true,
  pylsp = true,
}

M.config = function()
  require("lsp-format").setup({})

  local lsp_base = require("lsp-config.base")
  lsp_base.setup({})
  local global_opts = {
    capabilities = lsp_base.capabilities(),
    on_attach = function(client, bufnr)
      lsp_base.lsp_keymaps(bufnr)
      require("lsp-format").on_attach(client)
      if stop_lsp_fmt[client.name] then
        client.server_capabilities.documentFormattingProvider = false
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

  require("mason-lspconfig").setup({
    ensure_installed = lsp_list,
    automatic_installation = true,
  })
  require("mason-lspconfig").setup_handlers({
    function(server_name)
      if require("neoconf").get("lspconfig." .. server_name .. ".disabled") then
        return
      end
      local opts = global_opts
      local config_path = "lsp-config.settings." .. server_name
      if vim.g.personal_module.exists(config_path, true) then
        opts = vim.tbl_deep_extend("force", opts, require(config_path)) or opts
      end
      require("lspconfig")[server_name].setup(opts)
    end,
  })
end

return M
