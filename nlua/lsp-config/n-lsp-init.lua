local lsp_ok, _ = pcall(require, "lspconfig")
if not lsp_ok then
  return
end

local lsp_installer_ok, lsp_installer = pcall(require, "nvim-lsp-installer")
if not lsp_installer_ok then
  return
end

local servers = {
  rust_analyzer = {},
  clangd = {},
  pyright = {},
  pylsp = {},
  jsonls = {},
  sumneko_lua = {},
}

local opts = {
  on_attach = require("lsp-config.handlers").on_attach,
  capabilities = require("lsp-config.handlers").capabilities,
}

for server_name, server_opt in pairs(servers) do
  local server_ok, server = lsp_installer.get_server(server_name)
  if server_ok then
    server:on_ready(function()
      local is_opt, file_opt = pcall(require, "lsp-config.settings." .. server_name)
      if is_opt then
        opts = vim.tbl_deep_extend("force", file_opt, opts)
      end
      if server_opt ~= nil then
        opts = vim.tbl_deep_extend("force", server_opt, opts)
      end
      server:setup(opts)
    end)
    if not server:is_installed() then
      server:install()
    end
  end
end

require("lsp-config.handlers").setup()
require("lsp-config.n-lsp-null")
