require("lspconfig")
local lsp_installer = require("nvim-lsp-installer")
local lsp_base = require("lsp-config.n-lsp-base")

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
  eslint = {}, -- ESLint
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
  grammarly = {}, -- Grammarly
  -- graphql = {}, -- GraphQL
  -- groovyls = {}, -- Groovy
  html = {}, -- HTML
  -- hls = {}, -- Haskell
  jsonls = {}, -- JSON
  -- jdtls = {}, -- Java
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
  -- pylsp = {}, -- Python
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
  vuels = {}, -- Vue
  -- lemminx = {}, -- XML
  -- yamlls = {}, -- YAML
  -- zls = {}, -- Zig
}

local stop_lsp_fmt = {
  tsserver = 1,
  pylsp = 1,
}

local opts = {
  capabilities = lsp_base.capabilities,
  on_attach = function(client, bufnr)
    if stop_lsp_fmt[client.name] ~= nil then
      client.resolved_capabilities.document_formatting = false
    end
    lsp_base.lsp_keymaps(bufnr)
    lsp_base.lsp_highlight_document(client)
  end,
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

lsp_base.setup()
require("lsp-config.n-lsp-null")
require("fidget").setup({
  text = {
    -- spinner list: https://github.com/j-hui/fidget.nvim/blob/main/lua/fidget/spinners.lua
    spinner = "dots_pulse", -- dots, line, dots_bounce, ...
    done = "",
    commenced = "",
    completed = "",
  },
  timer = {
    fidget_decay = 500,
    task_decay = 500,
  },
  fmt = {
    fidget = function(fig_name, spinner)
      require("my-plugins.autosave-session").add_win_open_timer(500)
      return string.format("%s %s", spinner, fig_name)
    end,
    task = function(task_name, msg, perc)
      require("my-plugins.autosave-session").add_win_open_timer(500)
      return string.format("%s%s %s", msg, perc and string.format(" %s%%", perc) or "", task_name)
    end,
  },
})
