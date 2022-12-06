return {
  {
    "nvim-telescope/telescope-dap.nvim",
    wants = { "nvim-dap", "telescope.nvim" },
  },
  {
    "mfussenegger/nvim-dap",
    module = { "dap" },
    requires = { { "mfussenegger/nvim-dap-python", opt = true } },
    wants = { "nvim-dap-python" },
  },
  {
    "rcarriga/nvim-dap-ui",
    module = { "dapui" },
    after = { "nvim-dap" },
  },
  {
    "theHamsta/nvim-dap-virtual-text",
    after = { "nvim-dap", "nvim-dap-ui" },
  },
}
