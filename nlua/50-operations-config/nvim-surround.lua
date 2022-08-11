-- Since `vim.fn.input()` does not handle keyboard interrupts, we use a protected call to check whether the user has
-- used `<C-c>` to cancel the input. This is not needed if `<Esc>` is used to cancel the input.
local get_input = function(prompt)
  local ok, result = pcall(vim.fn.input, { prompt = prompt })
  if not ok then
    return nil
  end
  return result
end

-- Gets a selection from the buffer based on some heuristic.
---@param args { char: string?, pattern: string?, textobject: string? }
---@return any?: The retrieved selection.
local get_selection = function(args)
  if args.pattern then
    return require("nvim-surround.patterns").get_selection(args.pattern)
  elseif args.textobject then
    return require("nvim-surround.textobjects").get_selection(args.textobject)
  end
end

-- Gets a pair of selections from the buffer based on some heuristic.
---@param args { char: string?, pattern: string? }
local get_selections = function(args)
  if args.char and args.pattern then
    return require("nvim-surround.utils").get_selections(args.char, args.pattern)
  end
end

require("nvim-surround").setup({
  keymaps = {
    insert = "<C-g>s",
    insert_line = "<C-g>S",
    normal = "ys",
    normal_cur = "yss",
    normal_line = "yS",
    normal_cur_line = "ySS",
    visual = "S",
    visual_line = "gS",
    delete = "ds",
    change = "cs",
  },
  surrounds = {
    ["("] = {
      add = { "( ", " )" },
      find = function()
        return get_selection({ textobject = "(" })
      end,
      delete = "^(. ?)().-( ?.)()$",
      change = {
        target = "^(. ?)().-( ?.)()$",
      },
    },
    [")"] = {
      add = { "(", ")" },
      find = function()
        return get_selection({ textobject = ")" })
      end,
      delete = "^(.)().-(.)()$",
      change = {
        target = "^(.)().-(.)()$",
      },
    },
    ["{"] = {
      add = { "{ ", " }" },
      find = function()
        return get_selection({ textobject = "{" })
      end,
      delete = "^(. ?)().-( ?.)()$",
      change = {
        target = "^(. ?)().-( ?.)()$",
      },
    },
    ["}"] = {
      add = { "{", "}" },
      find = function()
        return get_selection({ textobject = "}" })
      end,
      delete = "^(.)().-(.)()$",
      change = {
        target = "^(.)().-(.)()$",
      },
    },
    ["<"] = {
      add = { "< ", " >" },
      find = function()
        return get_selection({ textobject = "<" })
      end,
      delete = "^(. ?)().-( ?.)()$",
      change = {
        target = "^(. ?)().-( ?.)()$",
      },
    },
    [">"] = {
      add = { "<", ">" },
      find = function()
        return get_selection({ textobject = ">" })
      end,
      delete = "^(.)().-(.)()$",
      change = {
        target = "^(.)().-(.)()$",
      },
    },
    ["["] = {
      add = { "[ ", " ]" },
      find = function()
        return get_selection({ textobject = "[" })
      end,
      delete = "^(. ?)().-( ?.)()$",
      change = {
        target = "^(. ?)().-( ?.)()$",
      },
    },
    ["]"] = {
      add = { "[", "]" },
      find = function()
        return get_selection({ textobject = "]" })
      end,
      delete = "^(.)().-(.)()$",
      change = {
        target = "^(.)().-(.)()$",
      },
    },
    ["'"] = {
      add = { "'", "'" },
      find = function()
        return get_selection({ textobject = "'" })
      end,
      delete = "^(.)().-(.)()$",
      change = {
        target = "^(.)().-(.)()$",
      },
    },
    ['"'] = {
      add = { '"', '"' },
      find = function()
        return get_selection({ textobject = '"' })
      end,
      delete = "^(.)().-(.)()$",
      change = {
        target = "^(.)().-(.)()$",
      },
    },
    ["`"] = {
      add = { "`", "`" },
      find = function()
        return get_selection({ textobject = "`" })
      end,
      delete = "^(.)().-(.)()$",
      change = {
        target = "^(.)().-(.)()$",
      },
    },
    ["i"] = {
      add = function()
        local left_delimiter = get_input("Enter the left delimiter: ")
        local right_delimiter = left_delimiter and get_input("Enter the right delimiter: ")
        if right_delimiter then
          return { { left_delimiter }, { right_delimiter } }
        end
      end,
      find = function() end,
      delete = function() end,
      change = { target = function() end },
    },
    ["t"] = {
      add = function()
        local input = get_input("Enter the HTML tag: ")
        if input then
          local element = input:match("^<?([%w-]*)")
          local attributes = input:match("%s+([^>]+)>?$")

          local open = attributes and element .. " " .. attributes or element
          local close = element

          return { { "<" .. open .. ">" }, { "</" .. close .. ">" } }
        end
      end,
      find = function()
        return get_selection({ textobject = "t" })
      end,
      delete = "^(%b<>)().-(%b<>)()$",
      change = {
        target = "^<([%w-]*)().-([^/]*)()>$",
        replacement = function()
          local element = get_input("Enter the HTML element: ")
          if element then
            return { { element }, { element } }
          end
        end,
      },
    },
    ["T"] = {
      add = function()
        local input = get_input("Enter the HTML tag: ")
        if input then
          local element = input:match("^<?([%w-]*)")
          local attributes = input:match("%s+([^>]+)>?$")

          local open = attributes and element .. " " .. attributes or element
          local close = element

          return { { "<" .. open .. ">" }, { "</" .. close .. ">" } }
        end
      end,
      find = function()
        return get_selection({ textobject = "t" })
      end,
      delete = "^(%b<>)().-(%b<>)()$",
      change = {
        target = "^<([^>]*)().-([^%/]*)()>$",
        replacement = function()
          local input = get_input("Enter the HTML tag: ")
          if input then
            local element = input:match("^<?([%w-]*)")
            local attributes = input:match("%s+([^>]+)>?$")

            local open = attributes and element .. " " .. attributes or element
            local close = element

            return { { open }, { close } }
          end
        end,
      },
    },
    ["f"] = {
      add = function()
        local result = get_input("Enter the function name: ")
        if result then
          return { { result .. "(" }, { ")" } }
        end
      end,
      find = "[%w%-_:.>]+%b()",
      delete = "^([%w%-_:.>]+%()().-(%))()$",
      change = {
        target = "^.-([%w_]+)()%b()()()$",
        replacement = function()
          local result = get_input("Enter the function name: ")
          if result then
            return { { result }, { "" } }
          end
        end,
      },
    },
    invalid_key_behavior = {
      add = function(char)
        return { { char }, { char } }
      end,
      find = function(char)
        return get_selection({
          pattern = vim.pesc(char) .. ".-" .. vim.pesc(char),
        })
      end,
      delete = function(char)
        return get_selections({
          char = char,
          pattern = "^(.)().-(.)()$",
        })
      end,
      change = {
        target = function(char)
          return get_selections({
            char = char,
            pattern = "^(.)().-(.)()$",
          })
        end,
      },
    },
  },
  aliases = {
    ["a"] = ">",
    ["b"] = ")",
    ["B"] = "}",
    ["r"] = "]",
    ["q"] = { '"', "'", "`" },
    ["s"] = { "}", "]", ")", ">", '"', "'", "`" },
  },
  highlight = {
    duration = 0,
  },
  move_cursor = "begin",
})
