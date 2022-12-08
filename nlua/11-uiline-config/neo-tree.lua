vim.g.neo_tree_remove_legacy_commands = 1
local neotree = require("neo-tree")
neotree.setup({
  close_if_last_window = true,
  enable_diagnostics = true,
  enable_git_status = true,
  enable_modified_markers = true,
  enable_refresh_on_write = true,
  git_status_async = true,
  git_status_async_options = {
    batch_size = 1000,
    batch_delay = 10,
    max_lines = 10000,
  },
  hide_root_node = true,
  retain_hidden_root_indent = false,
  resize_timer_interval = -1, -- in ms, needed for containers to redraw right aligned and faded content
  log_level = "trace",
  log_to_file = true,
  sort_case_insensitive = true,
  source_selector = {
    winbar = true,
    separator = { left = '▍', right = '▐', override = "active" },
  },
  default_component_configs = {
    container = {
      enable_character_fade = true,
    },
    indent = {
      indent_size = 2,
      padding = 0,
    },
    icon = {
      folder_empty = "",
      default = "",
      highlight = "None",
    },
    modified = {
      symbol = "[+]",
      highlight = "NeoTreeModified",
    },
    name = {
      trailing_slash = false,
      use_git_status_colors = true,
      highlight = "NeoTreeFileName",
    },
    git_status = {
      symbols = {
        added = "",
        modified = "",
        deleted = "",
        renamed = "凜",
        untracked = "✚",
        ignored = "",
        unstaged = "",
        staged = "",
        conflict = "",
      },
      align = "right",
    },
  },
  renderers = {
    directory = {
      { "indent" },
      { "icon" },
      { "current_filter" },
      {
        "container",
        width = "100%",
        right_padding = 1,
        content = {
          { "name", zindex = 10 },
          {
            "symlink_target",
            zindex = 10,
            highlight = "NeoTreeSymbolicLinkTarget",
          },
          { "clipboard", zindex = 10 },
          { "diagnostics", errors_only = true, zindex = 20, align = "right" },
        },
      },
    },
    file = {
      { "indent" },
      { "icon" },
      {
        "container",
        width = "100%",
        right_padding = 1,
        content = {
          { "name", use_git_status_colors = true, zindex = 10 },
          {
            "symlink_target",
            zindex = 10,
            highlight = "NeoTreeSymbolicLinkTarget",
          },
          { "clipboard", zindex = 10 },
          { "bufnr", zindex = 10 },
          { "modified", zindex = 20, align = "right" },
          { "diagnostics", zindex = 20, align = "right" },
          { "git_status", zindex = 20, align = "right" },
        },
      },
    },
    message = {
      { "indent", with_markers = false },
      { "name", highlight = "NeoTreeMessage" },
    },
    terminal = {
      { "indent" },
      { "icon" },
      { "name" },
      { "bufnr" },
    },
  },
  nesting_rules = {},
  window = { -- see https://github.com/MunifTanjim/nui.nvim/tree/main/lua/nui/popup for
    position = "left",
    width = 40,
    mapping_options = {
      noremap = true,
      nowait = true,
    },
    mappings = {
      ["<space>"] = { "toggle_node", nowait = false },
      ["<2-LeftMouse>"] = "open",
      ["<cr>"] = "open",
      ["l"] = "open",
      ["s"] = "open_split",
      ["v"] = "open_vsplit",
      ["t"] = "open_tabnew",
      ["C"] = "close_node",
      ["h"] = "close_node",
      ["z"] = "close_all_nodes",
      ["R"] = "refresh",
      ["P"] = { "toggle_preview", config = { use_float = true } },
      ["a"] = { "add", config = { show_path = "relative" } },
      ["A"] = "add_directory",
      ["d"] = "delete",
      ["r"] = "rename",
      ["y"] = "copy_to_clipboard",
      ["x"] = "cut_to_clipboard",
      ["p"] = "paste_from_clipboard",
      ["c"] = "copy",
      ["m"] = "move",
      ["q"] = "close_window",
      ["?"] = "show_help",
    },
  },
  filesystem = {
    window = {
      mappings = {
        ["H"] = "toggle_hidden",
        ["/"] = "fuzzy_finder",
        ["f"] = "filter_on_submit",
        ["<C-x>"] = "clear_filter",
        ["<bs>"] = "navigate_up",
        ["."] = "set_root",
        ["[g"] = "prev_git_modified",
        ["]g"] = "next_git_modified",
        ["o"] = "system_open",
        ["D"] = "trash",
      },
    },
    commands = {
      system_open = function(state)
        vim.api.nvim_command(string.format("silent !xdg-open '%s'", state.tree:get_node():get_id()))
      end,
      trash = function(state)
        local inputs = require("neo-tree.ui.inputs")
        local path = state.tree:get_node().path
        local msg = "Are you sure you want to delete " .. path
        inputs.confirm(msg, function(confirmed)
          if not confirmed then return end
          vim.fn.system({ "trash-put", vim.fn.fnameescape(path) })
          require("neo-tree.sources.manager").refresh(state.name)
        end)
      end
    },
    bind_to_cwd = false, -- true creates a 2-way binding between vim's cwd and neo-tree's root
    filtered_items = {
      visible = false, -- when true, they will just be displayed differently than normal items
      force_visible_in_empty_folder = false,
      show_hidden_count = true,
      hide_dotfiles = false,
      hide_gitignored = false,
      hide_by_name = {
        ".DS_Store",
        "thumbs.db",
      },
      hide_by_pattern = {
        "*.meta",
        "*:Zone.Identifier",
      },
      never_show = {
        ".DS_Store",
        "thumbs.db",
      },
    },
    find_by_full_path_words = true,
    group_empty_dirs = true,
    follow_current_file = true,
    hijack_netrw_behavior = "open_default",
    use_libuv_file_watcher = true,
  },
  git_status = {
    window = {
      mappings = {
        ["A"] = "git_add_all",
        ["gu"] = "git_unstage_file",
        ["ga"] = "git_add_file",
        ["gr"] = "git_revert_file",
        ["gc"] = "git_commit",
        ["gp"] = "git_push",
        ["gg"] = "git_commit_and_push",
      },
    },
  },
  event_handlers = {
    {
      event = "file_opened",
      handler = function(_)
        neotree.close_all()
      end,
    },
  },
})
