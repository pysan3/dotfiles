local devicons = require("nvim-web-devicons")

devicons.setup({
  -- your personal icons can go here (to override)
  -- you can specify color or cterm_color instead of specifying both of them
  -- DevIcon will be appended to `name`
  override = {
    zwc = {
      icon = "",
      color = "#41535b",
      name = "zCompile",
    },
    proto = {
      icon = "﬘",
      color = "#FD5C78",
      name = "Protobuf",
    },
    snippets = {
      icon = "",
      color = "#DBC63E",
      name = "Snippets",
    },
    ["poetry.lock"] = {
      icon = "",
      color = "#41535b",
      name = "PoetryLockFile",
    },
  },
  -- globally enable default icons (default to false)
  -- will get overriden by `get_icons` option
  default = true,
})

local default_icons = devicons.get_icons()
devicons.set_icon({
  pyi = default_icons.pyd,
  latex = default_icons.tex,
  [".latexmkrc"] = default_icons.tex,
  sty = default_icons.tex,
  [".pylintrc"] = default_icons.toml,
  [".python-version"] = default_icons.toml,
  ["Makefile"] = default_icons.makefile,
})
