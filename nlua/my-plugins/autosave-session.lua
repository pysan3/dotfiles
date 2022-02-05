local M = {}

local basef = require("my-plugins.base-functions")

M.SaveSess = function(force)
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

M.SaveGlobalSess = function()
  local cwd = vim.fn.getcwd()
  local dirname = basef.FullPath(vim.g.startify_session_dir) .. "/" .. basef.SessionName(cwd)
  local sessionpath = M.SaveSess(true)
  if basef.file_exist(sessionpath) then
    if basef.Confirm("Global session: `" .. dirname .. "` exists. Overwrite? [y/N]:", "n", false) then
      io.popen("ln -sf " .. sessionpath .. " " .. dirname .. " >/dev/null 2>/dev/null"):close()
      if basef.file_exist(dirname) then
        basef.echo("Saved session as: " .. dirname)
        return true
      else
        basef.echo("Something went wrong.", "error")
        return false
      end
    end
  end
  basef.echo("Abort", "error")
  return false
end

M.RestoreSess = function()
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
      M.SaveSess(true)
    end
  else
    basef.echo("Last session not found. Run `:SessSave` to save session.", "warning")
  end
  return true
  -- local current_session = vim.fn.sessionname(cwd)
  -- for buf = 1, vim.fn.bufnr("$") do
  --   local bufname = vim.fn.bufname(buf)
  --   if bufname == "." or bufname == "./" then
  --     vim.cmd("bd " .. bufname)
  --   elseif vim.fn.sessionname(bufname) == current_session then
  --     vim.cmd("bd " .. bufname)
  --   end
  -- end
end

M.DeleteSess = function()
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
    print(index, value)
    if basef.s_trim(basef.basename(value)):lower() == current_session:lower() then
      current = index
    end
  end
  while true do
    local c = vim.fn.input("Delete which session? (Default: " .. (current >= 1 and current or "None") .. "): ")
    print("")
    if c:len() == 0 and current >= 1 then
      break
    elseif c:match("^-?\\d$") and tonumber(c, 10) < session_len then
      current = tonumber(c, 10)
      break
    else
      basef.echo("Please input an integer or nothing for default value (available only if not None).")
    end
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
command! SessSave lua require('my-plugins.autosave-session').SaveSess(true)
command! SessAuto lua require('my-plugins.autosave-session').SaveSess(false)
command! SessGlobal lua require('my-plugins.autosave-session').SaveGlobalSess()
command! SessDelete lua require('my-plugins.autosave-session').DeleteSess()
autocmd VimLeave * nested SessAuto
autocmd VimEnter * nested lua require('my-plugins.autosave-session').RestoreSess()
]])

return M
