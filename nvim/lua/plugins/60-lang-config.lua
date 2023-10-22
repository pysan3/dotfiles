return {
  { "lervag/vimtex", ft = { "latex", "tex" } },
  {
    "dkarter/bullets.vim",
    ft = vim.g.personal_module.md(),
    init = function()
      vim.g.bullets_enabled_file_types = vim.g.personal_module.md()
      vim.g.bullets_outline_levels = { "num", "abc", "std-" }
    end,
  },
  { "iamcco/markdown-preview.nvim", ft = vim.g.personal_module.md(), build = "cd app && npx --yes yarn install" },
  { "chip/vim-fat-finger", ft = vim.g.personal_module.md(), event = "VeryLazy" },
  { "Vimjas/vim-python-pep8-indent", ft = { "python" } },
  { "wfxr/protobuf.vim", ft = { "proto" } },
  { "tikhomirov/vim-glsl", ft = { "glsl" } },
}
