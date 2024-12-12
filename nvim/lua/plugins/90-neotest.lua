local function map(key)
  return "<Leader>t" .. key
end

return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-neotest/nvim-nio",
    "nvim-lua/plenary.nvim",
    "antoinemadec/FixCursorHold.nvim",
    "nvim-treesitter/nvim-treesitter",
    "nvim-neotest/neotest-python",
    "nvim-coverage",
  },
  keys = {
    {
      map("r"),
      function()
        require("neotest").run.run()
      end,
    },
    {
      map("f"),
      function()
        require("neotest").run.run(vim.fn.expand("%"))
      end,
    },
    {
      map("w"),
      function()
        require("neotest").watch.toggle()
      end,
    },
    {
      map("W"),
      function()
        require("neotest").watch.toggle(vim.fn.expand("%"))
      end,
    },
    {
      map("p"),
      function()
        require("neotest").output_panel.toggle()
      end,
    },
    {
      "[e",
      function()
        require("neotest").jump.prev()
      end,
    },
    {
      "]e",
      function()
        require("neotest").jump.next()
      end,
    },
    {
      "[E",
      function()
        require("neotest").jump.prev({ status = "failed" })
      end,
    },
    {
      "]E",
      function()
        require("neotest").jump.next({ status = "failed" })
      end,
    },
  },
  config = function()
    require("neotest").setup({
      adapters = {
        require("neotest-python")({
          dap = { justMyCode = false },
        }),
        -- require("neotest-plenary"),
        -- require("neotest-vim-test")({
        --   ignore_file_types = { "python", "vim", "lua" },
        -- }),
      },
    })
  end,
}
