return {
  "toppair/peek.nvim",
  build = "deno task --quiet build",
  keys = {
    { "<leader>op", "<Cmd>PeekToggle<CR>", desc = "Peek (Markdown Preview)" },
  },
  cmd = { "PeekToggle" },
  init = function()
    vim.api.nvim_create_user_command("PeekToggle", function()
      local peek = require("peek")
      if peek.is_open() then
        peek.close()
      else
        peek.open()
      end
    end, { force = true })
  end,
  config = function()
    require("peek").setup({
      theme = "dark", -- "dark" or "light"
    })
  end,
}
