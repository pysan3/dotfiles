return {
  "hkupty/iron.nvim",
  cmd = { "IronRepl", "IronRestart", "IronFocus", "IronHide" },
  keys = {
    { vim.g.personal_options.prefix.iron .. "s", "<Cmd>IronRepl<CR>", noremap = true },
    { vim.g.personal_options.prefix.iron .. "r", "<Cmd>IronRestart<CR>", noremap = true },
    { vim.g.personal_options.prefix.iron .. "f", "<Cmd>IronFocus<CR>", noremap = true },
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
        send_motion = "<space>sc",
        visual_send = "<space>sc",
        send_file = "<space>sf",
        send_line = "<space>sl",
        send_mark = "<space>sm",
        mark_motion = "<space>mc",
        mark_visual = "<space>mc",
        remove_mark = "<space>md",
        cr = "<space>s<cr>",
        interrupt = "<space>s<space>",
        exit = "<space>sq",
        clear = "<space>cl",
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
