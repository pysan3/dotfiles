local function load_and_add(required, snippets, autosnippets)
  local sn, asn = unpack(required)
  vim.list_extend(snippets, sn)
  vim.list_extend(autosnippets, asn or {})
end

return {
  setup = function(_, snippets, autosnippets)
    load_and_add({ require("norg-config.snippets.journal") }, snippets, autosnippets)
  end,
}
