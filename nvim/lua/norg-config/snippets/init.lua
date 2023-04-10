local function load_and_add(path, snippets, autosnippets)
  local sn, asn = require(path)
  vim.list_extend(snippets, sn)
  vim.list_extend(autosnippets, asn or {})
end

return {
  setup = function(_, snippets, autosnippets)
    load_and_add("norg-config.snippets.journal", snippets, autosnippets)
  end,
}
