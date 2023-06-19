local function pounce_map_func(opts)
  return function()
    require("pounce").pounce(opts or {})
  end
end

local function pounce_register()
  vim.notify("Press name of register.")
  local key = string.char(vim.fn.getchar())
  if string.match(key, "[%w]") then
  elseif string.match(key, '["+*]') then
  else
    vim.notify(string.format([[`%s` is not a valid register. Aborting.]], key), vim.log.levels.ERROR)
    return
  end
  return pounce_map_func({ input = { reg = key } })()
end

return {
  "rlane/pounce.nvim",
  keys = {
    { "s", pounce_map_func(), mode = { "n", "x" } },
    { "S", pounce_register, mode = { "n", "x" } },
    { "gs", pounce_map_func(), mode = { "o" } },
  },
  opts = {
    accept_best_key = "<Tab>",
  },
}
