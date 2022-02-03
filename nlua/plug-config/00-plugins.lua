local fn = vim.fn
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
  PACKER_BOOTSTRAP = fn.system({
    "git",
    "clone",
    "--depth",
    "1",
    "https://github.com/wbthomason/packer.nvim",
    install_path,
  })
  print("Installing packer close and reopen Neovim...")
  vim.cmd([[packadd packer.nvim]])
end

vim.cmd([[
augroup packer_user_config
  autocmd!
  autocmd BufWritePost 00-plugins.lua source <afile> | PackerSync
augroup end
]])

local packer = require("packer")

-- Have packer use a popup window
-- packer.init {
--   display = {
--     open_fn = function()
--       return require("packer.util").float { border = "rounded" }
--     end,
--   },
-- }

return packer.startup(function(use)
  use("wbthomason/packer.nvim") -- Have packer manage itself
  use("nvim-lua/popup.nvim") -- An implementation of the Popup API from vim in Neovim
  use("nvim-lua/plenary.nvim") -- Useful lua functions used ny lots of plugins

  -- git
  use("lewis6991/gitsigns.nvim")
  use("TimUntersberger/neogit")
  use("rhysd/conflict-marker.vim")
  use("tpope/vim-fugitive")

  -- telescope
  use("BurntSushi/ripgrep")
  use("nvim-telescope/telescope.nvim")
  use({ "nvim-telescope/telescope-fzf-native.nvim", run = "make" })
  use("nvim-telescope/telescope-media-files.nvim")

  -- treesitter
  use({ "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" })

  -- cmp and lsp
  require("lsp-config.n-cmp-plug").cmp_use(use)
  use("windwp/nvim-autopairs")

  -- others
  use("rcarriga/nvim-notify")
  use("nixon/vim-vmath")
  use("google/vim-searchindex") -- show how many occurrence [n/N]
  use("bronson/vim-trailing-whitespace") -- highlight trailing whitespace
  use("Yggdroot/indentLine") -- show indent line with |
  -- use * in visual mode
  use("inkarkat/vim-ingo-library")
  use("inkarkat/vim-SearchHighlighting")
  -- Custom operations
  use("christoomey/vim-titlecase")
  use("christoomey/vim-sort-motion")
  use("tpope/vim-surround")
  use("terryma/vim-expand-region")
  use("vim-scripts/ReplaceWithRegister")
  use("michaeljsmith/vim-indent-object")
  -- dragviduals
  use("zirrostig/vim-schlepp")
  -- undo tree
  use("mbbill/undotree")
  -- file explorer
  use("kyazdani42/nvim-web-devicons")
  use("kyazdani42/nvim-tree.lua")

  -- startify
  use("mhinz/vim-startify")
  -- zenmode
  use("folke/zen-mode.nvim")

  -- terminal
  use("akinsho/toggleterm.nvim")

  -- color theme
  use("lunarvim/darkplus.nvim")
  use("joshdick/onedark.vim")
  use("ulwlu/elly.vim")
  use("tomasiser/vim-code-dark")
  use("arcticicestudio/nord-vim")
  use("chriskempson/vim-tomorrow-theme")
  -- Airline
  use("vim-airline/vim-airline")
  use("vim-airline/vim-airline-themes")

  -- language specific
  use("pixelneo/vim-python-docstring")
  use({
    "heavenshell/vim-jsdoc",
    ft = { "javascript", "javascript.jsx", "typescript" },
    run = "make install",
  })
  use("uarun/vim-protobuf")
  use("tikhomirov/vim-glsl")
  use("lervag/vimtex")
  use("godlygeek/tabular")
  use({ "cespare/vim-toml", branch = "main" })
  use("elzr/vim-json")
  use("plasticboy/vim-markdown")
  use({ "iamcco/markdown-preview.nvim", run = "cd app && npm install" })

  if PACKER_BOOTSTRAP then
    require("packer").sync()
  end
end)
