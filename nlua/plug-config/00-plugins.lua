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
  use("bronson/vim-trailing-whitespace") -- highlight trailing whitespace
  use("Yggdroot/indentLine") -- show indent line with |
  -- better search
  use("inkarkat/vim-ingo-library")
  use("inkarkat/vim-SearchHighlighting")
  use("google/vim-searchindex") -- show how many occurrence [n/N]
  -- Custom operations
  use("tpope/vim-repeat") -- better repetition
  use("christoomey/vim-titlecase") -- gzz
  use("christoomey/vim-sort-motion") -- gs<motion> eg. gs2j => sort 3 lines
  use("terryma/vim-expand-region") -- + to expand, _ to shrink
  use("vim-scripts/ReplaceWithRegister") -- {Visual}["x]gr - replace {Visual} with register x
  use("unblevable/quick-scope") -- highlights f, t, F, T
  use("justinmk/vim-sneak") -- s, S to jump anywhere
  -- select objects
  use("michaeljsmith/vim-indent-object") -- ai, ii, aI, iI: text object of same indent (i; above, a; above and below)
  use("tpope/vim-surround") -- s is motion, ys to add
  use("PeterRincker/vim-argumentative")
  use("wellle/targets.vim")
  -- dragviduals
  use("zirrostig/vim-schlepp")
  -- undo tree
  use("mbbill/undotree")
  -- file explorer
  use("kyazdani42/nvim-web-devicons")
  -- use("kyazdani42/nvim-tree.lua")
  use({ "kyazdani42/nvim-tree.lua", commit = "3f4ed9b6c2598ab8304186486a05ae7a328b8d49" })
  -- colorizer
  use("norcalli/nvim-colorizer.lua")

  -- startify
  use("mhinz/vim-startify")
  -- quickfix list
  use("romainl/vim-qf")
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
  use({ "akinsho/bufferline.nvim", requires = "kyazdani42/nvim-web-devicons" })
  use({ "nvim-lualine/lualine.nvim", requires = { "kyazdani42/nvim-web-devicons", opt = true } })

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
  use("plasticboy/vim-markdown")
  use({ "iamcco/markdown-preview.nvim", run = "cd app && npm install" })

  if PACKER_BOOTSTRAP then
    require("packer").sync()
  end
end)
