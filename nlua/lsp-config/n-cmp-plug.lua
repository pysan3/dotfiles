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
  use({
    "SirVer/ultisnips",
    requires = { { "honza/vim-snippets", rtp = "." } },
    config = function()
      vim.g.UltiSnipsExpandTrigger = "<Plug>(ultisnips_expand)"
      vim.g.UltiSnipsJumpForwardTrigger = "<Plug>(ultisnips_jump_forward)"
      vim.g.UltiSnipsJumpBackwardTrigger = "<Plug>(ultisnips_jump_backward)"
      vim.g.UltiSnipsListSnippets = "<c-x><c-s>"
      vim.g.UltiSnipsRemoveSelectModeMappings = 0
    end,
  })
  use("quangnguyen30192/cmp-nvim-ultisnips")

  -- LSP
  use("neovim/nvim-lspconfig") -- enable LSP
  use("williamboman/nvim-lsp-installer") -- language server installer
  use("jose-elias-alvarez/null-ls.nvim") -- linter

  -- others
  use("numToStr/Comment.nvim")
  use("JoosepAlviste/nvim-ts-context-commentstring")
end

return M
