local luasnip = require("luasnip")

require("luasnip.loaders.from_vscode").lazy_load()
require("luasnip.loaders.from_lua").load({ paths = vim.fn.stdpath("config") .. "/lua/snippets/" })
vim.api.nvim_create_user_command("LuaSnipEdit", function()
  require("luasnip.loaders").edit_snippet_files({
    format = function(file, source_name)
      print(vim.inspect(file))
      print(vim.inspect(source_name))
    end,
  })
end, {})

-- Virtual Text
local types = require("luasnip.util.types")
luasnip.config.set_config({
  history = true, --keep around last snippet local to jump back
  updateevents = "TextChanged,TextChangedI", --update changes as you type
  enable_autosnippets = true,
  ext_opts = {
    [types.choiceNode] = {
      active = {
        virt_text = { { "o", "GruvboxOrange" } },
      },
    },
  },
})
