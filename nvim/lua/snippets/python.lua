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

local types = require("luasnip.util.types")

-- Function Definition With Dynamic Virtual Text
-- https://github.com/L3MON4D3/LuaSnip/wiki/Cool-Snippets#python---function-definition-with-dynamic-virtual-text
local function node_with_virtual_text(pos, node, text)
  local nodes
  if node.type == types.textNode then
    node.pos = 2
    nodes = { i(1), node }
  else
    node.pos = 1
    nodes = { node }
  end
  return sn(pos, nodes, {
    callbacks = {
      -- node has pos 1 inside the snippetNode.
      [1] = {
        [events.enter] = function(nd)
          -- node_pos: {line, column}
          local node_pos = nd.mark:pos_begin()
          -- reuse luasnips namespace, column doesn't matter, just 0 it.
          nd.virt_text_id = vim.api.nvim_buf_set_extmark(0, ls.session.ns_id, node_pos[1], 0, {
            virt_text = { { text, "GruvboxOrange" } },
          })
        end,
        [events.leave] = function(nd)
          vim.api.nvim_buf_del_extmark(0, ls.session.ns_id, nd.virt_text_id)
        end,
      },
    },
  })
end

local function nodes_with_virtual_text(nodes, opts)
  if opts == nil then
    opts = {}
  end
  local new_nodes = {}
  for pos, node in ipairs(nodes) do
    if opts.texts[pos] ~= nil then
      node = node_with_virtual_text(pos, node, opts.texts[pos])
    end
    table.insert(new_nodes, node)
  end
  return new_nodes
end

local function choice_text_node(pos, choices, opts)
  choices = nodes_with_virtual_text(choices, opts)
  return c(pos, choices, opts)
end

table.insert(
  snippets,
  s(
    "d",
    fmt("def {func}({args}){ret}:\n\t{doc}{body}", {
      func = i(1),
      args = i(2),
      ret = c(3, { sn(nil, { t(" -> "), i(1) }), t("") }),
      doc = isn(4, {
        choice_text_node(1, {
          t(""),
          sn(1, fmt('"""{desc}"""\n', { desc = i(1) })),
          sn(
            2,
            fmt(
              '"""{desc}\n\nArgs:\n\t{args}\n\nReturns:\n\t{returns}\n"""',
              { desc = i(1), args = i(2), returns = i(3) }
            )
          ),
        }, { texts = { "(no docstring)", "(single line docstring)", "(full docstring)" } }),
      }, "$PARENT_INDENT\t"),
      body = i(0),
    })
  )
)

-- Init Function With Dynamic Initializer List
-- https://github.com/L3MON4D3/LuaSnip/wiki/Cool-Snippets#python---init-function-with-dynamic-initializer-list
local function py_init()
  return sn(
    nil,
    c(1, {
      t(""),
      sn(1, {
        t(", "),
        i(1),
        d(2, py_init),
      }),
    })
  )
end

local function to_init_assign(args)
  local tab = {}
  local a = args[1][1]
  if #a == 0 then
    table.insert(tab, t({ "", "\tpass" }))
  else
    local cnt = 1
    for e in string.gmatch(a, " ?([^,]*) ?") do
      if #e > 0 then
        table.insert(tab, t({ "", "\tself." }))
        table.insert(tab, r(cnt, tostring(cnt), i(nil, e)))
        table.insert(tab, t(" = "))
        table.insert(tab, t(e))
        cnt = cnt + 1
      end
    end
  end
  return sn(nil, tab)
end

table.insert(
  snippets,
  s(
    "pyinit",
    fmt([[def __init__(self{}):{}]], {
      d(1, py_init),
      d(2, to_init_assign, { 1 }),
    })
  )
)

return snippets, autosnippets
