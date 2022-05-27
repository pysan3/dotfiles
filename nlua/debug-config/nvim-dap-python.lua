local dap_python = require("dap-python")

dap_python.setup(string.format("%s/debugpy/bin/python", os.getenv("XDG_DATA_HOME")))

vim.keymap.set("n", "<leader>dn", dap_python.test_method)
vim.keymap.set("n", "<leader>df", dap_python.test_class)
vim.keymap.set("v", "<leader>ds", dap_python.debug_selection)
