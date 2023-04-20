return {
  "smjonas/live-command.nvim", -- visualize the output of `:norm` command before executing
  opts = {
    commands = {
      Norm = { cmd = "norm" },
    },
  },
}
