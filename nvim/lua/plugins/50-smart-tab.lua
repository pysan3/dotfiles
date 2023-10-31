return {
  "boltlessengineer/smart-tab.nvim",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  version = false,
  dev = true,
  event = "InsertEnter",
  keys = {
    { "<C-e>", "<Plug>(smart-tab)", mode = { "s", "i" }, remap = true },
  },
  opts = {
    mapping = false,
  },
}
