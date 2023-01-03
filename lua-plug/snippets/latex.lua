---@diagnostic disable
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
local m = require("luasnip.extras").m
local lambda = require("luasnip.extras").l
local postfix = require("luasnip.extras.postfix").postfix

local snippets, autosnippets = {}, {}
---@diagnostic enable

local tex = {}
tex.in_mathzone = function()
  return vim.fn["vimtex#syntax#in_mathzone"]() == 1
end
tex.in_text = function()
  return not tex.in_mathzone()
end
tex.in_beamer = function()
  return vim.b.vimtex["documentclass"] == "beamer" ---@diagnostic disable-line
end

-- Endless Itemize
tex.rec_ls = function()
  return sn(nil, { c(1, {
    t({ "" }),
    sn(nil, { t({ "", "\t\\item " }), i(1), d(2, tex.rec_ls, {}) }),
  }) })
end
table.insert(
  snippets,
  s("ls", {
    t({ "\\begin{itemize}", "\t\\item " }),
    i(1),
    d(2, tex.rec_ls, {}),
    t({ "", "\\end{itemize}" }),
    i(0),
  })
)

-- Endless Table
tex.table_node = function(args)
  local tabs = {}
  local count
  local node = args[1][1]:gsub("%s", ""):gsub("|", "")
  count = string.len(node)
  for j = 1, count do
    local iNode
    iNode = i(j)
    tabs[2 * j - 1] = iNode
    if j ~= count then
      tabs[2 * j] = t(" & ")
    end
  end
  return sn(nil, tabs)
end
tex.rec_table = function()
  return sn(nil, {
    c(1, {
      t({ "" }),
      sn(nil, { t({ "\\\\", "" }), d(1, tex.table_node, { ai[1] }), d(2, tex.rec_table, { ai[1] }) }),
    }),
  })
end
table.insert(
  snippets,
  s("table", {
    t("\\begin{tabular}{"),
    i(1, "0"),
    t({ "}", "" }),
    d(2, tex.table_node, { 1 }, {}),
    d(3, tex.rec_table, { 1 }),
    t({ "", "\\end{tabular}" }),
  })
)

-- Context Aware Expansion
table.insert(
  snippets,
  s("dm", {
    t({ "\\[", "\t" }),
    i(1),
    t({ "", "\\]" }),
  }, { condition = tex.in_text })
)
table.insert(
  snippets,
  s("bfr", {
    t({ "\\begin{frame}", "\t\\frametitle{" }),
    i(1, "frame title"),
    t({ "}", "\t" }),
    i(0),
    t({ "", "\\end{frame}" }),
  }, { condition = tex.in_beamer })
)

return snippets, autosnippets
