local M = {
  "RRethy/vim-illuminate",
  event = { "VeryLazy" },
  dependencies = {
    { "nvim-lspconfig" },
  },
}

M.keys = {
  {
    "]]",
    function()
      require("illuminate").goto_next_reference(false)
    end,
    desc = "Next Reference",
  },
  {
    "[[",
    function()
      require("illuminate").goto_prev_reference(false)
    end,
    desc = "Prev Reference",
  },
}

M.config = function()
  require("illuminate").configure({
    providers = { "lsp", "treesitter", "regex" },
    delay = 100,
    filetype_overrides = {},
    filetypes_denylist = {
      "dirvish",
      "fugitive",
    },
  })
  vim.api.nvim_set_hl(0, "IlluminatedWordText", { bg = "#2C313C" })
  vim.api.nvim_set_hl(0, "IlluminatedWordRead", { bg = "#2C313C" })
  vim.api.nvim_set_hl(0, "IlluminatedWordWrite", { bg = "#2C313C" })
end

return M
