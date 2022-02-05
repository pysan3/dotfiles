-- https://github.com/lervag/vimtex/blob/master/doc/vimtex.txt#LC900
vim.g.vimtex_compiler_latexmk = {
  build_dir = "build",
  callback = 1,
  continuous = 1,
  executable = "latexmk",
  hooks = {},
  options = {
    "-verbose",
    "-file-line-error",
    "-synctex=1",
    "-interaction=nonstopmode",
  },
}

-- https://github.com/lervag/vimtex/blob/master/doc/vimtex.txt#LC2136
vim.g.vimtex_syntax_conceal = {
  accents = 1,
  cites = 1,
  fancy = 0,
  greek = 0,
  math_bounds = 0,
  math_delimiters = 1,
  math_fracs = 0,
  math_super_sub = 0,
  math_symbols = 0,
  sections = 1,
  styles = 0,
}

-- https://github.com/lervag/vimtex/blob/master/doc/vimtex.txt#LC2140
vim.g.vimtex_quickfix_open_on_warning = 0
