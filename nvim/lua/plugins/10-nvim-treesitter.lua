local ts_packages = {
  "bash",
  "bibtex",
  "cmake",
  "cpp",
  "cuda",
  "glsl",
  "html",
  "javascript",
  "json",
  "jsonc",
  "latex",
  "lua",
  "make",
  "markdown",
  "markdown_inline",
  "nim",
  "nim_format_string",
  "proto",
  "python",
  "rust",
  "regex",
  "toml",
  "tsx",
  "typescript",
  "vim",
  "vimdoc",
  "vue",
  "yaml",
}

local ts = {
  "nvim-treesitter/nvim-treesitter",
  dependencies = {
    "nvim-treesitter/nvim-treesitter-textobjects",
  },
  version = false,
  branch = "main",
  build = ":TSUpdateSync",
  event = "BufReadPre",
  cmd = { "TSUpdate", "TSUpdateSync" },
}

local M = {
  "MeanderingProgrammer/treesitter-modules.nvim",
  dependencies = { ts },
  opts = {
    modules = {},
    auto_install = true,
    ensure_installed = ts_packages,
    sync_install = false,
    ignore_install = {},
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
    incremental_selection = { enable = true },
  },
}

return M
