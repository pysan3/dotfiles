_G.general_info = {
  username = "pysan3",
  email = "pysan3@gmail.com",
  github = "https://github.com/pysan3",
}

vim.g.personal_options = {
  colorscheme = vim.env.NVIM_COLOR or "jellybeans-nvim",
  use_transparent = (vim.env.NVIM_USE_TRANSPARENT or "0") ~= "0",
  lsp_saga = {
    enable = false,
    winbar = false,
  },
  prefix = {
    telescope = "<Leader>f",
    gitsigns = "<Leader>h",
    neogit = "<Leader>g",
    fugitive = "<Leader>l",
    iron = "<Leader>r",
    lsp = "<Leader>k",
  },
  -- stylua: ignore
  lsp_icons = {
    Array = "",
    Boolean = "◩",
    Class = "",
    Color = "",
    Constant = "",
    Constructor = " ",
    Enum = " ",
    EnumMember = " ",
    Event = "",
    Field = "",
    File = "",
    Folder = "",
    Function = "",
    Interface = "",
    Key = "",
    Keyword = "",
    Method = "",
    Module = "",
    Namespace = "",
    Null = "ﳠ",
    Number = "",
    Object = "",
    Operator = "",
    Package = "",
    Property = " ",
    Reference = "",
    Snippet = "",
    String = "",
    Struct = " ",
    Text = "",
    TypeParameter = "",
    Unit = "",
    Value = "",
    Variable = ""
  },
}

local function merge_table(a)
  return function(t)
    return vim.g.personal_module.add_table_string(t, a)
  end
end

local buf_lookup = {}
local function check_buf(bufid, f)
  return vim.api.nvim_buf_is_loaded(bufid) and vim.api.nvim_buf_get_name(bufid) == f
end

local function go_to_buf(filepath)
  if vim.api.nvim_buf_get_name(0) == filepath then
    buf_lookup[filepath] = vim.api.nvim_get_current_buf()
    return
  end
  if buf_lookup[filepath] and check_buf(buf_lookup[filepath], filepath) then
    vim.api.nvim_set_current_buf(buf_lookup[filepath])
    return
  end
  for _, bufid in ipairs(vim.api.nvim_list_bufs()) do
    if check_buf(bufid, filepath) then
      vim.api.nvim_set_current_buf(bufid)
      buf_lookup[filepath] = bufid
      return
    end
  end
  vim.cmd.edit(filepath)
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
  ---Add multiple lists without overwriting any table
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
  ---Open buf of filepath if exists, and new if not
  ---@param filepath string? absolute path to filename
  ---@param check_exists boolean? check if filename exists beforehand
  ---@param cursor_pos { line: integer?, col: integer? }? set cursor position if not nil, values default to 0
  move_to_buf_pos = function(filepath, check_exists, cursor_pos)
    if check_exists and filepath and not vim.g.personal_module.exists(filepath, false) then
      return
    end
    if filepath then
      go_to_buf(filepath)
    end
    if cursor_pos then
      vim.api.nvim_win_set_cursor(0, { cursor_pos.line or 0, cursor_pos.col or 0 })
    end
  end,
}

-- neovim specific options
vim.opt.completeopt = "menuone,noselect"
vim.opt.cmdheight = 0
vim.opt.exrc = true

-- global status line
vim.opt.laststatus = 3
vim.opt.fillchars = "vert:┃,horiz:━,verthoriz:╋,horizup:┻,horizdown:┳,vertleft:┫,vertright:┣,eob: " -- more obvious separator
vim.cmd([[
highlight WinSeparator guibg=None
]])

vim.api.nvim_create_autocmd("VimResized", {
  desc = "Resize Splits Automatically for Tmux",
  group = vim.api.nvim_create_augroup("WinAlignInTmux", { clear = true }),
  pattern = "*",
  command = "wincmd =",
})
vim.api.nvim_create_autocmd("BufWritePre", {
  desc = "Auto Format Japanese Punctuations in Latex Files",
  group = vim.api.nvim_create_augroup("ChangePuncOnSave", { clear = true }),
  pattern = "*.tex",
  command = [[
  silent! %s/、/，/g
  silent! %s/。/．/g
  ]],
})
