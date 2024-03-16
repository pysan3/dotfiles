local function imports()
  return require("luasnip"), require("neorg.modules.external.templates.default_snippets")
end

return {
  TODAY_OF_FILE_ORG = function() -- detect date from filename and return in org date format
    local ls, m = imports()
    -- use m.file_name_date() if you use journal.strategy == "flat"
    return ls.text_node(m.parse_date(0, m.file_tree_date(), [[<%Y-%m-%d %a]])) -- <2006-11-01 Wed>
  end,
  TODAY_OF_FILE_NORG = function() -- detect date from filename and return in norg date format
    local ls, m = imports()
    -- use m.file_name_date() if you use journal.strategy == "flat"
    return ls.text_node(m.parse_date(0, m.file_tree_date(), [[%a, %d %b %Y]])) -- Wed, 1 Nov 2006
  end,
  TODAY_ORG = function() -- detect date from filename and return in org date format
    local ls, m = imports()
    return ls.text_node(m.parse_date(0, os.time(), [[<%Y-%m-%d %a %H:%M:%S>]])) -- <2006-11-01 Wed 19:15>
  end,
  TODAY_NORG = function() -- detect date from filename and return in norg date format
    local ls, m = imports()
    return ls.text_node(m.parse_date(0, os.time(), [[%a, %d %b %Y %H:%M:%S]])) -- Wed, 1 Nov 2006 19:15
  end,
  NOW_IN_DATETIME = function() -- print current date+time of invoke
    local ls, m = imports()
    return ls.text_node(m.parse_date(0, os.time(), [[%Y-%m-%d %a %X]])) -- 2023-11-01 Wed 23:48:10
  end,
  YESTERDAY_OF_FILEPATH = function() -- detect date from filename and return its file path to be used in a link
    local ls, m = imports()
    return ls.text_node(m.parse_date(-1, m.file_tree_date(), [[../../%Y/%m/%d]])) -- ../../2020/01/01
  end,
  TOMORROW_OF_FILEPATH = function() -- detect date from filename and return its file path to be used in a link
    local ls, m = imports()
    return ls.text_node(m.parse_date(1, m.file_tree_date(), [[../../%Y/%m/%d]])) -- ../../2020/01/01
  end,
}
