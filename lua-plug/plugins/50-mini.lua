local function surround_setup()
  require("mini.surround").setup({
    mappings = {
      add = "gza", -- Add surrounding in Normal and Visual modes
      delete = "gzd", -- Delete surrounding
      find = "gzf", -- Find surrounding (to the right)
      find_left = "gzF", -- Find surrounding (to the left)
      highlight = "gzh", -- Highlight surrounding
      replace = "gzr", -- Replace surrounding
      update_n_lines = "gzn", -- Update `n_lines`
    },
  })
end

local function ai_setup()
  local ai = require("mini.ai")
  require("mini.ai").setup({
    n_lines = 500,
    -- search_method = "cover_or_next",
    custom_textobjects = {
      o = ai.gen_spec.treesitter({
        a = { "@block.outer", "@conditional.outer", "@loop.outer" },
        i = { "@block.inner", "@conditional.inner", "@loop.inner" },
      }, {}),
      f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }, {}),
      c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }, {}),
    },
  })
  local map = function(text_obj, desc)
    for _, side in ipairs({ "left", "right" }) do
      for dir, d in pairs({ prev = "[", next = "]" }) do
        local lhs = d .. (side == "right" and text_obj:upper() or text_obj:lower())
        for _, mode in ipairs({ "n", "x", "o" }) do
          vim.keymap.set(mode, lhs, function()
            ai.move_cursor(side, "a", text_obj, { search_method = dir })
          end, {
            desc = dir .. " " .. desc,
          })
        end
      end
    end
  end
  map("f", "function")
  map("c", "class")
  map("o", "block")
end

local function animate_setup()
  local mouse_scrolled = false
  for _, scroll in ipairs({ "Up", "Down" }) do
    local key = "<ScrollWheel" .. scroll .. ">"
    vim.keymap.set("", key, function()
      mouse_scrolled = true
      return key
    end, { remap = true, expr = true })
  end
  local animate = require("mini.animate")
  vim.go.winwidth = 20
  vim.go.winminwidth = 5
  animate.setup({
    resize = {
      timing = animate.gen_timing.linear({ duration = 100, unit = "total" }),
    },
    scroll = {
      timing = animate.gen_timing.linear({ duration = 150, unit = "total" }),
      subscroll = animate.gen_subscroll.equal({
        predicate = function(total_scroll)
          if mouse_scrolled then
            mouse_scrolled = false
            return false
          end
          return total_scroll > 1
        end,
      }),
    },
  })
end

return {
  "echasnovski/mini.nvim", -- surround
  event = "VeryLazy",
  dependencies = {
    "JoosepAlviste/nvim-ts-context-commentstring",
  },
  keys = {
    { "<Leader>bd", function()
      require("mini.bufremove").delete(0, false)
    end, desc = "mini.bufremove: false" },
    { "<Leader>bD", function()
      require("mni.bufremove").delete(0, true)
    end, desc = "mini.bufremove: true" },
  },
  config = function()
    -- require("mini.jump").setup({})
    surround_setup()
    ai_setup()
    require("mini.pairs").setup({})
    require("mini.comment").setup({
      hooks = {
        pre = function()
          require("ts_context_commentstring.internal").update_commentstring({})
        end,
      },
    })
    -- animate_setup()
  end,
}
