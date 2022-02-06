local M = {}

local basef = require("my-plugins.base-functions")

M.SaveSession = function(force)
  local cwd = vim.fn.getcwd()
  if basef.FullPath(cwd) == basef.FullPath(vim.env.HOME) then
    basef.echo("Currently working in $HOME directory. Not saving session.")
    return nil
  end
  local sessionpath = basef.FullPath(cwd .. "/.session.vim")
  if force or basef.file_exist(sessionpath) then
    vim.cmd("mksession! " .. sessionpath)
  end
  return sessionpath
end

M.SaveGlobalSession = function()
  local cwd = vim.fn.getcwd()
  if not vim.g.startify_session_dir then
    basef.echo("Please set `g:startify_session_dir`.\nAbort", "error")
    return false
  end
  vim.fn.mkdir(basef.FullPath(vim.g.startify_session_dir), "p")
  local dirname = basef.FullPath(vim.g.startify_session_dir) .. "/" .. basef.SessionName(cwd)
  local sessionpath = M.SaveSession(true)
  if not basef.file_exist(dirname) or basef.Confirm(dirname .. " exists. Overwrite? [y/N]:", "n", false) then
    io.popen("ln -sf " .. sessionpath .. " " .. dirname .. " >/dev/null 2>/dev/null"):close()
    if basef.file_exist(dirname) then
      basef.echo("Saved session as: " .. dirname)
      return true
    else
      basef.echo("Something went wrong.", "error")
      return false
    end
  end
  basef.echo("Abort", "error")
  return false
end

M.RestoreSession = function()
  local cwd = vim.fn.getcwd()
  if not vim.fn.filereadable(cwd .. "/.session.vim") then
    return false
  end
  local sessionpath = basef.FullPath(cwd .. "/.session.vim")
  local dirname = basef.FullPath(vim.g.startify_session_dir) .. "/" .. basef.SessionName(cwd)
  if basef.file_exist(sessionpath) then
    vim.cmd("so " .. sessionpath)
  elseif basef.file_exist(dirname) then
    if basef.Confirm("Found global session. Restore? [y/N]:", "n", false) then
      vim.cmd("so " .. dirname)
      M.SaveSession(true)
    end
  else
    basef.echo("Last session not found. Run `:AutoSessionSave` to save session.", "warn")
  end
  local current_session = basef.SessionName(cwd)
  for buf = 1, vim.fn.bufnr("$") do
    local bufname = vim.fn.bufname(buf)
    if string.match(bufname, "^.*/$") then
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
    basef.echo("No sessions to delete!\nNice and clean 😄")
    return false
  end
  for index, value in ipairs(session_list) do
    if basef.s_trim(basef.basename(value)):lower() == current_session:lower() then
      current = index
    end
    print(index .. ": " .. value)
  end
  while true do
    local quest = "Delete which session? (Default: " .. (current >= 1 and current or "None") .. ") (q: quit): "
    local c = vim.fn.input(quest)
    if c:len() == 0 and current >= 1 then
      break
    elseif c:match("^q$") then
      current = 0
      break
    elseif c:match("^%d$") and tonumber(c, 10) <= session_len then
      current = tonumber(c, 10)
      break
    else
      basef.echo("Please input an integer or nothing for default value (available only if not None).", "error")
    end
    vim.cmd("redraw")
  end
  if current >= 1 then
    os.remove(basef.s_trim(session_list[current]))
    local sessionpath = basef.FullPath(cwd .. "/.session.vim")
    os.remove(sessionpath)
    basef.echo("Delete " .. session_list[current])
  else
    basef.echo("Aborted")
  end
end

vim.cmd([[
command! AutoSession lua vim.notify('NOP\nAvailables: Auto, Save, Global, Delete', 'warn')
command! AutoSessionSave lua require('my-plugins.autosave-session').SaveSession(true)
command! AutoSessionAuto lua require('my-plugins.autosave-session').SaveSession(false)
command! AutoSessionGlobal lua require('my-plugins.autosave-session').SaveGlobalSession()
command! AutoSessionDelete lua require('my-plugins.autosave-session').DeleteSession()
autocmd VimLeave * nested AutoSessionAuto
autocmd VimEnter * nested lua require('my-plugins.autosave-session').RestoreSession()
]])

return M
