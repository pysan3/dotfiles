local M = {}

local basef = require("my-plugins.base-functions")
local plugin_name = "AutoSession Plugin"
local plugin_icon = ""
local plugin_commands = {
  AutoSessionRestore = "Restore previous session from `.session.vim`.",
  AutoSessionSave = "Create `.session.vim` to store current session.",
  AutoSessionAuto = "Update `.session.vim` if exists.",
  AutoSessionGlobal = "Resigter current session for vim-startify.",
  AutoSessionDelete = "Delete a global session.",
}

local echo = function(msg, level, ...)
  if not level then
    level = "info"
  end
  local opts = { ... }
  opts.title = opts.title or plugin_name
  opts.icon = opts.icon or plugin_icon
  basef.echo(msg, level, opts)
end

M.help = function()
  local str = "Available Commands:\n\n"
  for command, com_help in pairs(plugin_commands) do
    str = str .. "- " .. command .. ": " .. com_help .. "\n"
  end
  echo(str, "warn", { title = plugin_name .. " Help" })
end

local DEFAULT_OPTS = {
  disable_netrw = false,
  hijack_netrw = true,
  open_on_setup = false,
  open_on_tab = false,
  hijack_directories = {
    enable = true,
    auto_open = true,
  },
  auto_close = false,
  auto_reload_on_write = true,
  hijack_cursor = false,
  update_cwd = false,
  hide_root_folder = false,
  hijack_unnamed_buffer_when_opening = false,
  update_focused_file = {
    enable = false,
    update_cwd = false,
    ignore_list = {},
  },
  ignore_ft_on_setup = {},
  system_open = {
    cmd = nil,
    args = {},
  },
  diagnostics = {
    enable = false,
    show_on_dirs = false,
    icons = {
      hint = "",
      info = "",
      warning = "",
      error = "",
    },
  },
  filters = {
    dotfiles = false,
    custom_filter = {},
    exclude = {},
  },
  git = {
    enable = true,
    ignore = true,
    timeout = 400,
  },
  actions = {
    change_dir = {
      enable = true,
      global = vim.g.nvim_tree_change_dir_global == 1,
    },
    open_file = {
      quit_on_open = vim.g.nvim_tree_quit_on_open == 1,
      window_picker = {
        enable = vim.g.nvim_tree_disable_window_picker ~= 1,
        chars = vim.g.nvim_tree_window_picker_chars,
        exclude = vim.g.nvim_tree_window_picker_exclude,
      },
    },
  },
}

local function merge_options(opts)
  return vim.tbl_deep_extend("force", DEFAULT_OPTS, opts or {})
end

M.setup = function(opts)
  merge_options(opts)
  M.init_win_open_safe()
  if opts.msg ~= nil then
    echo(opts.msg)
  end
  if opts.restore_on_startup == true then
    M.RestoreSession()
  end
end

M.init_win_open_safe = function()
  if vim.g.autosession_win_opened == nil then
    vim.g.autosession_win_opened = 0
  end
end

M.add_win_open_timer = function(wait_for_ms, msg)
  M.add_win_open()
  vim.fn.timer_start(wait_for_ms, function()
    M.close_win_open(msg)
  end)
end

M.add_win_open = function(msg)
  M.init_win_open_safe()
  vim.g.autosession_win_opened = vim.g.autosession_win_opened + 1
  if msg ~= nil then
    echo(msg)
  end
end

M.close_win_open = function(msg)
  M.init_win_open_safe()
  vim.g.autosession_win_opened = vim.g.autosession_win_opened - 1
  if msg ~= nil then
    echo(msg)
  end
end

M.SaveSession = function(create_new_if_not_exist)
  local cwd = vim.fn.getcwd()
  if basef.FullPath(cwd) == basef.FullPath(vim.env.HOME) then
    echo("Currently working in $HOME directory. Not saving session.")
    return nil
  end
  local sessionpath = basef.FullPath(cwd .. "/.session.vim")
  if create_new_if_not_exist == true or basef.file_exist(sessionpath) then
    local wait_counter = 1000
    while vim.g.autosession_win_opened > 0 and wait_counter > 0 do
      wait_counter = wait_counter - 1
    end
    local confirm_msg = "May crush. Please wait until all Notification are gone. Continue? [Y/n]:"
    if vim.g.autosession_win_opened <= 0 or basef.Confirm(confirm_msg, "y", true) then
      vim.cmd("mksession! " .. sessionpath)
      echo(".session.vim created.")
    else
      echo("Aborted!", "error")
    end
  end
  return sessionpath
end

M.SaveGlobalSession = function()
  local cwd = vim.fn.getcwd()
  if not vim.g.startify_session_dir then
    echo("Please set `g:startify_session_dir`.\nAbort", "error")
    return false
  end
  vim.fn.mkdir(basef.FullPath(vim.g.startify_session_dir), "p")
  local dirname = basef.FullPath(vim.g.startify_session_dir) .. "/" .. basef.SessionName(cwd)
  local sessionpath = M.SaveSession(true)
  if not basef.file_exist(dirname) or basef.Confirm(dirname .. " exists. Overwrite? [y/N]:", "n", false) then
    io.popen("ln -sf " .. sessionpath .. " " .. dirname .. " >/dev/null 2>/dev/null"):close()
    if basef.file_exist(dirname) then
      echo("Saved session as: " .. dirname)
      return true
    else
      echo("Something went wrong.", "error")
      return false
    end
  end
  echo("Abort", "error")
  return false
end

M.RestoreSession = function()
  local cwd = vim.fn.getcwd()
  local sessionpath = basef.FullPath(cwd .. "/.session.vim")
  if not vim.fn.filereadable(sessionpath) then
    return false
  end
  if basef.file_exist(sessionpath) then
    vim.cmd("so " .. sessionpath)
  else
    print("AutoSession WARN: Last session not found. Run :AutoSessionSave to save session.")
    vim.cmd("redraws")
  end
  local current_session = basef.SessionName(cwd)
  for buf = 1, vim.fn.bufnr("$") do
    local bufname = vim.fn.bufname(buf)
    if string.match(bufname, "^.*/$") then
      vim.cmd("bd " .. bufname)
    elseif string.match(bufname, "^\\[.*\\]$") then
      vim.cmd("bd " .. bufname)
    elseif basef.SessionName(bufname) == current_session then
      vim.cmd("bd " .. bufname)
    end
  end
  return true
end

M.DeleteSession = function()
  local cwd = vim.fn.getcwd()
  local session_list = {}
  for line in vim.fn.globpath(basef.FullPath(vim.g.startify_session_dir), "[^_]*"):gmatch("([^\n]+)") do
    table.insert(session_list, line)
  end
  local session_len = #session_list
  local current = -1
  local current_session = basef.SessionName(cwd)
  if session_len == 0 then
    echo("No sessions to delete!\nNice and clean 😄")
    return false
  end
  for index, value in ipairs(session_list) do
    if basef.s_trim(basef.basename(value)):lower() == current_session:lower() then
      current = index
    end
    print(index - 1 .. ": " .. value)
  end
  while true do
    local quest = "Delete which session? (Default: " .. (current >= 1 and current or "None") .. ") (q: quit): "
    local c = vim.fn.input(quest)
    if c:len() == 0 and current >= 1 then
      break
    elseif c:match("^q$") then
      current = 0
      break
    elseif c:match("^%d$") and tonumber(c, 10) < session_len then
      current = tonumber(c, 10) + 1
      break
    else
      echo("Please input an integer or nothing for default value (available only if not None).", "error")
    end
    vim.cmd("redraw")
  end
  if current >= 1 then
    os.remove(basef.s_trim(session_list[current]))
    local sessionpath = basef.FullPath(cwd .. "/.session.vim")
    os.remove(sessionpath)
    echo("Delete " .. session_list[current])
  else
    echo("Aborted")
  end
end

vim.cmd([[
command! -bar AutoSession lua require('my-plugins.autosave-session').help()
command! -bar AutoSessionSave lua require('my-plugins.autosave-session').SaveSession(true)
command! -bar AutoSessionAuto lua require('my-plugins.autosave-session').SaveSession(false)
command! -bar AutoSessionGlobal lua require('my-plugins.autosave-session').SaveGlobalSession()
command! -bar AutoSessionDelete lua require('my-plugins.autosave-session').DeleteSession()
command! -bar AutoSessionRestore lua require('my-plugins.autosave-session').RestoreSession()

command! Q :AutoSessionAuto <bar> :q
command! WQ :AutoSessionAuto <bar> :wq
command! Wq :AutoSessionAuto <bar> :wq
command! CL AutoSessionAuto <bar> :qa
]])

return M
