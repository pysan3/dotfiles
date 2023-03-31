return {
  "hkupty/iron.nvim",
  cmd = { "IronRepl", "IronRestart", "IronFocus", "IronHide" },
  keys = {
    { vim.g.personal_options.prefix.iron .. "r", "<Cmd>IronRepl<CR>", noremap = true },
    { vim.g.personal_options.prefix.iron .. "R", "<Cmd>IronRestart<CR>", noremap = true },
    { vim.g.personal_options.prefix.iron .. "i", "<Cmd>IronFocus<CR>A", noremap = true },
    { vim.g.personal_options.prefix.iron .. "h", "<Cmd>IronHide<CR>", noremap = true },
  },
  config = function()
    local view = require("iron.view")
    require("iron.core").setup({
      config = {
        scratch_repl = true,
        repl_definition = {
          sh = { command = { "zsh" } },
        },
        -- repl_open_cmd = view.split.vertical("40%"),
        repl_open_cmd = view.offset({
          width = "40%",
          height = "100%",
          w_offset = view.helpers.flip(0),
          h_offset = view.helpers.proportion(0.5),
        }),
      },
      keymaps = {
        send_motion = vim.g.personal_options.prefix.iron .. "s",
        visual_send = vim.g.personal_options.prefix.iron .. "s",
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
      highlight = { italic = true },
      ignore_blank_lines = true,
    })
  end,
}
