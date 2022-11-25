local telescope = require("telescope")
local actions = require("telescope.actions")

telescope.setup({
  defaults = {
    mappings = {
      i = {
        ["<esc>"] = actions.close,
        ["jk"] = actions.close,
        -- cycle through previously done searches
        ["<C-j>"] = actions.cycle_history_next,
        ["<C-k>"] = actions.cycle_history_prev,
        ["<Down>"] = actions.cycle_history_next,
        ["<Up>"] = actions.cycle_history_prev,
      },
    },
    cache_picker = { num_pickers = 3 }, -- default 1
    -- put prompt (input box) position to the top
    layout_config = {
      prompt_position = "top",
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
      "--color=never",
      "--no-heading",
      "--with-filename",
      "--line-number",
      "--column",
      "--smart-case",
      "--trim",
    },
  },
  pickers = {
    -- remove ./ from fd results
    find_files = {
      find_command = { "fd", "--type", "f", "--strip-cwd-prefix" },
    },
  },
  extensions = {
    fzf = {
      fuzzy = true, -- false will only do exact matching
      override_generic_sorter = true, -- override the generic sorter
      override_file_sorter = true, -- override the file sorter
      case_mode = "smart_case", -- or "ignore_case" or "respect_case", the default case_mode is "smart_case"
    },
    media_files = {
      filetypes = { "png", "webp", "jpg", "jpeg", "mp4", "pdf" },
      find_cmd = "rg",
    },
  },
})

telescope.load_extension("fzf")
telescope.load_extension("media_files")
telescope.load_extension("dap")

local ts_builtin = require("telescope.builtin")
local ts_prefix = "<leader>f"

-- telescope fzf bindings
vim.keymap.set("n", ts_prefix .. "f", ts_builtin.buffers, { desc = "ts.buffers" })
vim.keymap.set("n", ts_prefix .. "p", ts_builtin.git_files, { desc = "ts.git_files" })
vim.keymap.set("n", ts_prefix .. "l", ts_builtin.find_files, { desc = "ts.find_files" })
vim.keymap.set("n", ts_prefix .. "s", ts_builtin.live_grep, { desc = "ts.live_grep" })
vim.keymap.set("n", ts_prefix .. "h", ts_builtin.help_tags, { desc = "ts.help_tags" })
vim.keymap.set("n", ts_prefix .. "r", ts_builtin.resume, { desc = "ts.resume" })
vim.keymap.set("n", ts_prefix .. "j", ts_builtin.jumplist, { desc = "ts.jumplist" })
vim.keymap.set("n", ts_prefix .. "e", ts_builtin.symbols, { desc = "ts.symbols" })
vim.keymap.set("n", ts_prefix .. "C", ts_builtin.commands, { desc = "ts.commands" })
vim.keymap.set("n", ts_prefix .. "c", ts_builtin.command_history, { desc = "ts.command_history" })
vim.keymap.set("n", ts_prefix .. "i", telescope.extensions.media_files.media_files, { desc = "ts.media_files" })

-- telescope lsp bindings
vim.keymap.set("n", ts_prefix .. "t", ts_builtin.lsp_document_symbols, { desc = "ts.lsp_document_symbols" })
vim.keymap.set("n", ts_prefix .. "y", ts_builtin.lsp_workspace_symbols, { desc = "ts.lsp_workspace_symbols" })
vim.keymap.set("n", ts_prefix .. "m", "<Cmd>TodoTelescope<CR>", { desc = "TodoTelescope @folke/todo-comments.nvim" })

-- telescope git bindings
local ts_prefix_git = ts_prefix .. "g"
vim.keymap.set("n", ts_prefix_git .. "c", ts_builtin.git_commits, { desc = "ts.git_commits" })
vim.keymap.set("n", ts_prefix_git .. "l", ts_builtin.git_bcommits, { desc = "ts.git_bcommits" })
vim.keymap.set("n", ts_prefix_git .. "b", ts_builtin.git_branches, { desc = "ts.git_branches" })

-- telescope dap bindings
local ts_prefix_dap = ts_prefix .. "d"
vim.keymap.set("n", ts_prefix_dap .. "m", function()
  telescope.extensions.dap.commands({})
end, { desc = "ts.dap.commands({})" })
vim.keymap.set("n", ts_prefix_dap .. "c", function()
  telescope.extensions.dap.configurations({})
end, { desc = "ts.dap.configurations({})" })
vim.keymap.set("n", ts_prefix_dap .. "b", function()
  telescope.extensions.dap.list_breakpoints({})
end, { desc = "ts.dap.list_breakpoints({})" })
vim.keymap.set("n", ts_prefix_dap .. "v", function()
  telescope.extensions.dap.variables({})
end, { desc = "ts.dap.variables({})" })
vim.keymap.set("n", ts_prefix_dap .. "f", function()
  telescope.extensions.dap.frames({})
end, { desc = "ts.dap.frames({})" })

-- telescope other bindings
vim.keymap.set("n", "<leader>" .. ts_prefix .. "c", ts_builtin.colorscheme, { desc = "ts.colorscheme" })
