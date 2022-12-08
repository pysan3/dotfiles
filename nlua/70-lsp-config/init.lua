local function onhold(plugin)
  plugin.event = { "FocusLost", "CursorHold" }
  return plugin
end

return {
  {
    "williamboman/mason.nvim",
    requires = {
      { "williamboman/mason-lspconfig.nvim", module = { "mason-lspconfig" } },
      onhold({ "WhoIsSethDaniel/mason-tool-installer.nvim", module = { "mason-tool-installer" } }),
      { "hrsh7th/cmp-nvim-lsp", module = { "cmp_nvim_lsp" } },
      { "neovim/nvim-lspconfig", module = { "lspconfig" } }, -- enable LSP
      onhold({
        "jose-elias-alvarez/null-ls.nvim", -- linter
        module = { "null-ls" },
        cmd = { "NullLsLog", "NullLsInfo" },
      }),
      { "glepnir/lspsaga.nvim", branch = "main", module = { "lspsaga" }, cmd = { "Lspsaga", "LSoutlineToggle" } },
      { "andrewferrier/textobj-diagnostic.nvim", module = { "textobj-diagnostic" } },
      { "folke/neodev.nvim", module = { "neodev" } }, -- sumneko_lua extension for nvim development
    },
  },
  {
    "ray-x/lsp_signature.nvim", -- show hints when writing function arguments
    wants = { "mason.nvim" },
    event = { "InsertEnter", "FocusLost", "CursorHold" },
  },
  {
    "j-hui/fidget.nvim", -- print linting progress
    wants = { "mason.nvim" },
    event = { "BufRead", "FocusLost", "CursorHold" },
  },
  {
    "kevinhwang91/nvim-ufo",
    event = { "BufRead" },
    requires = { { "kevinhwang91/promise-async", opt = true } },
    wants = { "promise-async" },
  },
}
