require("bufferline").setup({
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
})
