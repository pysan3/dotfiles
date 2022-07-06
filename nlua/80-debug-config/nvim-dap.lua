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

-- dap global keymaps (runs everywhere)
local dap_prefix = "<leader>d"
vim.keymap.set("n", "<F5>", function()
  dap.continue()
end, { desc = "dap.continue()" })
vim.keymap.set("n", dap_prefix .. "b", function()
  dap.toggle_breakpoint()
end, { desc = "dap.toggle_breakpoint()" })
vim.keymap.set("n", dap_prefix .. "B", function()
  dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
end, { desc = "dap.set_breakpoint(vim.fn.input(Breakpoint condition: ))" })
vim.keymap.set("n", dap_prefix .. "e", function()
  dap.set_exception_breakpoints({ "all" })
end, { desc = "dap.set_exception_breakpoints({ all })" })
vim.keymap.set("n", dap_prefix .. "r", function()
  dap.run_last()
end, { desc = "dap.run_last()" })
vim.keymap.set("n", dap_prefix .. "R", function()
  dap.clear_breakpoints()
end, { desc = "dap.clear_breakpoints()" })
vim.keymap.set("n", dap_prefix .. "g", function()
  dap.session()
end, { desc = "dap.session()" })
vim.keymap.set("n", dap_prefix .. "a", function()
  require("debugHelper").attach()
end, { desc = "debugHelper.attach()" })
vim.keymap.set("n", dap_prefix .. "A", function()
  require("debugHelper").attachToRemote()
end, { desc = "debugHelper.attachToRemote()" })

-- language specific configs
-- follow: https://github.com/Pocco81/dap-buddy.nvim/issues/71 for more updates

-- python
local dap_python = require("dap-python")
dap_python.setup(os.getenv("XDG_DATA_HOME") .. "/debugpy/bin/python")
local dap_prefix_python = dap_prefix .. "p"
vim.keymap.set("n", dap_prefix_python .. "n", dap_python.test_method, { desc = "dap_python.test_method" })
vim.keymap.set("n", dap_prefix_python .. "f", dap_python.test_class, { desc = "dap_python.test_class" })
vim.keymap.set("v", dap_prefix_python .. "s", dap_python.debug_selection, { desc = "dap_python.debug_selection" })
