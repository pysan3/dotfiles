local function spider_keybinds(key)
  return {
    key,
    function()
      require("spider").motion(key)
    end,
    desc = "Spider-" .. key,
    mode = { "n", "o", "x" },
  }
end

return {
  "chrisgrieser/nvim-spider",
  keys = {
    spider_keybinds("w"),
    spider_keybinds("e"),
    spider_keybinds("b"),
    spider_keybinds("ge"),
  },
}
