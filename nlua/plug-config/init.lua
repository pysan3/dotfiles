local install_path = vim.fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  local git_path = "https://github.com/wbthomason/packer.nvim"
  PACKER_BOOTSTRAP = vim.fn.system({ "git", "clone", "--depth", "1", git_path, install_path })
  print("Installing packer close and reopen Neovim...")
  vim.cmd([[packadd packer.nvim]])
end

local packer = require("packer")
return packer.startup(function(use)
  -- stylua: ignore start
  local function load_sub_dirs(dir_name)
    local load_ok, plugin_table = pcall(require, dir_name)
    if not load_ok then return false end
    for _, plugin in ipairs(plugin_table.install or {}) do use(plugin) end
    for _, plugin in ipairs(plugin_table.setup or {}) do
      if type(plugin) ~= "table" then plugin = { plugin } end
      plugin.config = string.format([[require("%s.%s")]], dir_name, plugin[1]:gsub(".*/([^.]*)%.?.*$", "%1"))
      use(plugin)
    end
  end

  -- stylua: ignore end
  use({ "lewis6991/impatient.nvim" })
  require("impatient")

  use({ "wbthomason/packer.nvim" }) -- Have packer manage itself
  use({ "nvim-lua/popup.nvim" }) -- An implementation of the Popup API from vim in Neovim
  use({ "nvim-lua/plenary.nvim" }) -- Useful lua functions used lots of plugins

  load_sub_dirs("ts-config")
  load_sub_dirs("uiline-config")
  load_sub_dirs("utility-config")
  load_sub_dirs("register-config")
  load_sub_dirs("git-config")
  load_sub_dirs("terminal-config")
  load_sub_dirs("operations-config")
  load_sub_dirs("command-config")
  load_sub_dirs("lang-config")
  load_sub_dirs("cmp-config")
  load_sub_dirs("lsp-config")
  load_sub_dirs("debug-config")

  if PACKER_BOOTSTRAP then
    packer.sync()
  end
end)
