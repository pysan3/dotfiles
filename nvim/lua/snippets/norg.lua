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
local e = function(trig, name, dscr, wordTrig, regTrig, docstring, docTrig, hidden, priority)
  local ret = { trig = trig, name = name, dscr = dscr }
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

local function get_date(delta_date, str, timestamp_syntax)
  local year, month, day = string.match(str, [[^(%d%d%d%d)-(%d%d)-(%d%d)$]])
  local format = timestamp_syntax and [[%a, %d %b %Y]] or [[%Y-%m-%d]]
  return os.date(format, os.time({ year = year, month = month, day = day }) + 86400 * delta_date)
end

snippets[#snippets + 1] = s(
  e("journal", "insert template for journal page"),
  fmt(
    [[
* {title}

{{:{yesterday}:}}[Yesterday] - {{:{tomorrow}:}}[Tomorrow]

** Daily Review
   - {}

** Today's Checklist
   - ( ) Write my daily review

** Achievements
   -
    ]],
    {
      title = f(function(_, _)
        return get_date(0, vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":t:r"))
      end),
      yesterday = f(function(_, _)
        return get_date(-1, vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":t:r"))
      end),
      tomorrow = f(function(_, _)
        return get_date(1, vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":t:r"))
      end),
      i(0),
    }
  )
)

snippets[#snippets + 1] = s(
  e("flink", "insert file path using `$` as root of workspace"),
  fmt([[{{:{}{}{}:}}{}]], {
    c(2, { t(vim.fn.getcwd() .. "/"), t("$/") }),
    i(1),
    i(3),
    i(0),
  })
)

return snippets, autosnippets
