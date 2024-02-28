local function dap_keybind(key, func_name, args, raw_rhs, no_prefix)
  return {
    no_prefix and key or (vim.g.personal_options.prefix.dap .. key),
    raw_rhs and func_name or function()
      local func = require("dap")[func_name]
      if type(args) == "function" then
        return func(args())
      else
        return args and func(args) or func()
      end
    end,
    desc = raw_rhs or ("DAP: " .. func_name),
  }
end

---@type LazyPluginSpec
return {
  "rcarriga/nvim-dap-ui",
  dependencies = {
    "nvim-dap",
  },
  keys = {
    dap_keybind("<F5>", "continue", nil, nil, true),
    dap_keybind("b", "toggle_breakpoint"),
    dap_keybind("B", "set_breakpoint", function()
      return vim.fn.input("Breakpoint condition: ")
    end),
    dap_keybind("e", "set_exception_breakpoints", { "all" }),
    dap_keybind("r", "run_last"),
    dap_keybind("R", "clear_breakpoints"),
    dap_keybind("g", "session"),
    dap_keybind("a", function()
      require("debugHelper").attach()
    end, nil, "debugHelper.attach()"),
    dap_keybind("A", function()
      require("debugHelper").attachToRemote()
    end, nil, "debugHelper.attachToRemote()"),
    dap_keybind("pn", function()
      require("dap-python").test_method()
    end, nil, "dap_python.test_method"),
    dap_keybind("pf", function()
      require("dap-python").test_class()
    end, nil, "dap_python.test_class"),
    dap_keybind("ps", function()
      require("dap-python").debug_selection()
    end, nil, "dap_python.debug_selection"),
  },
  opts = {
    icons = { expanded = "", collapsed = "󰐊" },
    mappings = {
      expand = { "<CR>", "l" },
      open = "o",
      remove = "d",
      edit = "e",
      repl = "r",
      toggle = "t",
    },
    expand_lines = true,
    layouts = {
      {
        elements = {
          { id = "scopes", size = 0.25 },
          { id = "breakpoints", size = 0.25 },
          { id = "stacks", size = 0.25 },
          { id = "watches", size = 00.25 },
        },
        size = 40,
        position = "left",
      },
      {
        elements = { "repl" },
        size = 10,
        position = "bottom",
      },
    },
    floating = {
      max_height = nil,
      max_width = nil,
      border = "single",
      mappings = {
        close = { "q", "<Esc>" },
      },
    },
    windows = { indent = 1 },
    render = {
      max_type_length = nil,
    },
  },
}
