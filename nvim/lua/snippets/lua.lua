---@diagnostic disable
-- stylua: ignore start
local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local isn = ls.indent_snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local events = require("luasnip.util.events")
local ai = require("luasnip.nodes.absolute_indexer")
local fmt = require("luasnip.extras.fmt").fmt
local rep = require("luasnip.extras").rep
local m = require("luasnip.extras").m
local lambda = require("luasnip.extras").l
local postfix = require("luasnip.extras.postfix").postfix

local snippets, autosnippets = {}, {}
local e = function(trig, dscr, name, wordTrig, regTrig, docstring, docTrig, hidden, priority)
  local ret = { trig = trig, name = name ~= nil and name or trig, dscr = dscr }
  if wordTrig ~= nil then ret["wordTrig"] = wordTrig end
  if regTrig ~= nil then ret["regTrig"] = regTrig end
  if docstring ~= nil then ret["docstring"] = docstring end
  if docTrig ~= nil then ret["docTrig"] = docTrig end
  if hidden ~= nil then ret["hidden"] = hidden end
  if priority ~= nil then ret["priority"] = priority end
  return ret
end
-- stylua: ignore end
---@diagnostic enable

snippets[#snippets + 1] = s(
  e("snew", "insert a new snippet node"),
  fmt(
    [[
{}[#{} + 1] = s(
  {}
)
    ]],
    {
      c(1, { t("snippets"), t("autosnippets") }),
      rep(1),
      i(0),
    }
  )
)

snippets[#snippets + 1] = s(
  e("debug", "vim.print + string.format"),
  fmt([=[vim.print(string.format([[{var}: %s]], {inspect}))]=], {
    var = i(1),
    inspect = d(2, function(args)
      return sn(
        1,
        c(1, {
          fmt([[vim.inspect({})]], { i(1, args[1][1]) }),
          i(1, args[1][1]),
          fmt([[tostring({})]], { i(1, args[1][1]) }),
        })
      )
    end, 1),
  })
)

return snippets, autosnippets
