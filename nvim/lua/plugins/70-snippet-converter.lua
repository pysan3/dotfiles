local M = {
  "smjonas/snippet-converter.nvim", -- Use to convert snippet files. See `nlua/lsp-config/snippet-converter.lua`
  enabled = false,
}

M.snippet_info = {
  -- name = "t1", (optionally give your template a name to refer to it in the `ConvertSnippets` command)
  sources = {
    ultisnips = {
      -- ...or use absolute paths on your system.
      vim.fn.stdpath("config") .. "/UltiSnips",
    },
  },
  output = {
    -- Specify the output formats and paths
    snipmate = {
      vim.fn.stdpath("config") .. "/snippets",
    },
    vscode_luasnip = {
      vim.fn.stdpath("config") .. "/luasnip/json",
    },
  },
}

M.config = function()
  require("snippet_converter").setup({
    templates = { M.snippet_info },
    -- To change the default settings (see configuration section in the documentation)
    -- settings = {},
  })
end

return M
