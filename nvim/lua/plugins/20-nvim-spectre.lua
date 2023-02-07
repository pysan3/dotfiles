local function call_spectre(method, opts)
  return function()
    require("spectre")[method](opts or {})
  end
end

return {
  "windwp/nvim-spectre",
  keys = {
    { "<Leader>S", call_spectre("open"), remap = false, desc = [[Spectre: "open"]] },
    { "<Leader>sw", call_spectre("open_visual", { select_word = true }), remap = false,
      desc = [[Spectre: "open_visual", { select_word = true }]] },
    { "<Leader>s", call_spectre("open_visual"), remap = false, desc = [[Spectre: "open_visual"]] },
    { "<Leader>sp", call_spectre("open_file_search"), remap = false, desc = [[Spectre: "open_file_search"]] },
  },
  config = {},
}
