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
local fmta = require("luasnip.extras.fmt").fmta
local m = require("luasnip.extras").m
local lambda = require("luasnip.extras").l
local postfix = require("luasnip.extras.postfix").postfix

local snippets, autosnippets = {}, {}
---@diagnostic enable

local calculate_comment_string = require("Comment.ft").calculate
local utils = require("Comment.utils")

--- Get the comment string {beg,end} table
---@param ctype integer 1 for `line`-comment and 2 for `block`-comment
---@return table comment_strings {begcstring, endcstring}
local get_cstring = function(ctype)
  -- use the `Comments.nvim` API to fetch the comment string for the region (eq. '--%s' or '--[[%s]]' for `lua`)
  local cstring = calculate_comment_string({ ctype = ctype, range = utils.get_region() }) or vim.bo.commentstring
  -- as we want only the strings themselves and not strings ready for using `format` we want to split the left and right side
  local left, right = utils.unwrap_cstr(cstring)
  -- either parts can be nil that's why we check that to return empty string and lastly, create a `{left, right}` table for it
  return { left or "", right or "" }
end

--- Options for marks to be used in a TODO comment
local marks = {
  signature = function()
    return fmt("<{}>", i(1, _G.general_info.username))
  end,
  signature_with_email = function()
    return fmt("<{}{}>", { i(1, _G.general_info.username), i(2, " " .. _G.general_info.email) })
  end,
  date_signature_with_email = function()
    return fmt(
      "<{}{}{}>",
      { i(1, os.date("%d-%m-%y")), i(2, ", " .. _G.general_info.username), i(3, " " .. _G.general_info.email) }
    )
  end,
  date_signature = function()
    return fmt("<{}{}>", { i(1, os.date("%d-%m-%y")), i(2, ", " .. _G.general_info.username) })
  end,
  date = function()
    return fmt("<{}>", i(1, os.date("%d-%m-%y")))
  end,
  empty = function()
    return t("")
  end,
}

local todo_snippet_nodes = function(aliases, opts)
  local aliases_nodes = vim.tbl_map(function(alias)
    return i(nil, alias) -- generate choices for [name-of-comment]
  end, aliases)
  local sigmark_nodes = {} -- choices for [comment-mark]
  for _, mark in pairs(marks) do
    table.insert(sigmark_nodes, mark())
  end
  -- format them into the actual snippet
  local comment_node = fmta("<> <>: <> <> <><>", {
    f(function()
      return get_cstring(opts.ctype)[1] -- get <comment-string[1]>
    end),
    c(1, aliases_nodes), -- [name-of-comment]
    i(3), -- {comment-text}
    c(2, sigmark_nodes), -- [comment-mark]
    f(function()
      return get_cstring(opts.ctype)[2] -- get <comment-string[2]>
    end),
    i(0),
  })
  return comment_node
end

--- Generate a TODO comment snippet with an automatic description and docstring
---@param context table merged with the generated context table `trig` must be specified
---@param aliases string[] of aliases for the todo comment (ex.: {FIX, ISSUE, FIXIT, BUG})
---@param opts table merged with the snippet opts table
local todo_snippet = function(context, aliases, opts)
  opts = opts or {}
  context = context or {}
  if not context.trig then
    return error("context doesn't include a `trig` key which is mandatory", 2) -- all we need from the context is the trigger
  end
  opts.ctype = opts.ctype or 1 -- comment type can be passed in the `opts` table, but if it is not, we have to ensure, it is defined
  local alias_string = table.concat(aliases, "|") -- `choice_node` documentation
  context.name = context.name or (alias_string .. " comment") -- generate the `name` of the snippet if not defined
  context.dscr = context.dscr or (alias_string .. " comment with a signature-mark") -- generate the `dscr` if not defined
  context.docstring = context.docstring or (" {1:" .. alias_string .. "}: {3} <{2:mark}>{0} ") -- generate the `docstring` if not defined
  local comment_node = todo_snippet_nodes(aliases, opts) -- nodes from the previously defined function for their generation
  return s(context, comment_node, opts) -- the final todo-snippet constructed from our parameters
end

local todo_snippet_specs = {
  { { trig = "todo" }, { "TODO" } },
  { { trig = "fix" }, { "FIX", "BUG", "ISSUE", "FIXIT" } },
  { { trig = "hack" }, { "HACK" } },
  { { trig = "warn" }, { "WARN", "WARNING", "XXX" } },
  { { trig = "perf" }, { "PERF", "PERFORMANCE", "OPTIM", "OPTIMIZE" } },
  { { trig = "note" }, { "NOTE", "INFO" } },
  -- NOTE: Block commented todo-comments <kunzaatko>
  { { trig = "todob" }, { "TODO" }, { ctype = 2 } },
  { { trig = "fixb" }, { "FIX", "BUG", "ISSUE", "FIXIT" }, { ctype = 2 } },
  { { trig = "hackb" }, { "HACK" }, { ctype = 2 } },
  { { trig = "warnb" }, { "WARN", "WARNING", "XXX" }, { ctype = 2 } },
  { { trig = "perfb" }, { "PERF", "PERFORMANCE", "OPTIM", "OPTIMIZE" }, { ctype = 2 } },
  { { trig = "noteb" }, { "NOTE", "INFO" }, { ctype = 2 } },
}

for _, v in ipairs(todo_snippet_specs) do
  table.insert(snippets, todo_snippet(v[1], v[2], v[3]))
end

return snippets, autosnippets
