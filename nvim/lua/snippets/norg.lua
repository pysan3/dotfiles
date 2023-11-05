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

local function parse_date(delta_date, str, timestamp_syntax)
  local year, month, day = string.match(str, [[^(%d%d%d%d)-(%d%d)-(%d%d)$]])
  local format = timestamp_syntax and [[%a, %d %b %Y]] or [[%Y-%m-%d]]
  return os.date(format, os.time({ year = year, month = month, day = day }) + 86400 * delta_date)
end

local function file_title()
  return vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":t:r")
end

---Parse url and return service name based on domain
---@param link string # url in shape of http(s)://domain.name/xxx
---@return string # Name of service
local function link_type(link)
  local lookup = {
    ["www.youtube.com"] = "YouTube",
    ["youtu.be"] = "YouTube",
  }
  local domain = string.gsub(link, [[http.://([^/]-)/.*]], "%1")
  vim.notify(string.format(
    [[
URL: %s
-> Domain: %s
-> Lookup: %s
  ]],
    link,
    domain,
    lookup[domain]
  ))
  return lookup[domain] or domain
end

snippets[#snippets + 1] = s(
  e("flink", "insert file path using `$` as root of workspace"),
  fmt([[{}{}{}]], {
    c(2, { t(vim.fn.getcwd() .. "/"), t("$/") }),
    i(1),
    i(0),
  })
)

snippets[#snippets + 1] = s(
  e("urltag", "insert url with tag"),
  fmt([[#{link_type} {{{link}}}]], {
    link = i(1, "link"),
    link_type = f(function(args, _)
      return link_type(args[1][1]):lower()
    end, { 1 }),
  })
)

snippets[#snippets + 1] = s(
  e("journal", "template for journal page"),
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
        return parse_date(0, file_title())
      end),
      yesterday = f(function(_, _)
        return parse_date(-1, file_title())
      end),
      tomorrow = f(function(_, _)
        return parse_date(1, file_title())
      end),
      i(0),
    }
  )
)

snippets[#snippets + 1] = s(
  e("literature", "template for literature page"),
  fmt(
    [[
* {title}
  #{link_type} {{{link}}}
  #output {output}
  |comment
  {comment}
  |end

  {content}
    ]],
    {
      title = f(file_title),
      link = i(1, "link"),
      link_type = f(function(args, _)
        return link_type(args[1][1]):lower()
      end, { 1 }),
      output = i(2, "DIL"),
      comment = i(3, "Why did you read this?"),
      content = i(0, "content"),
    }
  )
)

snippets[#snippets + 1] = s(
  e("cook", "template for cooking menu"),
  fmt(
    [[
* {title}
  #{link_type} {{{link}}}

** Ingredients
  {menu}

** Method
  {method}

** Notes
  {notes}
    ]],
    {
      title = f(file_title),
      link = i(1, "link"),
      link_type = f(function(args, _)
        return link_type(args[1][1]):lower()
      end, { 1 }),
      menu = i(2, "menu"),
      notes = i(3),
      method = i(0),
    }
  )
)

return snippets, autosnippets
