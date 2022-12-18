local function be(plugin)
  plugin.event = { "BufRead", "BufNewFile", "BufEnter" }
  return plugin
end

return {
  be({ "norcalli/nvim-colorizer.lua" }),
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "main",
    -- "~/Git/neo-tree.nvim",
    requires = {
      { "MunifTanjim/nui.nvim", module = { "nui" } },
      { "kyazdani42/nvim-web-devicons", module = { "nvim-web-devicons" } },
    },
    cmd = { "Neotree" },
    module = { "neo-tree" },
    wants = { "nui.nvim", "nvim-web-devicons", "plenary.nvim" },
    setup = function()
      vim.keymap.set("n", "<leader>e", "<Cmd>Neotree toggle<CR>", { remap = false, silent = true })
    end
  },
  {
    "akinsho/bufferline.nvim", -- bufferline
    event = { "InsertEnter", "CursorHold", "FocusLost", "BufRead", "BufNewFile" },
    requires = {
      { "kyazdani42/nvim-web-devicons", module = { "nvim-web-devicons" } }
    },
    wants = { "nvim-web-devicons" },
    cmd = { "BufferLineGoToBuffer", "BufferLineCycleNext", "BufferLineCyclePrev", "BufferLinePick", "BufferLine" },
    module = { "bufferline" },
  },
  {
    "nvim-lualine/lualine.nvim", -- lualine
    event = { "InsertEnter", "CursorHold", "FocusLost", "BufRead", "BufNewFile" },
    requires = {
      { "kyazdani42/nvim-web-devicons", module = { "nvim-web-devicons" } }
    },
    wants = { "nvim-web-devicons" },
    module = { "lualine" },
  },
  be({
    "Yggdroot/indentLine", -- show indent line with |
    config = function()
      vim.g.indentLine_char = "▏"
      vim.g.indentLine_bufTypeExclude = { "help", "terminal", "neo-tree" }
    end,
  }),
}
