local M = {}

M.echo = function(msg, level, ...)
  if level == nil then
    level = "info"
  end
  vim.notify(msg, level, ...)
end

M.file_exist = function(path)
  local f = io.open(path, "r")
  return f ~= nil and io.close(f)
end

M.s_trim = function(s, t)
  if not t then
    t = "%s"
  end
  return string.gsub(s, "^" .. t .. "*(.-)" .. t .. "*$", "%1")
end

M.basename = function(path)
  return M.s_trim(path):gsub("(.*/)(.*)", "%2")
end

M.Confirm = function(msg, ans, default)
  print(msg .. " ")
  local answer = string.char(tonumber(vim.fn.getchar(), 10)):lower()
  print(answer)
  vim.cmd("redraw")
  if answer == ans:lower() then
    return default
  elseif answer == "n" then
    print("no")
    vim.cmd("redraw")
    return false
  elseif answer == "y" then
    print("yes")
    vim.cmd("redraw")
    return true
  else
    return default
  end
end

M.SessionName = function(path)
  if path == "" then
    return ""
  end
  return M.s_trim(M.basename(path), "\\.")
end

M.FullPath = function(path)
  return vim.fn.resolve(vim.fn.expand(path))
end

return M
