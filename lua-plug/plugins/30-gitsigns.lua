local function map(a)
  a.noremap = true
  a.silent = true
  return a
end

local function move_hunk(key, dir)
  return map({
    key,
    function()
      if vim.wo.diff then
        return key
      end
      vim.schedule(function()
        require("gitsigns")[dir]()
      end)
      return "<Ignore>"
    end,
    expr = true,
  })
end

return {
  "lewis6991/gitsigns.nvim",
  event = "VeryLazy",
  keys = {
    move_hunk("]c", "next_hunk"),
    move_hunk("[c", "prev_hunk"),
    map({ vim.g.personal_options.prefix.gitsigns .. "s", "<Cmd>Gitsigns stage_hunk<CR>" }),
    map({ vim.g.personal_options.prefix.gitsigns .. "s", "<Cmd>Gitsigns stage_hunk<CR>" }),
    map({ vim.g.personal_options.prefix.gitsigns .. "r", "<Cmd>Gitsigns reset_hunk<CR>" }),
    map({ vim.g.personal_options.prefix.gitsigns .. "r", "<Cmd>Gitsigns reset_hunk<CR>" }),
    map({ vim.g.personal_options.prefix.gitsigns .. "S", "<Cmd>Gitsigns stage_buffer<CR>" }),
    map({ vim.g.personal_options.prefix.gitsigns .. "u", "<Cmd>Gitsigns undo_stage_hunk<CR>" }),
    map({ vim.g.personal_options.prefix.gitsigns .. "t", "<Cmd>Gitsigns toggle_deleted<CR>" }),
    map({ vim.g.personal_options.prefix.gitsigns .. "R", "<Cmd>Gitsigns reset_buffer<CR>" }),
    map({ vim.g.personal_options.prefix.gitsigns .. "v", "<Cmd>Gitsigns preview_hunk<CR>" }),
    map({ vim.g.personal_options.prefix.gitsigns .. "d", "<Cmd>Gitsigns diffthis<CR>" }),
    map({ vim.g.personal_options.prefix.gitsigns .. "D", function()
      require("gitsigns").diffthis("~")
    end }),
    map({ vim.g.personal_options.prefix.gitsigns .. "b", function()
      require("gitsigns").blame_line({ full = true })
    end }),
    map({ "ih", "<Cmd><C-u>Gitsigns select_hunk<CR>", mode = { "o", "x" } }),
  },
  init = function()
    vim.cmd([[
    highlight GitGutterAdd    guifg=#227700 ctermfg=2
    highlight GitGutterChange guifg=#2222ff ctermfg=3
    highlight GitGutterDelete guifg=#880000 ctermfg=1
    ]])
  end,
  config = {
    -- signs = {}, https://github.com/lewis6991/gitsigns.nvim/blob/main/lua/gitsigns/config.lua
    signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
    numhl = false, -- Toggle with `:Gitsigns toggle_numhl`
    linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
    word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
    watch_gitdir = {
      interval = 1000,
      follow_files = true,
    },
    attach_to_untracked = true,
    current_line_blame = true, -- Toggle with `:Gitsigns toggle_current_line_blame`
    current_line_blame_opts = {
      virt_text = true,
      virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
      delay = 1000,
      ignore_whitespace = true,
    },
    current_line_blame_formatter_opts = {
      relative_time = false,
    },
    sign_priority = 6,
    update_debounce = 100,
    status_formatter = nil, -- Use default
    max_file_length = 40000,
    preview_config = {
      -- Options passed to nvim_open_win
      border = "single",
      style = "minimal",
      relative = "cursor",
      row = 1,
      col = 1,
    },
    yadm = {
      enable = false,
    },
  }
}
