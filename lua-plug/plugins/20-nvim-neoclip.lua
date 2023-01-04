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
    { "tami5/sqlite.lua" },
  },
  keys = {
    { "<Leader>fb", extensions("neoclip", "neoclip") },
    { "<Leader>fq", extensions("neoclip", "macroscope") },
    { "<C-y>", function()
      vim.cmd("stopinsert")
      extensions("neoclip", "neoclip")()
    end, mode = "i" },
  }
}