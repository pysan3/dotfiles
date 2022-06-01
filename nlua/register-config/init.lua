return {
  install = {
    "vim-scripts/ReplaceWithRegister", -- {Visual}["x]gr - replace {Visual} with register x
  },
  setup = {
    {
      "AckslD/nvim-neoclip.lua",
      requires = {
        { "tami5/sqlite.lua", module = "sqlite" },
        { "nvim-telescope/telescope.nvim" },
      },
    },
  },
}
