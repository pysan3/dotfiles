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
  "latex",
  "lua",
  "make",
  "markdown",
  "markdown_inline",
  "proto",
  "python",
  "rust",
  "toml",
  "tsx",
  "typescript",
  "vim",
  "vimdoc",
  "vue",
  "yaml",
}

local M = {
  "nvim-treesitter/nvim-treesitter",
  dependencies = { "sustech-data/wildfire.nvim" },
  build = ":TSUpdateSync",
  event = "BufReadPre",
  cmd = { "TSUpdate", "TSUpdateSync" },
}

M.config = function()
  require("nvim-treesitter.configs").setup({
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
    incremental_selection = { enable = false }, -- wildfire does a better job
  })
  require("wildfire").setup({
    keymaps = {
      init_selection = "gn",
      node_incremental = "]]",
      node_decremental = "[[",
    },
  })
end

return M
