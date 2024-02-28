local function extensions(name, opt)
  return function()
    local telescope = require("telescope")
    require("neoclip")
    telescope.load_extension("neoclip")
    vim.notify("Press name of register.")
    local key = string.char(vim.fn.getchar() or 0)
    if string.match(key, "[%w]") then
      return telescope.extensions[name][key](opt or {})
    elseif string.match(key, '["+*]') then
      local lot = { ['"'] = "unnamed", ["+"] = "plus", ["*"] = "star" }
      return telescope.extensions[name][lot[key]](opt or {})
    else
      vim.notify(string.format([[`%s` is not a valid register. Aborting.]], key), vim.log.levels.ERROR)
    end
  end
end

return {
  "AckslD/nvim-neoclip.lua",
  dependencies = {
    "telescope.nvim",
    { "kkharji/sqlite.lua", module = "sqlite" },
  },
  event = { "VeryLazy" },
  keys = {
    { vim.g.personal_options.prefix.telescope .. "g", extensions("neoclip"), desc = "Neoclip reg" },
    { vim.g.personal_options.prefix.telescope .. "q", extensions("macroscope"), desc = "Neoclip macro" },
    {
      "<C-y>",
      function()
        vim.cmd.stopinsert()
        extensions("neoclip")()
      end,
      mode = "i",
      desc = "Neoclip reg <i>",
    },
  },
  opts = {
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
