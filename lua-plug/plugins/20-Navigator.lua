local function navigator_keymap(key, method)
  return {
    key,
    function()
      require("Navigator")[method]()
    end,
    desc = "Navigator: " .. method,
    mode = { "n", "v", "o", "i", "c", "t" },
  }
end

return {
  "numToStr/Navigator.nvim",
  keys = {
    navigator_keymap("<A-h>", "left"),
    navigator_keymap("<A-l>", "right"),
    navigator_keymap("<A-k>", "up"),
    navigator_keymap("<A-j>", "down"),
    navigator_keymap("<A-p>", "previous"),
  }
}
