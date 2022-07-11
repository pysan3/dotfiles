require("nvim-tree").setup({
  disable_netrw = true,
  hijack_cursor = true,
  hijack_unnamed_buffer_when_opening = true,
  update_cwd = false,
  respect_buf_cwd = true,
  view = {
    width = 40,
    signcolumn = "no",
    centralize_selection = true,
    mappings = {
      custom_only = false,
      list = {
        { key = { "l", "<CR>", "o" }, action = "edit" },
        { key = "v", action = "vsplit" },
        { key = "s", action = "split" },
        { key = "h", action = "close_node" },
        { key = "X", action = "trash" },
      },
    },
  },
  filters = {
    dotfiles = true,
    custom = { ".*:Zone\\.Identifier$" },
  },
  renderer = {
    full_name = true,
    icons = {
      show = { git = false, folder = true, file = true, folder_arrow = true },
      git_placement = "after",
      glyphs = {
        default = "",
        git = {
          -- added = "✚",
          deleted = "",
          -- modified = "",
          renamed = "凜",
          untracked = "✚",
          ignored = "",
          unstaged = "",
          staged = "",
          -- conflict = "",
        },
      },
    },
    indent_markers = {
      enable = true,
      icons = { corner = "└ ", edge = "│ ", none = "  " },
    },
    highlight_git = true,
    group_empty = true,
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

vim.keymap.set("n", "<leader>E", "<Cmd>NvimTreeFindFileToggle<CR>", { remap = false, silent = true })
