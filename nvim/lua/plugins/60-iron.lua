return {
  "hkupty/iron.nvim",
  cmd = { "IronRepl", "IronRestart", "IronFocus", "IronHide" },
  keys = {
    { vim.g.personal_options.prefix.iron .. "s", "<Cmd>IronRepl<CR>", noremap = true },
    { vim.g.personal_options.prefix.iron .. "r", "<Cmd>IronRestart<CR>", noremap = true },
    { vim.g.personal_options.prefix.iron .. "h", "<Cmd>IronHide<CR>", noremap = true },
  },
  config = function()
    require("iron.core").setup({
      config = {
        -- Whether a repl should be discarded or not
        scratch_repl = true,
        -- Your repl definitions come here
        repl_definition = {
          sh = {
            -- Can be a table or a function that
            -- returns a table (see below)
            command = { "zsh" },
          },
        },
        -- How the repl window will be displayed
        -- See below for more information
        repl_open_cmd = require("iron.view").split.vertical("40%"),
      },
      -- Iron doesn't set keymaps by default anymore.
      -- You can set them here or manually add keymaps to the functions in iron.core
      keymaps = {
        send_motion = vim.g.personal_options.prefix.iron .. "c",
        visual_send = vim.g.personal_options.prefix.iron .. "c",
        send_file = vim.g.personal_options.prefix.iron .. "f",
        send_line = vim.g.personal_options.prefix.iron .. "l",
        send_mark = vim.g.personal_options.prefix.iron .. "k",
        mark_motion = vim.g.personal_options.prefix.iron .. "m",
        mark_visual = vim.g.personal_options.prefix.iron .. "m",
        remove_mark = vim.g.personal_options.prefix.iron .. "d",
        cr = vim.g.personal_options.prefix.iron .. "<cr>",
        interrupt = vim.g.personal_options.prefix.iron .. "<space>",
        clear = vim.g.personal_options.prefix.iron .. "x",
        exit = vim.g.personal_options.prefix.iron .. "q",
      },
      -- If the highlight is on, you can change how it looks
      -- For the available options, check nvim_set_hl
      highlight = {
        italic = true,
      },
      ignore_blank_lines = true, -- ignore blank lines when sending visual select lines
    })
  end,
}
