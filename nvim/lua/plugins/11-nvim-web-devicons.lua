local M = {
  "nvim-web-devicons",
}

M.config = function()
  local devicons = require("nvim-web-devicons")
  devicons.setup({
    override = {
      norg = {
        icon = "◉", -- Default icon for Header 1
        color = "#4878BE",
        name = "Neorg",
      },
      zwc = {
        icon = "",
        color = "#41535B",
        name = "zCompile",
      },
      proto = {
        icon = "",
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
        color = "#41535B",
        name = "PoetryLockFile",
      },
    },
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
end

return M
