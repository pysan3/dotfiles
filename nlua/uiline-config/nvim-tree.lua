vim.g.nvim_tree_git_hl = 1 -- 0 by default, will enable file highlight for git attributes (can be used without the icons).
vim.g.nvim_tree_show_icons = { git = 0, folders = 1, files = 1, folder_arrows = 1 }
vim.g.nvim_tree_group_empty = 1 --  0 by default, compact folders that only contain a single folder into one node in the file tree
vim.g.nvim_tree_respect_buf_cwd = 1 -- 0 by default, will change cwd of nvim-tree to that of new buffer's when opening nvim-tree.
vim.g.nvim_tree_icons = { default = "" } -- fallback icon for unknown filetypes

vim.cmd([[
nnoremap <leader>e :NvimTreeFindFileToggle<CR>
]])

require("nvim-tree").setup({
  hide_root_folder = false,
  hijack_cursor = true,
  hijack_unnamed_buffer_when_opening = true,
  update_cwd = false,
  -- update_to_buf_dir = {
  --   enable = true,
  --   auto_open = true,
  -- },
  view = {
    -- auto_resize = false,
    preserve_window_proportions = true,
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
  trash = {
    cmd = "trash-put",
    require_confirm = true,
  },
})
