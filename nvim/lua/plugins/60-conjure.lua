return {
  "Olical/conjure",
  cmd = {
    "ConjureSchool",
    "ConjureEval",
    "ConjureConnect",
    "ConjureClientState",
  },
  keys = {
    { vim.g.personal_options.prefix.iron },
  },
  ft = { "clojure", "fennel", "janet", "hy", "julia", "racket", "scheme", "lua", "lisp", "python", "rust" },
  dependencies = {
    "nvim-treesitter",
  },
  init = function()
    vim.g["conjure#mapping#prefix"] = vim.g.personal_options.prefix.iron
    vim.g["conjure#mapping#doc_word"] = "K"
  end,
}
