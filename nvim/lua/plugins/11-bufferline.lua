return {
  "akinsho/bufferline.nvim", -- bufferline
  event = "VeryLazy",
  enabled = not vim.g.started_by_firenvim,
  dependencies = { "kyazdani42/nvim-web-devicons" },
  cmd = { "BufferLineGoToBuffer", "BufferLineCycleNext", "BufferLineCyclePrev", "BufferLinePick" },
  keys = {
    { "L", "<Cmd>BufferLineCycleNext<CR>", silent = true, remap = false },
    { "H", "<Cmd>BufferLineCyclePrev<CR>", silent = true, remap = false },
    { "F", "<Cmd>BufferLinePick<CR>", silent = true, remap = false },
    { "<Leader>1", "<Cmd>BufferLineGoToBuffer 1<CR>", silent = true, remap = false },
    { "<Leader>2", "<Cmd>BufferLineGoToBuffer 2<CR>", silent = true, remap = false },
    { "<Leader>3", "<Cmd>BufferLineGoToBuffer 3<CR>", silent = true, remap = false },
    { "<Leader>4", "<Cmd>BufferLineGoToBuffer 4<CR>", silent = true, remap = false },
    { "<Leader>5", "<Cmd>BufferLineGoToBuffer 5<CR>", silent = true, remap = false },
    { "<Leader>6", "<Cmd>BufferLineGoToBuffer 6<CR>", silent = true, remap = false },
    { "<Leader>7", "<Cmd>BufferLineGoToBuffer 7<CR>", silent = true, remap = false },
    { "<Leader>8", "<Cmd>BufferLineGoToBuffer 8<CR>", silent = true, remap = false },
    { "<Leader>9", "<Cmd>BufferLineGoToBuffer 9<CR>", silent = true, remap = false },
  },
  config = {
    options = {
      close_command = "bd %d",
      right_mouse_command = "bd %d",
      left_mouse_command = "buffer %d",
      middle_mouse_command = nil,
      buffer_close_icon = "",
      modified_icon = "●",
      close_icon = "",
      left_trunc_marker = "",
      right_trunc_marker = "",
      max_name_length = 30,
      max_prefix_length = 30,
      tab_size = 12,
      diagnostics = "nvim_lsp", -- | "nvim_lsp" | "coc" | none,
      diagnostics_update_in_insert = false,
      diagnostics_indicator = function(_, _, diag, _)
        return (diag.error and " " .. diag.error .. " " or "")
            .. (diag.warning and " " .. diag.warning or "")
            .. (diag.info and "" .. diag.info or "")
            .. (diag.hint and "" .. diag.hint or "")
      end,
      show_buffer_icons = true,
      show_buffer_close_icons = true,
      show_close_icon = false,
      show_tab_indicators = true,
      persist_buffer_sort = true,
      separator_style = "slant",
      enforce_regular_tabs = false,
      always_show_bufferline = true,
      custom_filter = function(buf, _)
        return string.len(vim.fn.bufname(buf) or "") ~= 0
      end,
      sort_by = function(a, b) ---@diagnostic disable-line
        -- sort by modified time (newer to left)
        local mod_a = vim.loop.fs_stat(a.path)
        local mod_b = vim.loop.fs_stat(b.path)
        if mod_a == nil and mod_b == nil then
          return a.filename > b.filename
        elseif mod_a == nil then
          return true
        elseif mod_b == nil then
          return false
        end
        return mod_a.mtime.sec > mod_b.mtime.sec
      end,
    },
  }
}