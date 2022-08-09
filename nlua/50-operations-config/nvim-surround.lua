-- Since `vim.fn.input()` does not handle keyboard interrupts, we use a protected call to check whether the user has
-- used `<C-c>` to cancel the input. This is not needed if `<Esc>` is used to cancel the input.
local get_input = function(prompt)
  local ok, result = pcall(vim.fn.input, { prompt = prompt })
  if not ok then
    return nil
  end
  return result
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
    pairs = {
      ["("] = { "( ", " )" },
      [")"] = { "(", ")" },
      ["{"] = { "{ ", " }" },
      ["}"] = { "{", "}" },
      ["<"] = { "< ", " >" },
      [">"] = { "<", ">" },
      ["["] = { "[ ", " ]" },
      ["]"] = { "[", "]" },
      ["i"] = function()
        local left_delimiter = get_input("Enter the left delimiter: ")
        if left_delimiter then
          local right_delimiter = get_input("Enter the right delimiter: ")
          if right_delimiter then
            return { left_delimiter, right_delimiter }
          end
        end
      end,
      ["f"] = function()
        local result = get_input("Enter the function name: ")
        if result then
          return { result .. "(", ")" }
        end
      end,
    },
    separators = {
      ["'"] = { "'", "'" },
      ['"'] = { '"', '"' },
      ["`"] = { "`", "`" },
    },
    HTML = {
      ["t"] = "type",
      ["T"] = "whole",
    },
    aliases = {
      ["a"] = ">",
      ["b"] = ")",
      ["B"] = "}",
      ["r"] = "]",
      ["q"] = { '"', "'", "`" },
      ["s"] = { "}", "]", ")", ">", '"', "'", "`" },
    },
  },
  highlight = {
    duration = 0,
  },
  move_cursor = "begin",
})
