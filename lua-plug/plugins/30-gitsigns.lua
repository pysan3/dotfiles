local function map(a)
  a.noremap = true
  a.silent = true
  return a
end

return {
  "lewis6991/gitsigns.nvim",
  event = "VeryLazy",
  keys = {
    map({ "]c", "&diff ? ']c' : '<Cmd>Gitsigns next_hunk<CR>'", expr = true }),
    map({ "[c", "&diff ? '[c' : '<Cmd>Gitsigns prev_hunk<CR>'", expr = true }),
    map({ "<leader>hs", "<Cmd>Gitsigns stage_hunk<CR>" }),
    map({ "<leader>hs", "<Cmd>Gitsigns stage_hunk<CR>" }),
    map({ "<leader>hr", "<Cmd>Gitsigns reset_hunk<CR>" }),
    map({ "<leader>hr", "<Cmd>Gitsigns reset_hunk<CR>" }),
    map({ "<leader>hS", "<Cmd>Gitsigns stage_buffer<CR>" }),
    map({ "<leader>hu", "<Cmd>Gitsigns undo_stage_hunk<CR>" }),
    map({ "<leader>hR", "<Cmd>Gitsigns reset_buffer<CR>" }),
    map({ "<leader>hv", "<Cmd>Gitsigns preview_hunk<CR>" }),
    map({ "<leader>hb", '<Cmd>lua require"gitsigns".blame_line{full=true}<CR>' }),
    map({ "<leader>hd", "<Cmd>Gitsigns diffthis<CR>" }),
    map({ "<leader>hD", '<Cmd>lua require"gitsigns".diffthis("~"),<CR>' }),
    map({ "<leader>td", "<Cmd>Gitsigns toggle_deleted<CR>" }),
    map({ "ih", "<Cmd><C-U>Gitsigns select_hunk<CR>" }),
    map({ "ih", "<Cmd><C-U>Gitsigns select_hunk<CR>" }),
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
