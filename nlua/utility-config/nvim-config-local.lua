require("config-local").setup({
  config_files = { "./.vim/local.vim", "./.vim/local.lua" }, -- Config file patterns to load (lua supported)
  hashfile = vim.fn.stdpath("data") .. "/config_local", -- Where the plugin keeps files data
  autocommands_create = true, -- Create autocommands (VimEnter, DirectoryChanged)
  commands_create = true, -- Create commands (ConfigSource, ConfigEdit, ConfigTrust, ConfigIgnore)
  silent = true, -- Disable plugin messages (Config loaded/ignored)
})
