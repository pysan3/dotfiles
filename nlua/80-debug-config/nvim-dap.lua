local dap = require("dap")

dap.defaults.fallback.terminal_win_cmd = "20split new"
vim.fn.sign_define("DapBreakpoint", { text = "🟥", texthl = "LspDiagnosticsSignError", linehl = "", numhl = "" })
vim.fn.sign_define("DapBreakpointRejected", {
  text = "🟦",
  texthl = "LspDiagnosticsSignHint",
  linehl = "",
  numhl = "",
})
vim.fn.sign_define("DapStopped", {
  text = "⭐️",
  texthl = "LspDiagnosticsSignInformation",
  linehl = "DiagnosticUnderlineInfo",
  numhl = "LspDiagnosticsSignInformation",
})

-- python
local dap_python = require("dap-python")
dap_python.setup(string.format("%s/mason/packages/debugpy/venv/bin/python", vim.fn.stdpath("data")))
