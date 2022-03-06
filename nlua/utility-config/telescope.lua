local telescope = require("telescope")
local actions = require("telescope.actions")

telescope.setup({
  defaults = {
    mappings = {
      i = {
        ["<esc>"] = actions.close,
        -- cycle through previously done searches
        ["<C-j>"] = actions.cycle_history_next,
        ["<C-k>"] = actions.cycle_history_prev,
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

vim.cmd([[
nnoremap <leader>fp <cmd>Telescope git_files<CR>
nnoremap <leader>fl <cmd>Telescope find_files<CR>
nnoremap <leader>fs <cmd>Telescope live_grep<CR>
nnoremap <leader>fh <cmd>Telescope help_tags<CR>
nnoremap <leader>fr <cmd>Telescope resume<CR>
nnoremap <leader>fi <cmd>Telescope media_files<CR>
]])
