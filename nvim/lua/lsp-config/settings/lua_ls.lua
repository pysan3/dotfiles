local libs = vim.api.nvim_get_runtime_file("", true)
libs[#libs + 1] = vim.g.personal_module.luarocks_base
libs[#libs + 1] = vim.fn.fnamemodify("lua_modules/share/lua/5.1", ":p")
libs[#libs + 1] = [[${3rd}/busted/library]]
libs[#libs + 1] = [[${3rd}/luassert/library]]

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
