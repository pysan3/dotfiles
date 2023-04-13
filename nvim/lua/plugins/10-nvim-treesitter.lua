local ts_packages = {
  -- "astro",
  "bash",
  -- "beancount",
  "bibtex",
  -- "c",
  -- "c_sharp",
  -- "clojure",
  "cmake",
  -- "comment",
  -- "commonlisp",
  -- "cooklang",
  "cpp",
  -- "css",
  "cuda",
  -- "d",
  -- "dart",
  -- "devicetree",
  -- "dockerfile",
  -- "dot",
  -- "eex",
  -- "elixir",
  -- "elm",
  -- "elvish",
  -- "embedded_template",
  -- "erlang",
  -- "fennel",
  -- "fish",
  -- "foam",
  -- "fortran",
  -- "fusion",
  -- "Godot",
  -- "gleam",
  -- "Glimmer",
  "glsl",
  -- "go",
  -- "gomod",
  -- "gowork",
  -- "graphql",
  -- "hack",
  -- "haskell",
  -- "hcl",
  -- "heex",
  -- "hjson",
  -- "hocon",
  "html",
  -- "http",
  -- "java",
  "javascript",
  -- "jsdoc",
  "json",
  -- "json5",
  -- "jsonc",
  -- "julia",
  -- "kotlin",
  -- "lalrpop",
  "latex",
  -- "ledger",
  -- "llvm",
  "lua",
  -- "m68k",
  "make",
  "markdown",
  "markdown_inline",
  -- "ninja",
  -- "nix",
  -- "norg",
  -- "ocaml",
  -- "ocaml_interface",
  -- "ocamllex",
  -- "org",
  -- "pascal",
  -- "perl",
  -- "php",
  -- "phpdoc",
  -- "pioasm",
  -- "prisma",
  "proto",
  -- "pug",
  "python",
  -- "ql",
  -- "r",
  -- "rasi",
  -- "regex",
  -- "rego",
  -- "rst",
  -- "ruby",
  "rust",
  -- "scala",
  -- "scheme",
  -- "scss",
  -- "slint",
  -- "solidity",
  -- "sparql",
  -- "supercollider",
  -- "surface",
  -- "svelte",
  -- "swift",
  -- "teal",
  -- "tlaplus",
  -- "todotxt",
  "toml",
  "tsx",
  -- "turtle",
  "typescript",
  -- "vala",
  -- "verilog",
  "vim",
  "vimdoc",
  "vue",
  -- "wgsl",
  "yaml",
  -- "yang",
  -- "zig",
}

local M = {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  event = "BufReadPre",
}

M.config = function()
  require("nvim-treesitter.configs").setup({
    ensure_installed = ts_packages,
    sync_install = false,
    ignore_install = { -- List of parsers to ignore installing
    },
    autopairs = { enable = true },
    highlight = {
      enable = true,
      disable = {
        "latex",
        "tex",
        "markdown",
        "sh",
        "bash",
        "zsh",
      },
      additional_vim_regex_highlighting = false,
    },
    indent = {
      enable = true,
      disable = {
        "python",
        "yaml",
      },
    },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = "gn",
        node_incremental = "]]",
        node_decremental = "[[",
      },
    },
  })
end

return M
