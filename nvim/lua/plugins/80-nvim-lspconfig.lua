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

  local base = require("lsp-config.base")
  base.setup({})
  local global_opts = {
    capabilities = base.capabilities(),
    on_attach = base.on_attach,
  }
  if vim.env.NVIM_LANG_NIM ~= nil then
    base.lsp_list[#base.lsp_list + 1] = "nim_langserver"
    vim.g.personal_module.null_register({ "f.nimpretty" })
  end

  for _, server_name in ipairs(base.lsp_list) do
    vim.lsp.config(server_name, combine_opts(server_name, global_opts))
  end
  require("mason-lspconfig").setup({
    automatic_installation = true,
    ensure_installed = base.lsp_list,
    automatic_enable = base.lsp_list,
  })
end

return M
