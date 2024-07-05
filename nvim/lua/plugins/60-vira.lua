return {
  "n0v1c3/vira",
  build = vim.fn.fnamemodify(vim.g.python3_host_prog, ":h") .. "/pip install --user -r requirements.txt",
  cmd = { "ViraServers", "ViraIssues", "ViraReport", "ViraFilterEdit", "ViraRefresh" },
  keys = {
    { vim.g.personal_options.prefix.vira .. "f", "ViraFilterEdit" },
    { vim.g.personal_options.prefix.vira .. "r", "ViraReport" },
  },
}
