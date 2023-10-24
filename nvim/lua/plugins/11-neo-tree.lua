return {
  "nvim-neo-tree/neo-tree.nvim",
  dev = vim.g.personal_options.debug.neotree,
  dependencies = {
    { "MunifTanjim/nui.nvim" },
    { "nvim-tree/nvim-web-devicons" },
  },
  cmd = { "Neotree" },
  keys = {
    { "<Leader>e", "<Cmd>Neotree toggle reveal<CR>", remap = false, silent = true, desc = "<Cmd>Neotree<CR>" },
  },
  init = function()
    vim.g.neo_tree_remove_legacy_commands = 1
    ---@type string[]
    local argv = vim.fn.argv() or {} ---@diagnostic disable-line
    if vim.tbl_contains(argv, ".") then
      vim.schedule(function()
        pcall(require, "neo-tree")
      end)
    end
  end,
  opts = {
    sources = {
      "filesystem",
      "buffers",
      "git_status",
      "document_symbols",
    },
    auto_clean_after_session_restore = true,
    close_if_last_window = true,
    log_level = vim.g.personal_options.debug.neotree and "trace" or "fatal",
    log_to_file = vim.g.personal_options.debug.neotree,
    sort_case_insensitive = true,
    source_selector = {
      winbar = true,
      sources = {
        { source = "filesystem", display_name = " 󰉓 File " },
        { source = "git_status", display_name = " 󰊢 Git " },
        { source = "buffers", display_name = " 󰓩 Buf " },
        { source = "document_symbols", display_name = "  Sym " },
      },
      content_layout = "center",
    },
    default_component_configs = {
      container = {
        enable_character_fade = true,
      },
      indent = {
        padding = 0,
      },
      icon = {
        folder_empty = "",
        default = "",
        highlight = "None",
      },
      modified = {
        symbol = "[+]",
      },
      git_status = {
        symbols = {
          deleted = "󰧧",
          renamed = "󰁕",
          untracked = "",
          unstaged = "󰄱",
        },
      },
      file_size = { enabled = true },
      type = { enabled = true },
      last_modified = { enabled = false },
      created = { enabled = false },
      symlink_target = { enabled = false },
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
          if not confirmed then
            return
          end
          vim.fn.system({ "trash-put", vim.fn.fnameescape(path) })
          require("neo-tree.sources.manager").refresh(state.name)
        end)
      end,
    },
    window = {
      position = "float",
      -- popup = { size = { width = "80%" } },
      auto_expand_width = false,
      mappings = {
        ["l"] = "open",
        ["s"] = "open_split",
        ["v"] = "open_vsplit",
        ["h"] = "close_node",
        ["a"] = { "add", config = { show_path = "relative" } },
        ["A"] = "add_directory",
        ["P"] = { "toggle_preview", config = { use_float = true, use_image_nvim = true } },
      },
    },
    filesystem = {
      window = {
        mappings = {
          ["/"] = "noop",
          ["f"] = "filter_on_submit",
          ["O"] = "system_open",
          ["D"] = "trash",
        },
      },
      bind_to_cwd = false,
      filtered_items = {
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
      follow_current_file = {
        enabled = true,
        leave_dirs_open = true,
      },
      hijack_netrw_behavior = "open_current",
      use_libuv_file_watcher = true,
    },
    document_symbols = {
      kinds = vim.tbl_map(function(value)
        return { icon = value }
      end, vim.g.personal_options.lsp_icons),
    },
    event_handlers = {
      {
        event = "file_opened",
        handler = function(_)
          require("neo-tree.sources.manager").close_all()
        end,
      },
      {
        event = "neo_tree_window_after_open",
        handler = function(args)
          if args.position == "left" or args.position == "right" then
            vim.cmd.wincmd("=")
          end
        end,
      },
      {
        event = "neo_tree_window_after_close",
        handler = function(args)
          if args.position == "left" or args.position == "right" then
            vim.cmd.wincmd("=")
          end
        end,
      },
    },
  },
}
