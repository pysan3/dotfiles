return {
  "akinsho/toggleterm.nvim",
  cmd = { "ToggleTerm" },
  keys = {
    { "<esc>", [[<C-\><C-n>]], noremap = true, mode = "t" },
    { "jk", [[<C-\><C-n>]], noremap = true, mode = "t" },
    { "<C-h>", [[<C-\><C-n><C-W>h]], noremap = true, mode = "t" },
    { "<C-j>", [[<C-\><C-n><C-W>j]], noremap = true, mode = "t" },
    { "<C-k>", [[<C-\><C-n><C-W>k]], noremap = true, mode = "t" },
    { "<C-l>", [[<C-\><C-n><C-W>l]], noremap = true, mode = "t" },
    { [[<C-\>]], "<Cmd>ToggleTerm<CR>" },
  },
  config = {
    size = 12,
    open_mapping = [[<C-\>]],
    hide_numbers = true,
    shade_filetypes = {},
    shade_terminals = true,
    shading_factor = 2,
    start_in_insert = true,
    insert_mappings = true,
    persist_size = true,
    direction = "horizontal",
    close_on_exit = true,
    shell = vim.o.shell,
    float_opts = {
      border = "curved",
      winblend = 0,
      highlights = {
        border = "Normal",
        background = "Normal",
      },
    },
  }
}
