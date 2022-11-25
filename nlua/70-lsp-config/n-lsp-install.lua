local lspconfig = require("lspconfig")
local lsp_base = require("70-lsp-config.n-lsp-base")

local servers = {
  -- awk_ls = {}, -- AWK
  -- angularls = {}, -- Angular
  -- ansiblels = {}, -- Ansible
  -- arduino_language_server = {}, -- Arduino
  -- asm_lsp = {}, -- Assembly (GAS/NASM, GO)
  -- spectral = {}, -- AsyncAPI
  bashls = {}, -- Bash
  -- beancount = {}, -- Beancount
  -- bicep = {}, -- Bicep
  -- ccls = {}, -- C
  clangd = {}, -- C, C++
  -- csharp_ls = {}, -- C#
  -- omnisharp = {}, -- C#
  -- ccls = {}, -- C++
  cmake = {}, -- CMake
  -- cssls = {}, -- CSS
  -- cssmodules_ls = {}, -- CSS
  -- clojure_lsp = {}, -- Clojure
  -- codeqlls = {}, -- CodeQL
  -- crystalline = {}, -- Crystal
  -- scry = {}, -- Crystal
  -- cucumber_language_server = {}, -- Cucumber
  -- dartls = {}, -- Dart
  -- denols = {}, -- Deno
  diagnosticls = {}, -- Diagnostic (general purpose server)
  -- serve_d = {}, -- Dlang
  -- dockerls = {}, -- Docker
  -- dotls = {}, -- Dot
  -- efm = {}, -- EFM (general purpose server)
  -- eslint = {}, -- ESLint
  -- elixirls = {}, -- Elixir
  -- elmls = {}, -- Elm
  -- ember = {}, -- Ember
  emmet_ls = {}, -- Emmet
  -- erlangls = {}, -- Erlang
  -- fsautocomplete = {}, -- F#
  -- flux_lsp = {}, -- Flux
  -- foam_ls = {}, -- Foam (OpenFOAM)
  -- fortls = {}, -- Fortran
  -- golangci_lint_ls = {}, -- Go
  -- gopls = {}, -- Go
  -- grammarly = {}, -- Grammarly
  -- graphql = {}, -- GraphQL
  -- groovyls = {}, -- Groovy
  -- html = {}, -- HTML
  -- hls = {}, -- Haskell
  jsonls = {}, -- JSON
  jdtls = {}, -- Java
  -- quick_lint_js = {}, -- JavaScript
  tsserver = {}, -- JavaScript, TypeScript
  -- jsonnet_ls = {}, -- Jsonnet
  -- julials = {}, -- Julia
  -- kotlin_language_server = {}, -- Kotlin
  -- ltex = {}, -- LaTeX
  texlab = {}, -- LaTeX
  -- lelwel_ls = {}, -- Lelwel
  sumneko_lua = {}, -- Lua
  -- remark_ls = {}, -- Markdown
  -- zeta_note = {}, -- Markdown
  -- zk = {}, -- Markdown
  -- nickel_ls = {}, -- Nickel
  -- nimls = {}, -- Nim
  -- ocamlls = {}, -- OCaml
  -- ccls = {}, -- Objective C
  -- bsl_ls = {}, -- OneScript, 1C:Enterprise
  -- spectral = {}, -- OpenAPI
  -- opencl_ls = {}, -- OpenCL
  -- intelephense = {}, -- PHP
  -- phpactor = {}, -- PHP
  -- psalm = {}, -- PHP
  -- powershell_es = {}, -- Powershell
  -- prismals = {}, -- Prisma
  -- puppet = {}, -- Puppet
  -- purescriptls = {}, -- PureScript
  -- jedi_language_server = {}, -- Python
  pyright = {}, -- Python
  -- pylsp = {
  --   settings = {
  --     pylsp = {
  --       plugins = {
  --         pycodestyle = { maxLineLength = 120 },
  --         pyflakes = { enabled = false },
  --       },
  --     },
  --   },
  -- }, -- Python
  -- rescriptls = {}, -- ReScript
  -- rome = {}, -- Rome
  -- solargraph = {}, -- Ruby
  rust_analyzer = {}, -- Rust
  -- sqlls = {}, -- SQL
  -- sqls = {}, -- SQL
  -- salt_ls = {}, -- Salt
  -- theme_check = {}, -- Shopify Theme Check
  -- solang = {}, -- Solidity
  -- solc = {}, -- Solidity
  -- solidity_ls = {}, -- Solidity (VSCode)
  -- sorbet = {}, -- Sorbet
  -- esbonio = {}, -- Sphinx
  -- stylelint_lsp = {}, -- Stylelint
  -- svelte = {}, -- Svelte
  -- sourcekit = {}, -- Swift
  -- verible = {}, -- SystemVerilog
  taplo = {}, -- TOML
  -- tailwindcss = {}, -- Tailwind CSS
  -- terraformls = {}, -- Terraform
  -- tflint = {}, -- Terraform
  -- vala_ls = {}, -- Vala
  vimls = {}, -- VimL
  -- volar = {}, -- Vue
  vuels = {
    -- https://stackoverflow.com/questions/65913547/ionic-slot-attributes-are-deprecated-eslint-plugin-vue
    init_options = { config = { vetur = { validation = { template = false } } } },
  }, -- Vue
  -- lemminx = {}, -- XML
  -- yamlls = {}, -- YAML
  -- zls = {}, -- Zig
}

local lsp_list = {}
for k, _ in pairs(servers) do
  lsp_list[#lsp_list + 1] = k
end
local stop_lsp_fmt = {
  tsserver = 1,
  vuels = 1,
  eslint = 1,
  pylsp = 1,
}

require("nvim-lsp-installer").setup({
  log_level = vim.log.levels.WARN,
  ensure_installed = lsp_list,
})

local global_opts = {
  capabilities = lsp_base.capabilities,
  on_attach = function(client, bufnr)
    if stop_lsp_fmt[client.name] ~= nil then
      client.server_capabilities.documentFormattingProvider = false
    end
    lsp_base.lsp_keymaps(bufnr)
    lsp_base.lsp_highlight_document(client)
  end,
}

local M = {}

M.setup = function(_)
  for server_name, server_opt in pairs(servers) do
    local is_opt, file_opt = pcall(require, "70-lsp-config.settings." .. server_name)
    local opts = vim.tbl_deep_extend("force", global_opts, is_opt and file_opt or {}, server_opt or {})
    lspconfig[server_name].setup(opts)
  end
end

return M
