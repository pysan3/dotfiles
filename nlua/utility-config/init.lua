return {
  setup = {
    "rcarriga/nvim-notify", -- notifications
    "mbbill/undotree", -- undo tree
    "klen/nvim-config-local", -- load local config
    "pysan3/autosession.nvim", -- restore previous session
    -- "~/Git/autosession.nvim",
    "mhinz/vim-startify", -- startify
    "preservim/tagbar",
    {
      "nvim-telescope/telescope.nvim",
      requires = {
        "BurntSushi/ripgrep",
        { "nvim-telescope/telescope-fzf-native.nvim", run = "make" },
        "nvim-telescope/telescope-media-files.nvim",
      },
    },
  },
  install = {
    "google/vim-searchindex", -- show how many occurrence [n/N]
    "AndrewRadev/bufferize.vim",
    { "inkarkat/vim-SearchHighlighting", requires = { "inkarkat/vim-ingo-library" } }, -- search word under corsor
  },
}
