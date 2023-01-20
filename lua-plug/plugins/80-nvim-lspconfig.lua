local M = {
  "neovim/nvim-lspconfig", -- enable LSP
  event = "BufReadPre",
  dependencies = {
    { "hrsh7th/cmp-nvim-lsp" },
    { "andrewferrier/textobj-diagnostic.nvim", config = {}, keys = {
      { "ig", mode = { "o", "v" }, desc = "Textobj diagnostic: next_diag_inclusive" },
      { "]g", mode = { "o", "v" }, desc = "Textobj diagnostic: next_diag" },
      { "[g", mode = { "o", "v" }, desc = "Textobj diagnostic: prev_diag" },
    } },
    { "folke/neodev.nvim" }, -- sumneko_lua extension for nvim development
    { "williamboman/mason-lspconfig.nvim" },
  },
}

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
  -- diagnosticls = {}, -- Diagnostic (general purpose server)
  -- serve_d = {}, -- Dlang
  -- dockerls = {}, -- Docker
  -- dotls = {}, -- Dot
  -- efm = {}, -- EFM (general purpose server)
  -- eslint = {}, -- ESLint
  -- elixirls = {}, -- Elixir
  -- elmls = {}, -- Elm
  -- ember = {}, -- Ember
  emmet_ls = {}, -- Emmet
  erg_language_server = {}, -- Erg
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
  nimls = {}, -- Nim
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
  volar = {}, -- Vue
  -- vuels = {
  --   -- https://stackoverflow.com/questions/65913547/ionic-slot-attributes-are-deprecated-eslint-plugin-vue
  --   init_options = { config = { vetur = { validation = { template = false } } } },
  -- }, -- Vue
  -- lemminx = {}, -- XML
  -- yamlls = {}, -- YAML
  -- zls = {}, -- Zig
}

local stop_lsp_fmt = {
  tsserver = true,
  vuels = true,
  eslint = true,
  pylsp = true,
}

local lsp_list = vim.tbl_keys(servers)

M.config = function()
  require("neodev").setup({})
  local lspconfig = require("lspconfig")

  require("mason-lspconfig").setup({
    ensure_installed = lsp_list,
    automatic_installation = true,
  })

  local lsp_base = require("lsp-config.base")
  lsp_base.setup({})
  local global_opts = {
    capabilities = lsp_base.capabilities(),
    on_attach = function(client, bufnr)
      if stop_lsp_fmt[client.name] ~= nil then
        client.server_capabilities.documentFormattingProvider = false
      end
      lsp_base.lsp_keymaps(bufnr)
    end,
  }
  for server_name, server_opt in pairs(servers) do
    local is_opt, file_opt = pcall(require, "lsp-config.settings." .. server_name)
    local opts = vim.tbl_deep_extend("force", global_opts, is_opt and file_opt or {}, server_opt or {})
    lspconfig[server_name].setup(opts)
  end
end

return M
