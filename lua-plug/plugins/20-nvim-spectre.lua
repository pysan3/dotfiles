local function call_spectre(method, opts)
  return function()
    require("spectre")[method](opts or {})
  end
end

return {
  "windwp/nvim-spectre",
  keys = {
    { "<Leader>S", call_spectre("open"), remap = false },
    { "<Leader>sw", call_spectre("open_visual", { select_word = true }), remap = false },
    { "<Leader>s", call_spectre("open_visual"), remap = false },
    { "<Leader>sp", call_spectre("open_file_search"), remap = false },
  },
  config = {},
}
