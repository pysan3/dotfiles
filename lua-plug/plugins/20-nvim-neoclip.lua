local function extensions(name, prop)
  return function(opt)
    local telescope = require("telescope")
    require(name)
    telescope.load_extension(name)
    return telescope.extensions[name][prop](opt or {})
  end
end

return {
  "AckslD/nvim-neoclip.lua",
  dependencies = {
    { 'nvim-telescope/telescope.nvim' },
    { "tami5/sqlite.lua" },
  },
  keys = {
    { vim.g.personal_options.prefix.telescope .. "g", extensions("neoclip", "neoclip"), desc = "Neoclip reg" },
    { vim.g.personal_options.prefix.telescope .. "q", extensions("neoclip", "macroscope"), desc = "Neoclip macro" },
    { "<C-y>", function()
      vim.cmd("stopinsert")
      extensions("neoclip", "neoclip")()
      vim.cmd("startinsert")
    end, mode = "i", desc = "Neoclip reg <i>" },
  },
  config = {
    history = 1000,
    preview = true,
    content_spec_column = true,
    db_path = vim.fn.stdpath("data") .. "/databases/neoclip.sqlite3",
    enable_persistent_history = true,
    enable_macro_history = true,
    continuous_sync = true,
    on_select = { move_to_front = true, set_reg = true },
    on_paste = { move_to_front = true, set_reg = true },
    on_replay = { move_to_front = true, set_reg = true },
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
  },
}
