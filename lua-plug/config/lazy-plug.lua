local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  local git_path = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system({ "git", "clone", "--filter=blob:none", "--single-branch", git_path, lazypath })
end
vim.opt.runtimepath:prepend(lazypath)

require("lazy").setup("plugins", {
  defaults = {
    lazy = true,
    version = "*",
  },
  lockfile = vim.fn.stdpath("cache") .. "/lazy-lock.json", -- lockfile generated after running update.
  dev = {
    path = "~/Git",
  },
  install = {
    missing = false,
    colorscheme = { vim.g.personal_options.colorscheme },
  },
  checker = {
    enabled = true,
    notify = false,
  },
  performance = {
    cache = {
      enabled = true,
      -- disable_events = {},
    },
    rtp = {
      disabled_plugins = {
        "gzip",
        "matchit",
        "matchparen",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
        "nvim-treesitter-textobjects",
      },
    },
  },
})

vim.keymap.set("n", "<Leader><Leader>x", "<Cmd>Lazy<CR>", {})
