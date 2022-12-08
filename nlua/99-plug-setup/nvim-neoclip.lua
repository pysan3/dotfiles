local function extensions(name, prop)
  return function(opt)
    local telescope = require("telescope")
    require(name)
    telescope.load_extension(name)
    return telescope.extensions[name][prop](opt or {})
  end
end

vim.keymap.set("n", "<Leader>fb", extensions("neoclip", "neoclip"), {})
vim.keymap.set("n", "<Leader>fq", extensions("neoclip", "macroscope"), {})
vim.keymap.set("i", "<C-b>", function()
  vim.cmd("stopinsert")
  extensions("neoclip", "neoclip")()
end, {})
