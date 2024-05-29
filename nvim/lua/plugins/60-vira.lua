return {
  "n0v1c3/vira",
  build = "./install.sh",
  cmd = { "ViraServers", "ViraIssues", "ViraReport", "ViraFilterEdit" },
  keys = {
    { vim.g.personal_options.prefix.vira .. "f", "ViraFilterEdit" },
    { vim.g.personal_options.prefix.vira .. "r", "ViraReport" },
  },
}
