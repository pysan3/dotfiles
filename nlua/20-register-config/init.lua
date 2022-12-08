return {
  {
    "AckslD/nvim-neoclip.lua",
    requires = {
      { "tami5/sqlite.lua", module = { "sqlite" } },
      { "nvim-telescope/telescope.nvim" },
    },
    wants = { "sqlite.lua", "telescope.nvim" },
    module = { "neoclip" },
  },
}
