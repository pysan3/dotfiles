local M = {}

vim.cmd([[
  augroup packer_lsp_config
    autocmd!
    autocmd BufWritePost n-cmp-plug.lua source <afile> | PackerSync
  augroup end
]])

M.cmp_use = function(use)
  -- cmp plugins
  use("hrsh7th/nvim-cmp") -- The completion plugin

  -- cmp completion engines
  use("hrsh7th/cmp-buffer") -- buffer completions
  use("hrsh7th/cmp-path") -- path completions
  use("hrsh7th/cmp-cmdline") -- cmdline completions
  use("hrsh7th/cmp-nvim-lsp")
  use("hrsh7th/cmp-nvim-lua") -- nvim lua config completion
  use("hrsh7th/cmp-calc")
  use("hrsh7th/cmp-emoji")
  use("f3fora/cmp-spell")
  use("uga-rosa/cmp-dictionary")

  -- snippets
  use("L3MON4D3/LuaSnip")
  use("saadparwaiz1/cmp_luasnip")
  use("rafamadriz/friendly-snippets") -- a bunch of snippets to use

  -- LSP
  use("neovim/nvim-lspconfig") -- enable LSP
  use("williamboman/nvim-lsp-installer") -- language server installer
  use("jose-elias-alvarez/null-ls.nvim") -- linter

  -- others
  use("numToStr/Comment.nvim")
  use("JoosepAlviste/nvim-ts-context-commentstring")
end

return M
