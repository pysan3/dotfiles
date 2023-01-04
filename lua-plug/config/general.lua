_G.general_info = {
  username = "pysan3",
  email = "pysan3@gmail.com",
  github = "https://github.com/pysan3",
  real_name = "Takuto Itoi",
}

vim.g.personal_options = {
  colorscheme = os.getenv("NVIM_COLOR") or "nvcode",
  lsp_saga = {
    enable = true,
    winbar = true,
  },
  prefix = {
    telescope = "<Leader>f",
    gitsigns = "<Leader>h",
    neogit = "<Leader>g",
    fugitive = "<Leader>l",
    iron = "<Leader>r",
    lsp = "<Leader>k",
  },
}


local function merge_table(a)
  return function(t)
    return vim.g.personal_module.add_table_string(t, a)
  end
end

vim.g.personal_module = {
  ---Check if path exists in filesystem
  ---@param path string: path to check
  ---@param is_config boolean?: if true, path is treated in a lua require format
  ---@return boolean
  exists = function(path, is_config)
    if is_config then
      path = string.format("%s/lua/%s.lua", vim.fn.stdpath("config"), string.gsub(path, "%.", "/"))
    end
    local st = vim.loop.fs_stat(path)
    return st and true or false
  end,
  --- add multiple lists without overwriting any table
  ---@vararg string[] | nil: tables to merge together
  ---@return string[]: single table merged together
  add_table_string = function(...)
    local res = {} ---@type string[]
    for _, t in pairs({ ... }) do
      for _, v in ipairs(t) do
        res[#res + 1] = v
      end
    end
    return res
  end,
  md = merge_table({ "markdown", "html", "NeogitCommitMessage", "gitcommit", "octo" }),
}

vim.opt.completeopt = "menuone,noselect"
vim.opt.cmdheight = 0

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
