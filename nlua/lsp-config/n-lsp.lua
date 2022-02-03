local status_ok, _ = pcall(require, "lspconfig")
if not status_ok then
	return
end

local status_ok, lsp_installer = pcall(require, "nvim-lsp-installer")
if not status_ok then
  return
end

local servers = {
  "rust_analyzer",
  "clangd",
  "pyright",
  "jsonls",
  "sumneko_lua",
}

local servers_opts = {
  pyright = {},
}

local opts = {
  on_attach = require("lsp-config.handlers").on_attach,
  capabilities = require("lsp-config.handlers").capabilities,
}

for _, server_name in pairs(servers) do
  vim.notify(server_name)
  local server_ok, server = lsp_installer.get_server(server_name)
  print(server_ok)
  if server_ok then
    server:on_ready(function ()
      local dict_opt = servers_opts[server_name]
      if dict_opt ~= nil then
        opts = vim.tbl_deep_extend("force", file_opt, opts)
      end
      local is_opt, file_opt = pcall(require, "lsp-config.settings." .. server_name)
      if is_opt then
        opts = vim.tbl_deep_extend("force", file_opt, opts)
      end
      server:setup(opts)
    end)
    if not server:is_installed() then
      server:install()
    end
  end
end

-- lsp_installer.on_server_ready(function(server)
--   local opts = {
--     on_attach = require("lsp.handlers").on_attach,
--     capabilities = require("lsp.handlers").capabilities,
--   }

--   if server.name == "jsonls" then
--     local jsonls_opts = require("lsp.settings.jsonls")
--     opts = vim.tbl_deep_extend("force", jsonls_opts, opts)
--   end

--   if server.name == "sumneko_lua" then
--     local sumneko_opts = require("lsp.settings.sumneko_lua")
--     opts = vim.tbl_deep_extend("force", sumneko_opts, opts)
--   end

--   if server.name == "pyright" then
--     local pyright_opts = require("lsp.settings.pyright")
--     opts = vim.tbl_deep_extend("force", pyright_opts, opts)
--   end

--   -- This setup() function is exactly the same as lspconfig's setup function.
--   -- Refer to https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
--   server:setup(opts)
-- end)

require("lsp-config.handlers").setup()
