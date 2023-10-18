local function spider_key(map, motion)
  return {
    map,
    string.format([[<Cmd>lua require("spider").motion("%s")<CR>]], motion),
    desc = "Spider: " .. motion,
    mode = { "n", "o", "x" },
  }
end

return {
  "chrisgrieser/nvim-spider",
  keys = {
    spider_key("H", "b"),
    spider_key("L", "w"),
  },
  opts = {
    skipInsignificantPunctuation = true,
  },
}
