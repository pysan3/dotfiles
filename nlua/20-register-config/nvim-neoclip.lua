require("neoclip").setup({
  history = 1000,
  preview = true,
  content_spec_column = true,
  db_path = vim.fn.stdpath("data") .. "/databases/neoclip.sqlite3",
  enable_persistent_history = true,
  continuous_sync = true,
  keys = {
    telescope = {
      i = {
        select = "<cr>",
        paste = "<c-o>",
        paste_behind = "<c-i>",
        replay = "<c-q>", -- replay a macro
        delete = "<c-d>", -- delete an entry
        custom = {},
      },
      n = {
        select = "<cr>",
        paste = "p",
        paste_behind = "P",
        replay = "q",
        delete = "d",
        custom = {},
      },
    },
  },
  filter = function(data)
    for _, entry in ipairs(data.event.regcontents) do
      if vim.fn.match(entry, [[^\s*$]]) == -1 then
        return true
      end
    end
    return false
  end,
})

require("telescope").load_extension("neoclip")
