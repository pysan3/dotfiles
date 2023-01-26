_G.general_info = {
  username = "pysan3",
  email = "pysan3@gmail.com",
  github = "https://github.com/pysan3",
}

vim.g.personal_options = {
  colorscheme = os.getenv("NVIM_COLOR") or "nvcode",
  lsp_saga = {
    enable = true,
    winbar = true,
  },
  prefix = {
    telescope = "<Leader>f",
  },
}

vim.opt.completeopt = "menuone,noselect"

-- global status line
vim.opt.laststatus = 3
vim.opt.fillchars = "vert:┃,horiz:━,verthoriz:╋,horizup:┻,horizdown:┳,vertleft:┫,vertright:┣,eob: " -- more obvious separator
vim.cmd([[
highlight WinSeparator guibg=None
]])

-- disable builtin plugins
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_netrwSettings = 1
vim.g.loaded_netrwFileHandlers = 1
vim.g.loaded_2html_plugin = 1
vim.g.loaded_getscript = 1
vim.g.loaded_getscriptPlugin = 1
vim.g.loaded_gzip = 1
vim.g.loaded_logipat = 1
vim.g.loaded_matchit = 1
vim.g.loaded_tar = 1
vim.g.loaded_tarPlugin = 1
vim.g.loaded_rrhelper = 1
vim.g.loaded_spellfile_plugin = 1
vim.g.loaded_vimball = 1
vim.g.loaded_vimballPlugin = 1
vim.g.loaded_zip = 1
vim.g.loaded_zipPlugin = 1

-- resize splits automatically for tmux
local wr_group = vim.api.nvim_create_augroup("WinResize", { clear = true })
vim.api.nvim_create_autocmd(
  "VimResized",
  { group = wr_group, pattern = "*", command = "wincmd =", desc = "resize splits automatically for tmux" }
)
