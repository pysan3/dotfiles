local telescope = require("telescope")
local actions = require("telescope.actions")

local function stopinsert(callback)
  return function(prompt_bufnr)
    vim.cmd.stopinsert()
    vim.schedule(function()
      callback(prompt_bufnr)
    end)
  end
end

telescope.setup({
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
        -- workaround for telescope file selection
        ["<CR>"] = stopinsert(actions.select_default),
        ["<C-x>"] = stopinsert(actions.select_horizontal),
        ["<C-v>"] = stopinsert(actions.select_vertical),
        ["<C-t>"] = stopinsert(actions.select_tab)
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
