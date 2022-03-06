local M = {}

---echos `msg` as a vim.notify
---@param msg string
---@param level string ("info", "warn", "error")
---@param ... any any options to pass to vim.notify
M.echo = function(msg, level, ...)
  if level == nil then
    level = "info"
  end
  vim.notify(msg, level, ...)
end

---return if file exists
---@param path string
---@return boolean
M.file_exist = function(path)
  local f = io.open(path, "r")
  return f ~= nil and io.close(f)
end

---returns string where `t` is trimmed from both sides of `s`
---@param s string
---@param t string
---@return string
M.s_trim = function(s, t)
  if not t then
    t = "%s"
  end
  return string.gsub(s, "^" .. t .. "*(.-)" .. t .. "*$", "%1")
end

---same as running `basename "$path"` in command line
---@param path string
---@return string
M.basename = function(path)
  return M.s_trim(path):gsub("(.*/)(.*)", "%2")
end

---Confirm: asks for a confirmation in cmd
---@param msg string dont forget to add [y/N] or [Y/n] at the end
---@param ans string what would be the default option. usually 'y' or 'n'
---@param default boolean return value if <CR> was pressed without any letter
---@return boolean
M.Confirm = function(msg, ans, default)
  print(msg .. " ")
  local raw_ans = tonumber(vim.fn.getchar(), 10)
  local answer = string.char(raw_ans):lower()
  if answer == ans:lower() or raw_ans == 13 then -- \n returns the default
    return default
  elseif answer == "n" then
    return false
  elseif answer == "y" then
    return true
  else
    return not default
  end
end

---SessionName: returns the basename of `path`
---@param path string
---@return string
M.SessionName = function(path)
  if path == "" then
    return ""
  end
  return M.s_trim(M.basename(path), "%.")
end

---FullPath: returns `path`'s absolute path
---@param path string
---@return string
M.FullPath = function(path)
  return vim.fn.resolve(vim.fn.expand(path))
end

return M
