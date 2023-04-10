local utils = require("norg-config.utils")

local M = {
  neorg_aug = vim.api.nvim_create_augroup("NeorgWritePre", { clear = true }),
}

local function format_on_save(_)
  vim.api.nvim_create_autocmd("BufWritePre", {
    group = M.neorg_aug,
    pattern = "*.norg",
    desc = "Neorg: format current file on save",
    callback = function()
      vim.cmd([[
      StripWhitespace
      normal m`=gG``
      ]])
    end,
  })
end

local function export_to_markdown(_)
  vim.api.nvim_create_autocmd("FileWritePost", {
    group = M.neorg_aug,
    pattern = "*.norg",
    desc = "Neorg: export to markdown file if file already exists",
    callback = function()
      utils.export_file(".md", { only_overwrite = true, open_file = false })
    end,
  })
end

local function rename_file_with_spaces(_)
  vim.api.nvim_create_autocmd("BufWinEnter", {
    group = M.neorg_aug,
    pattern = "*.norg",
    desc = "Neorg: rename file if filename contains whitespace to underscore",
    callback = function()
      local file = vim.fn.expand("<afile>")
      local dir, file_name = vim.fn.fnamemodify(file, ":p:h"), vim.fn.fnamemodify(file, ":p:t")
      local new_name = string.gsub(file_name, " ", "_")
      if file_name == new_name then
        return
      end
      local res, err = os.rename(dir .. "/" .. file_name, dir .. "/" .. new_name)
      if not res then
        vim.notify(err or string.format("Failed to rename: `%s` -> `%s`", file_name, new_name), vim.log.levels.ERROR)
        return
      end
      vim.schedule(function()
        vim.api.nvim_buf_delete(0, {})
        vim.cmd.edit(dir .. "/" .. new_name)
      end)
    end,
  })
end

local function jump_with_braces(_)
  local function goto_headline(which)
    local ts_utils = require("nvim-treesitter.ts_utils")
    local tsparser = vim.treesitter.get_parser()
    local tstree = tsparser:parse()
    local root = tstree[1]:root()
    local cursor = vim.api.nvim_win_get_cursor(0)
    local cursor_range = { cursor[1] - 1, cursor[2] }
    -- Query all headings (from 1 to 6)
    local query = vim.treesitter.query.parse(
      "norg",
      [[
    (heading1) @h1
    (heading2) @h2
    (heading3) @h3
    (heading4) @h4
    (heading5) @h5
    (heading6) @h6
    ]]
    )
    local previous_headline = nil
    local next_headline = nil
    -- Find the previous and next heading from the captures
    for _, captures, metadata in query:iter_matches(root) do ---@diagnostic disable-line
      for _, node in pairs(captures) do
        local row = node:start()
        if row < cursor_range[1] then
          previous_headline = node
        elseif row > cursor_range[1] and next_headline == nil then
          next_headline = node
          break
        end
      end
    end
    if which == "previous" then
      ts_utils.goto_node(previous_headline)
    elseif which == "next" then
      ts_utils.goto_node(next_headline)
    end
  end
  -- Go to previous headline
  local function goto_previous_headline()
    goto_headline("previous")
  end
  -- Go to next headline
  local function goto_next_headline()
    goto_headline("next")
  end
  -- define keybinds
  vim.api.nvim_create_augroup("NeorgKeymaps", { clear = true })
  vim.api.nvim_create_autocmd("FileType", {
    pattern = { "norg" },
    callback = function()
      vim.keymap.set("n", "{", goto_previous_headline, { desc = "Neorg: Go to previous headline", buffer = true })
      vim.keymap.set("n", "}", goto_next_headline, { desc = "Neorg: Go to next headline", buffer = true })
    end,
  })
end

M.setup = function(opts)
  format_on_save(opts)
  export_to_markdown(opts)
  rename_file_with_spaces(opts)
  jump_with_braces(opts)
end

return M
