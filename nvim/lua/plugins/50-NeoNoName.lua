local function go_next()
  vim.cmd("BufferLineCycleNext")
end

return {
  "nyngwang/NeoNoName.lua",
  dependencies = { "akinsho/bufferline.nvim" },
  keys = {
    {
      "<Leader>Q",
      function()
        local no_name = require("neo-no-name")
        no_name.neo_no_name(go_next)
      end,
      desc = "[NeoNoName]: bufdelete single",
    },
    {
      "<Leader><Leader>q",
      function()
        local no_name = require("neo-no-name")
        no_name.neo_no_name(go_next)
        no_name.neo_no_name(go_next)
      end,
      desc = "[NeoNoName]: bufdelete double",
    },
  },
  config = {
    should_skip = function()
      return vim.bo.buftype == "terminal"
    end,
    go_next_on_delete = true,
  },
}
