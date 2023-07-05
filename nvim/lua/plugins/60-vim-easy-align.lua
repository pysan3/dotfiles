local function set_cursor_to_nth_bar(row, count)
  local line = vim.api.nvim_buf_get_lines(0, row, row + 1, false)[1]
  local cur_bar_count = 0
  local cur_col = 0
  while cur_bar_count < count do
    cur_col = line:find("|", cur_col + 1)
    cur_bar_count = cur_bar_count + 1
  end
  vim.api.nvim_win_set_cursor(0, { row + 1, cur_col })
  vim.cmd.startinsert({ bang = true })
end

local function on_bar_inserted()
  local pos = vim.api.nvim_win_get_cursor(0)
  local row = pos[1] - 1
  local col = pos[2]
  local before_line = vim.api.nvim_get_current_line()
  local _, pre_bar_count = before_line:sub(0, col):gsub("|", "|")
  vim.api.nvim_buf_set_text(0, row, col, row, col, { "|" })
  vim.cmd.stopinsert()
  vim.cmd.normal("vip")
  vim.api.nvim_feedkeys("ga*|", "v", false)
  vim.schedule(function()
    set_cursor_to_nth_bar(row, pre_bar_count + 1)
  end)
end

local function callback_func()
  vim.keymap.set("i", "<Bar>", on_bar_inserted, { desc = "Align Tables", silent = true, buffer = true })
end

local filetypes = vim.g.personal_module.md()

return {
  "junegunn/vim-easy-align",
  ft = filetypes,
  cmd = { "EasyAlign" },
  keys = {
    { "ga", "<Plug>(EasyAlign)", noremap = false, mode = { "n", "x" } },
  },
  config = function()
    if vim.list_contains(filetypes, vim.bo.filetype) then
      callback_func()
    end
    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("AlignMDTable", { clear = true }),
      pattern = filetypes,
      callback = callback_func,
    })
  end,
}
