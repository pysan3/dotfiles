local dapui = require("dapui")

dapui.setup({
  icons = { expanded = "▾", collapsed = "▸" },
  mappings = {
    -- Use a table to apply multiple mappings
    expand = { "<CR>", "l" },
    open = "o",
    remove = "d",
    edit = "e",
    repl = "r",
    toggle = "t",
  },
  -- Expand lines larger than the window
  -- Requires >= 0.7
  expand_lines = vim.fn.has("nvim-0.7"),
  layouts = {
    {
      -- You can change the order of elements in the sidebar
      elements = {
        -- Provide as ID strings or tables with "id" and "size" keys
        {
          id = "scopes",
          size = 0.25, -- Can be float or integer > 1
        },
        { id = "breakpoints", size = 0.25 },
        { id = "stacks", size = 0.25 },
        { id = "watches", size = 00.25 },
      },
      size = 40,
      position = "left", -- Can be "left", "right", "top", "bottom"
    },
    {
      elements = { "repl" },
      size = 10,
      position = "bottom", -- Can be "left", "right", "top", "bottom"
    },
  },
  floating = {
    max_height = nil, -- These can be integers or a float between 0 and 1.
    max_width = nil, -- Floats will be treated as percentage of your screen.
    border = "single", -- Border style. Can be "single", "double" or "rounded"
    mappings = {
      close = { "q", "<Esc>" },
    },
  },
  windows = { indent = 1 },
  render = {
    max_type_length = nil, -- Can be integer or nil.
  },
})

local dap = require("dap")
local dap_widgets = require("dap.ui.widgets")

-- keybindings
-- stylua: ignore start
local dapui_cache_keybinds = {}
local dapui_only_keybinds = {
  { lhs = "n", rhs = function() dap.run_to_cursor() end, desc = "dap.run_to_cursor()" },
  { lhs = "x", rhs = function() dap.disconnect() end, desc = "dap.disconnect()" },
  { lhs = "l", rhs = function() dap.step_into() end, desc = "dap.step_into()" },
  { lhs = "j", rhs = function() dap.step_over() end, desc = "dap.step_over()" },
  { lhs = "k", rhs = function() dap.step_out() end, desc = "dap.step_out()" },
  { lhs = "b", rhs = function() dap.step_back() end, desc = "dap.step_back()" },
  { lhs = "t", rhs = function() dap.repl.toggle() end, desc = "dap.repl.toggle()" },
  { lhs = "q", rhs = function() dap.terminate() end, desc = "dap.terminate()" },
  { lhs = "i", rhs = function() dap_widgets.hover() end, desc = "dap_widgets.hover()" },
  { lhs = "?", rhs = function() dap_widgets.centered_float(dap_widgets.scopes) end,
    desc = "dap_widgets.centered_float(dap_widgets.scopes)" },
  { lhs = "e", rhs = function() dap.up() end, desc = "dap.up()" },
  { lhs = "d", rhs = function() dap.down() end, desc = "dap.down()" },
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
    for _, keymap in ipairs(dapui_only_keybinds) do
      vim.keymap.set("n", "<leader>" .. keymap.lhs, keymap.rhs, { buffer = buf, desc = keymap.desc })
    end
  end
end

local function dapui_restore_keybinds()
  for _, buf in pairs(vim.api.nvim_list_bufs()) do
    for _, keymap in ipairs(dapui_only_keybinds) do
      pcall(vim.keymap.del, "n", "<leader>" .. keymap.lhs, { buffer = buf })
    end
    for _, keymap in ipairs(dapui_cache_keybinds) do
      vim.keymap.set("n", keymap.lhs, keymap, { buffer = buf, desc = keymap.desc })
    end
    dapui_cache_keybinds = {}
  end
end

-- auto function with dap
dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui_set_keybinds()
  dapui.open({})
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close({})
  dapui_restore_keybinds()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close({})
  dapui_restore_keybinds()
end
vim.keymap.set({ "n", "v" }, "<leader>dk", dapui.eval, { desc = "dapui.eval" })
