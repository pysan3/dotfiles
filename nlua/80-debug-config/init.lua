return {
  setup = {
    {
      "mfussenegger/nvim-dap",
      requires = {
        "mfussenegger/nvim-dap-python",
      },
    },
    {
      "rcarriga/nvim-dap-ui",
      after = { "nvim-dap" },
    },
    {
      "theHamsta/nvim-dap-virtual-text",
      after = { "nvim-dap" },
    },
  },
}
