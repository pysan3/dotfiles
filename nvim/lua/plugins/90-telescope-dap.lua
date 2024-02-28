local function dap_telescope_keybind(key, func_name, args)
  return {
    vim.g.personal_options.prefix.telescope .. "d" .. key,
    function()
      require("telescope").extensions.dap[func_name](args)
    end,
    desc = "DAP-telescope: " .. func_name,
  }
end

---@type LazyPluginSpec
return {
  "nvim-telescope/telescope-dap.nvim",
  dependencies = {
    "nvim-dap-ui",
    "telescope.nvim",
  },
  keys = {
    dap_telescope_keybind("m", "commands", {}),
    dap_telescope_keybind("c", "configurations", {}),
    dap_telescope_keybind("b", "list_breakpoints", {}),
    dap_telescope_keybind("v", "variables", {}),
    dap_telescope_keybind("f", "frames", {}),
  },
  config = function()
    require("telescope").load_extension("dap")
  end,
}
