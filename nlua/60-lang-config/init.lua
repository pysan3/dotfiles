local function md(plugin)
  plugin.ft = { "markdown", "html", "NeogitCommitMessage", "gitcommit", "octo" }
  return plugin
end

return {
  { "lervag/vimtex", ft = { "latex", "tex" } },
  md({ "plasticboy/vim-markdown" }),
  md({ "dkarter/bullets.vim" }),
  md({ "dhruvasagar/vim-table-mode" }),
  md({ "godlygeek/tabular" }),
  md({ "iamcco/markdown-preview.nvim", run = "cd app && npm install" }),
  { "tpope/vim-abolish", cmd = { "Abolish", "Subvert" } },
  md({ "chip/vim-fat-finger", event = { "InsertEnter", "CmdlineEnter", "CursorHold", "FocusLost" } }),
  { "pixelneo/vim-python-docstring", ft = { "python" } },
  { "Vimjas/vim-python-pep8-indent", ft = { "python" } },
  {
    "hkupty/iron.nvim",
    cmd = { "IronRepl", "IronRestart", "IronFocus", "IronHide" },
    module = { "iron" }, ft = { "python" },
  },
  { "wfxr/protobuf.vim", ft = { "proto" } },
  { "tikhomirov/vim-glsl", ft = { "glsl" } },
  { "heavenshell/vim-jsdoc", run = "make install", ft = { "javascript", "javascript.jsx", "typescript" } },
  { "pysan3/fcitx5.nvim", cond = vim.fn.executable("fcitx5-remote") == 1, event = { "ModeChanged" } },
}
