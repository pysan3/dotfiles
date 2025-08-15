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
    desc = "Gitsigns: " .. dir,
  })
end

return {
  "lewis6991/gitsigns.nvim",
  event = "VeryLazy",
  cond = vim.g.personal_options.use_git_plugins,
  keys = {
    move_hunk("]g", "next_hunk"),
    move_hunk("[g", "prev_hunk"),
    map({ vim.g.personal_options.prefix.gitsigns .. "s", "<Cmd>Gitsigns stage_hunk<CR>" }),
    map({ vim.g.personal_options.prefix.gitsigns .. "r", "<Cmd>Gitsigns reset_hunk<CR>" }),
    map({ vim.g.personal_options.prefix.gitsigns .. "S", "<Cmd>Gitsigns stage_buffer<CR>" }),
    map({ vim.g.personal_options.prefix.gitsigns .. "u", "<Cmd>Gitsigns undo_stage_hunk<CR>" }),
    map({ vim.g.personal_options.prefix.gitsigns .. "t", "<Cmd>Gitsigns toggle_deleted<CR>" }),
    map({ vim.g.personal_options.prefix.gitsigns .. "R", "<Cmd>Gitsigns reset_buffer<CR>" }),
    map({ vim.g.personal_options.prefix.gitsigns .. "v", "<Cmd>Gitsigns preview_hunk<CR>" }),
    map({ vim.g.personal_options.prefix.gitsigns .. "d", "<Cmd>Gitsigns diffthis<CR>" }),
    map({
      vim.g.personal_options.prefix.gitsigns .. "D",
      function()
        require("gitsigns").diffthis("~")
      end,
      desc = "Gitsigns: diffthis('~')",
    }),
    map({
      vim.g.personal_options.prefix.gitsigns .. "b",
      function()
        require("gitsigns").blame_line({ full = true })
      end,
      desc = "Gitsigns: blame_line({ full = true })",
    }),
    map({ "ih", "<Cmd><C-u>Gitsigns select_hunk<CR>", mode = { "o", "x" } }),
  },
  opts = {
    current_line_blame = true,
    current_line_blame_opts = {
      delay = 500,
    },
  },
}
