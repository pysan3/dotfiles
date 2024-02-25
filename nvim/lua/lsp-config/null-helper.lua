local M = {}

---Register new null-ls source
---@param names table<string | integer, table | string> # name like `fmt.prettier` that points to sources
---@param disable_others boolean? # whether to disable other sources with same filetype
M.null_register = function(names, disable_others)
  local null = require("null-ls")
  local builtins = {
    f = "formatting",
    d = "diagnostics",
    a = "code_actions",
    c = "completion",
    h = "hover",
  }
  local sources = {}
  local filetypes = {}
  for name, opts in pairs(names) do
    if type(opts) == "string" then
      name = opts
      opts = vim.g.personal_lookup.get("null", name)
    end
    local mod_name = "." .. builtins[name:sub(1, 1)] .. name:sub(2)
    local suc, source = pcall(require, "none-ls" .. mod_name)
    if not suc or not source then
      source = require("null-ls.builtins" .. mod_name)
    end
    if not vim.tbl_isempty(opts) then
      source = source.with(opts)
    end
    sources[#sources + 1] = source
    if disable_others then
      for _, ft in ipairs(source.filetypes) do
        filetypes[ft] = true
      end
    end
  end
  if disable_others then
    for ft, _ in pairs(filetypes) do
      null.disable({ filetype = ft })
      null.deregister({ filetype = ft })
    end
  end
  null.register(sources)
end

return M
