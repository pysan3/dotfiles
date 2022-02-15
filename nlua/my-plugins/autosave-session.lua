local M = {}

local basef = require("my-plugins.base-functions")
local plugin_name = "AutoSession Plugin"
local plugin_icon = ""
local plugin_commands = {
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

M.SaveSession = function(force)
  local cwd = vim.fn.getcwd()
  if basef.FullPath(cwd) == basef.FullPath(vim.env.HOME) then
    echo("Currently working in $HOME directory. Not saving session.")
    return nil
  end
  local sessionpath = basef.FullPath(cwd .. "/.session.vim")
  if force or basef.file_exist(sessionpath) then
    vim.cmd("mksession! " .. sessionpath)
    echo(".session.vim created.")
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
command! AutoSession lua require('my-plugins.autosave-session').help()
command! AutoSessionSave lua require('my-plugins.autosave-session').SaveSession(true)
command! AutoSessionAuto lua require('my-plugins.autosave-session').SaveSession(false)
command! AutoSessionGlobal lua require('my-plugins.autosave-session').SaveGlobalSession()
command! AutoSessionDelete lua require('my-plugins.autosave-session').DeleteSession()
autocmd VimLeave * nested AutoSessionAuto
autocmd VimEnter * nested lua require('my-plugins.autosave-session').RestoreSession()
]])

return M
