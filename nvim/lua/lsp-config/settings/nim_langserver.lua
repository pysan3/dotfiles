return {
  settings = {
    ["projectMapping"] = {
      {
        ["projectPath"] = vim.fs.dirname(vim.fn.getcwd()) .. ".nim",
        ["fileRegex"] = ".*\\.nim",
      },
    },
  },
}
