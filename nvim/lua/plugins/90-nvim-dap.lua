-- keybindings
local dapui_cache_keybinds = {}
-- stylua: ignore start
local dapui_only_keybinds = {
  { "n", function() require("dap").run_to_cursor() end, "dap.run_to_cursor()" },
  { "x", function() require("dap").disconnect() end, "dap.disconnect()" },
  { "l", function() require("dap").step_into() end, "dap.step_into()" },
  { "j", function() require("dap").step_over() end, "dap.step_over()" },
  { "k", function() require("dap").step_out() end, "dap.step_out()" },
  { "b", function() require("dap").step_back() end, "dap.step_back()" },
  { "t", function() require("dap").repl.toggle() end, "dap.repl.toggle()" },
  { "q", function() require("dap").terminate() end, "dap.terminate()" },
  { "i", function() require("dap.ui.widgets").hover() end, "dap_widgets.hover()" },
  { "?", function() require("dap.ui.widgets").centered_float(require("dap.ui.widgets").scopes) end,
    "dap_widgets.centered_float(dap_widgets.scopes)" },
  { "e", function() require("dap").up() end, "dap.up()" },
  { "d", function() require("dap").down() end, "dap.down()" },
}
-- stylua: ignore end

local function dapui_set_keybinds()
  for _, buf in pairs(vim.api.nvim_list_bufs()) do
    for _, keymap in pairs(vim.api.nvim_buf_get_keymap(buf, "n")) do
      if dapui_only_keybinds[keymap.lhs] ~= nil then
        table.insert(dapui_cache_keybinds, keymap)
        vim.keymap.del("n", keymap.lhs, { buffer = buf })
      end
    end
    for _, keyinfo in ipairs(dapui_only_keybinds) do
      vim.keymap.set("n", "<leader>" .. keyinfo[1], keyinfo[2], { buffer = buf, desc = keyinfo[3] })
    end
  end
end

local function dapui_restore_keybinds()
  for _, buf in pairs(vim.api.nvim_list_bufs()) do
    for _, keyinfo in ipairs(dapui_only_keybinds) do
      pcall(vim.keymap.del, "n", "<leader>" .. keyinfo[1], { buffer = buf })
    end
    for _, keymap in ipairs(dapui_cache_keybinds) do
      vim.keymap.set("n", keymap.lhs, keymap, { buffer = buf, desc = keymap.desc })
    end
    dapui_cache_keybinds = {}
  end
end

return {
  "mfussenegger/nvim-dap",
  dependencies = {
    {
      "mfussenegger/nvim-dap-python",
      config = function()
        require("dap-python").setup()
      end,
    },
    {
      "theHamsta/nvim-dap-virtual-text",
      opts = {},
    },
  },
  keys = {
    {
      vim.g.personal_options.prefix.dap .. "k",
      function(...)
        require("dapui").eval(...)
      end,
      desc = "dapui.eval",
      mode = { "n", "v" },
    },
  },
  init = function()
    vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "DiagnosticError" })
    vim.fn.sign_define("DapBreakpointCondition", { text = "󰟃", texthl = "DiagnosticError" })
    vim.fn.sign_define("DapBreakpointRejected", {
      text = "",
      texthl = "DiagnosticHint",
      linehl = "",
      numhl = "",
    })
    vim.fn.sign_define("DapStopped", {
      text = "",
      texthl = "DiagnosticInfo",
      linehl = "DiagnosticUnderlineInfo",
      numhl = "DiagnosticInfo",
    })
  end,
  config = function()
    local dap = require("dap")
    dap.defaults.fallback.terminal_win_cmd = "20split new"
    dap.listeners.after.event_initialized["dapui_config"] = function()
      dapui_set_keybinds()
      require("dapui").open({})
    end
    dap.listeners.before.event_terminated["dapui_config"] = function()
      require("dapui").close({})
      dapui_restore_keybinds()
    end
    dap.listeners.before.event_exited["dapui_config"] = function()
      require("dapui").close({})
      dapui_restore_keybinds()
    end
  end,
}
