require("config-local").setup({
  config_files = { -- Config file patterns to load (lua supported)
    ".vim/local.vim",
    "./.vim/local.vim",
    ".vim/local.lua",
    "./.vim/local.lua",
  },
  hashfile = vim.fn.stdpath("data") .. "/config_local", -- Where the plugin keeps files data
  autocommands_create = true, -- Create autocommands (VimEnter, DirectoryChanged)
  commands_create = true, -- Create commands (ConfigSource, ConfigEdit, ConfigTrust, ConfigIgnore)
  silent = true, -- Disable plugin messages (Config loaded/ignored)
})
