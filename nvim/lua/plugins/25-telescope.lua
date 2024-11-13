local tl_prefix = vim.g.personal_options.prefix.telescope
local ls_prefix = vim.g.personal_options.prefix.lsp

local function telescope_keymap(key, picker, func, pre_leader, lsp_prefix, opts)
  local prefix = lsp_prefix and ls_prefix or tl_prefix
  return {
    (pre_leader and "<Leader>" or "") .. prefix .. key,
    func or function()
      local suc, _ = pcall(require("telescope.builtin")[picker], opts)
      if not suc then
        require("telescope.builtin").find_files(opts)
      end
    end,
    desc = "Telescope: " .. picker,
  }
end

local hide = {
  file_ignore_patterns = {
    "poetry.lock",
  },
  additional_args = function(_)
    return { "--hidden" }
  end,
}

local M = {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    { "BurntSushi/ripgrep" },
    { "natecraddock/telescope-zf-native.nvim", build = "make" },
    { "nvim-telescope/telescope-symbols.nvim" },
    { "folke/trouble.nvim" },
  },
  keys = {
    -- telescope fzf bindings
    telescope_keymap("f", "buffers"),
    telescope_keymap("l", "find_files"),
    telescope_keymap("s", "live_grep"),
    telescope_keymap("h", "help_tags"),
    telescope_keymap("r", "resume"),
    telescope_keymap("j", "jumplist"),
    telescope_keymap("e", "symbols"),
    telescope_keymap("k", "keymaps"),
    telescope_keymap("C", "commands"),
    telescope_keymap("c", "command_history"),
    -- telescope lsp bindings
    telescope_keymap("t", "lsp_document_symbols", nil, nil, true),
    telescope_keymap("y", "lsp_workspace_symbols", nil, nil, true),
    telescope_keymap("f", "lsp_references", nil, nil, true),
    telescope_keymap("g", "lsp_definitions", nil, nil, true),
    telescope_keymap("D", "diagnostics", nil, nil, true),
    -- telescope git bindings
    telescope_keymap("p", "git_files"),
    telescope_keymap("m", "git_commits"),
    telescope_keymap("M", "git_bcommits"),
    telescope_keymap("b", "git_branches"),
    -- telescope other bindings
    telescope_keymap("c", "colorscheme", nil, true),
    telescope_keymap("o", "todo", "<Cmd>TodoTelescope<CR>"),
  },
}

M.config = function()
  local actions = require("telescope.actions")
  require("telescope").setup({
    defaults = {
      mappings = {
        i = {
          ["<esc>"] = actions.close,
          ["jk"] = actions.close,
          ["<C-e>"] = require("telescope.actions.layout").toggle_preview,
          -- cycle through previously done searches
          ["<C-j>"] = actions.cycle_history_next,
          ["<C-k>"] = actions.cycle_history_prev,
          ["<Down>"] = actions.cycle_history_next,
          ["<Up>"] = actions.cycle_history_prev,
          ["<C-g>"] = actions.to_fuzzy_refine,
          -- open quickfix list in trouble.nvim
          ["<C-q>"] = function(...)
            actions.smart_send_to_qflist(...)
            return require("trouble").open({ mode = "qflist", refresh = true })
          end,
        },
      },
      cache_picker = { num_pickers = 3 }, -- default 1
      -- put prompt (input box) position to the top
      layout_strategy = "horizontal",
      layout_config = {
        prompt_position = "top",
        preview_width = 0.5,
      },
      -- put results in ascending order
      sorting_strategy = "ascending",
      -- shorten file names displayed
      path_display = {
        shorten = { len = 1, exclude = { -1, -2 } },
        smart = true,
        truncate = true,
      },
      -- ripgrep remove indentation
      vimgrep_arguments = {
        "rg",
        "-HnS.", -- hidden, line-number, smart-case, hidden
        "--color=never",
        "--no-heading",
        "--column",
        "--trim",
        "--no-ignore",
        "-g=!.git",
        "-g=!node_modules",
        "-g=!.venv",
        "-g=!htmlcov",
        "-g=!tmp",
        "-g=!.coverage*",
        "-g=!.*_cache",
      },
    },
    pickers = {
      -- remove ./ from fd results
      find_files = {
        find_command = { "fd", "-HIL", "-t=f", "--strip-cwd-prefix" },
        hidden = true,
      },
      live_grep = hide,
      grep_string = hide,
    },
    extensions = {
      ["zf-native"] = {
        file = {
          enable = true,
          highlight_results = true,
          match_filename = true,
        },
        generic = {
          enable = true,
          highlight_results = true,
          match_filename = false,
        },
      },
    },
  })

  require("telescope").load_extension("zf-native")
end

return M
