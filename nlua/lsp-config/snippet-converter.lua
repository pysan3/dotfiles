-- SnippetConverter uses semantic versioning. Example: use version = "1.*" to avoid breaking changes on version 1.
-- Uncomment the next line to follow stable releases only.
-- version = "*",
local template = {
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

require("snippet_converter").setup({
  templates = { template },
  -- To change the default settings (see configuration section in the documentation)
  -- settings = {},
})
