vim.g.nvim_tree_git_hl = 1 -- 0 by default, will enable file highlight for git attributes (can be used without the icons).
vim.g.nvim_tree_show_icons = { git = 0, folders = 1, files = 1, folder_arrows = 1 }
vim.g.nvim_tree_group_empty = 1 --  0 by default, compact folders that only contain a single folder into one node in the file tree
vim.g.nvim_tree_respect_buf_cwd = 1 -- 0 by default, will change cwd of nvim-tree to that of new buffer's when opening nvim-tree.
vim.g.nvim_tree_icons = { default = "" } -- fallback icon for unknown filetypes

vim.cmd([[
nnoremap <leader>e :NvimTreeFindFileToggle<CR>
]])

require("nvim-tree").setup({
  hijack_cursor = true,
  hijack_unnamed_buffer_when_opening = true,
  update_cwd = false,
  view = {
    -- auto_resize = false,
    -- preserve_window_proportions = true,
    signcolumn = "no",
    mappings = {
      custom_only = false,
      list = {
        { key = { "l", "<CR>", "o" }, action = "edit" },
        { key = "v", action = "vsplit" },
        { key = "h", action = "close_node" },
        { key = "X", action = "trash" },
      },
    },
  },
  renderer = {
    indent_markers = {
      enable = true,
      icons = {
        corner = "└ ",
        edge = "│ ",
        none = "  ",
      },
    },
  },
  update_focused_file = {
    enable = true,
    update_cwd = false,
    ignore_list = {},
  },
  ignore_ft_on_setup = {},
  system_open = {
    cmd = nil,
    args = {},
  },
  diagnostics = {
    enable = true,
    icons = { hint = "", info = "", warning = "", error = "" },
  },
  git = {
    enable = true,
    ignore = false,
    timeout = 500,
  },
  actions = {
    open_file = {
      quit_on_open = true,
      resize_window = true,
    },
  },
  trash = {
    cmd = "trash-put",
    require_confirm = true,
  },
})
