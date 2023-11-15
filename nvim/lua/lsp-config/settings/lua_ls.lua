local libs = vim.api.nvim_get_runtime_file("", true)
libs[#libs + 1] = vim.g.personal_module.luarocks_base
libs[#libs + 1] = [[${3rd}/busted/library]]

return {
  settings = {
    Lua = {
      workspace = {
        library = libs,
        checkThirdParty = "Disable",
      },
    },
  },
}
