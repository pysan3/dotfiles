vim.g.nvim_tree_indent_markers = 1 -- 0 by default, this option shows indent markers when folders are open
vim.g.nvim_tree_git_hl = 1 -- 0 by default, will enable file highlight for git attributes (can be used without the icons).
vim.g.nvim_tree_show_icons = { git = 0, folders = 1, files = 1, folder_arrows = 1 }
vim.g.nvim_tree_group_empty = 1 --  0 by default, compact folders that only contain a single folder into one node in the file tree
vim.g.nvim_tree_respect_buf_cwd = 1 -- 0 by default, will change cwd of nvim-tree to that of new buffer's when opening nvim-tree.
vim.g.nvim_tree_icons = { default = "" } -- fallback icon for unknown filetypes

vim.cmd([[
nnoremap <leader>e :NvimTreeFindFileToggle<CR>
]])

require("nvim-tree").setup({
  disable_netrw = true,
  hijack_netrw = true,
  open_on_setup = false,
  ignore_ft_on_setup = {},
  auto_close = true,
  auto_reload_on_write = true,
  open_on_tab = false,
  hijack_cursor = true,
  hijack_unnamed_buffer_when_opening = true,
  update_cwd = false,
  update_to_buf_dir = {
    enable = true,
    auto_open = true,
  },
  diagnostics = {
    enable = true,
    icons = { hint = "", info = "", warning = "", error = "" },
  },
  update_focused_file = {
    enable = true,
    update_cwd = false,
    ignore_list = {},
  },
  system_open = {
    cmd = nil,
    args = {},
  },
  filters = {
    dotfiles = false,
    custom = {},
  },
  git = {
    enable = true,
    ignore = false,
    timeout = 500,
  },
  view = {
    width = 30,
    height = 30,
    hide_root_folder = false,
    side = "left",
    auto_resize = false,
    mappings = {
      custom_only = false,
      list = {
        { key = { "l", "<CR>", "o" }, action = "edit" },
        { key = "v", action = "vsplit" },
        { key = "h", action = "close_node" },
      },
    },
    number = false,
    relativenumber = false,
    signcolumn = "no",
  },
  trash = {
    cmd = "trash-put",
    require_confirm = true,
  },
  actions = {
    change_dir = {
      enable = true,
      global = false,
    },
    open_file = {
      quit_on_open = true,
      resize_window = true,
      window_picker = {
        enable = true,
        chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890",
        exclude = {
          filetype = { "notify", "packer", "qf", "diff", "fugitive", "fugitiveblame" },
          buftype = { "nofile", "terminal", "help" },
        },
      },
    },
  },
})
