return {
  "boltlessengineer/smart-tab.nvim",
  dependencies = { "nvim-treesitter" },
  version = false,
  event = "InsertEnter",
  keys = {
    { "<C-e>", "<Plug>(smart-tab)", mode = { "s", "i" }, remap = true },
  },
  opts = {
    mapping = false,
  },
}
