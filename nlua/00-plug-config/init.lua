local install_path = vim.fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  local git_path = "https://github.com/wbthomason/packer.nvim"
  PACKER_BOOTSTRAP = vim.fn.system({ "git", "clone", "--depth", "1", git_path, install_path })
  print("Installing packer close and reopen Neovim...")
  vim.cmd([[packadd packer.nvim]])
end
local compile_path = string.format("%s/%s", vim.fn.stdpath("cache"), "plugin/packer_compiled.lua")
local packer = require("packer")

packer.reset()
packer.init({
  compile_path = compile_path,
  display = { open_fn = require("packer.util").float },
  autoremove = true,
})
if vim.fn.filereadable(compile_path) ~= 0 then
  vim.cmd(string.format("luafile %s", compile_path))
end

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

  load_sub_dirs("10-color-config")
  load_sub_dirs("10-ts-config")
  load_sub_dirs("11-uiline-config")
  load_sub_dirs("20-utility-config")
  load_sub_dirs("20-register-config")
  load_sub_dirs("25-telescope-config")
  load_sub_dirs("30-git-config")
  load_sub_dirs("40-terminal-config")
  load_sub_dirs("50-operations-config")
  load_sub_dirs("50-command-config")
  load_sub_dirs("60-lang-config")
  load_sub_dirs("70-cmp-config")
  load_sub_dirs("70-lsp-config")
  load_sub_dirs("80-debug-config")

  if PACKER_BOOTSTRAP then
    packer.sync()
  end
end)
