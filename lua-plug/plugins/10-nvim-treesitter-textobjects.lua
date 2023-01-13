local M = {
  "nvim-treesitter/nvim-treesitter-textobjects",
  event = "BufReadPre",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
  },
}

M.config = function()
  require("nvim-treesitter.configs").setup({
    textobjects = {
      select = {
        enable = true,
        lookahead = true,
        keymaps = {
          ["af"] = "@function.outer",
          ["if"] = "@function.inner",
          ["ac"] = "@class.outer",
          ["ic"] = "@class.inner",
          ["aa"] = "@parameter.outer",
          ["ia"] = "@parameter.inner",
        },
        selection_modes = {
          ["@function.outer"] = "V", -- linewise
          ["@class.outer"] = "V", -- blockwise
        },
      },
      swap = {
        enable = true,
        swap_next = {
          ["<leader>m]"] = "@parameter.inner",
        },
        swap_previous = {
          ["<leader>m["] = "@parameter.inner",
        },
      },
      move = {
        enable = true,
        set_jumps = true,
        goto_next_start = {
          ["]m"] = "@function.outer",
          ["]l"] = "@class.outer",
        },
        goto_next_end = {
          ["]M"] = "@function.outer",
          ["]L"] = "@class.outer",
        },
        goto_previous_start = {
          ["[m"] = "@function.outer",
          ["[l"] = "@class.outer",
        },
        goto_previous_end = {
          ["[M"] = "@function.outer",
          ["[L"] = "@class.outer",
        },
      },
    },
  })
end

return M
