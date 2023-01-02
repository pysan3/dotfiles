---return filename to require plugin config
---@param pre string | any | nil: returns pre if not nil
---@param plugin_name string: name of plugin without extension
---@param dir_name string: dir name
---@param append string: string to append to plugin_name
local function check_setup_files(pre, plugin_name, dir_name, append)
  if pre ~= nil then
    return pre
  end
  local lua_file = string.format("%s.%s", dir_name, plugin_name .. append)
  return vim.g.personal_module.exists(lua_file, true) and string.format([[require("%s")]], lua_file) or nil
end

local install_path = vim.fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if not vim.g.personal_module.exists(install_path) then
  local git_path = "https://github.com/wbthomason/packer.nvim"
  PACKER_BOOTSTRAP = vim.fn.system({ "git", "clone", "--depth", "1", git_path, install_path })
  print("Installing packer close and reopen Neovim...")
  vim.cmd([[packadd packer.nvim]])
end
local compile_path = string.format("%s/%s", vim.fn.stdpath("cache"), "plugin/packer_compiled.lua")

local packer = nil

local function load_plugins(use)
  -- stylua: ignore start
  local function load_sub_dirs(dir_name)
    local load_ok, plugin_table = pcall(require, dir_name)
    if not load_ok then return false end
    if not vim.tbl_islist(plugin_table) then -- FIX: keep for backwards compatibility
      local tmp = {}
      tmp = vim.list_extend(tmp, plugin_table.install or {}) ---@diagnostic disable-line
      tmp = vim.list_extend(tmp, plugin_table.setup or {}) ---@diagnostic disable-line
      plugin_table = tmp
    end
    for _, plugin in ipairs(plugin_table) do
      if type(plugin) ~= "table" then
        plugin = { plugin }
      end
      local plugin_name = plugin[1]:gsub(".*/([^.]*)%.?.*/?$", "%1")
      plugin.setup = check_setup_files(plugin.setup, plugin_name, "99-plug-setup", "")
      plugin.setup = check_setup_files(plugin.setup, plugin_name, "99-plug-setup", "-setup")
      plugin.config = check_setup_files(plugin.config, plugin_name, dir_name, "")
      plugin.config = check_setup_files(plugin.config, plugin_name, dir_name, "-config")
      use(plugin)
    end
  end

  -- stylua: ignore end

  use({ "lewis6991/impatient.nvim" })
  use({ "dstein64/vim-startuptime" })
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
end

local function packer_call()
  if not packer then
    vim.cmd.packadd("packer.nvim")
    packer = require("packer")
    packer.init({
      compile_path = compile_path,
      compile_on_sync = true,
      profile = { enable = false, threshold = 1 },
      disable_commands = true,
      display = { open_fn = require("packer.util").float },
      autoremove = true,
    })
    packer.reset()

    load_plugins(packer.use)
    if PACKER_BOOTSTRAP then
      packer.sync()
    end
  end
  return packer
end

local function packer_run(method)
  return function(opts)
    packer_call()[method](opts)
  end
end

vim.api.nvim_create_user_command("PackerInstall", packer_run("install"), { desc = "[Packer] Install plugins" })
vim.api.nvim_create_user_command("PackerUpdate", packer_run("update"), { desc = "[Packer] Update plugins" })
vim.api.nvim_create_user_command("PackerClean", packer_run("clean"), { desc = "[Packer] Clean plugins" })
vim.api.nvim_create_user_command("PackerStatus", packer_run("status"), { desc = "[Packer] Output plugins status" })
vim.api.nvim_create_user_command("PackerCompile", function()
  packer_call()["compile"]("")
end, { desc = "[Packer] Output plugins status", nargs = "*" })
vim.api.nvim_create_user_command("PackerProfile", packer_run("profile_output"),
  { desc = "[Packer] Output plugins profile" })
vim.api.nvim_create_user_command("PackerSync", function()
  vim.notify("Sync started")
  packer_run("sync")()
end, { desc = "[Packer] Output plugins status" })
vim.api.nvim_create_user_command("PackerLoad", function(opts)
  local args = vim.split(opts.args, " ", {})
  table.insert(args, opts.bang)
  packer_run("loader")(unpack(opts))
end, { bang = true, complete = packer_run("loader_complete"), desc = "[Packer] Load plugins", nargs = "+" })

if vim.g.personal_module.exists(compile_path) then
  vim.cmd("luafile " .. compile_path)
end
