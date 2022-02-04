-- enable tabline
-- disable to use bufferline set bellow
vim.g["airline#extensions#tabline#enabled"] = 0

-- Always show tabs
vim.opt.showtabline = 2

-- We don't need to see things like -- INSERT -- anymore
vim.opt.showmode = false
vim.opt.laststatus = 2
vim.opt.showcmd = true

vim.g.airline_exclude_filetypes = { "NvimTree", "toggleterm" }
vim.g["airline#extensions#tabline#tab_nr_type"] = 1 -- tab number
vim.g["airline#extensions#tabline#show_tab_nr"] = 1
vim.g["airline#extensions#tabline#formatter"] = "default"
vim.g["airline#extensions#tabline#buffer_nr_show"] = 0
vim.g["airline#extensions#tabline#fnametruncate"] = 16
vim.g["airline#extensions#tabline#fnamecollapse"] = 2
vim.g["airline#extensions#tabline#switch_buffers_and_tabs"] = 1

vim.g["airline#extensions#tabline#buffer_idx_mode"] = 1

vim.cmd([[
" nmap <leader>1 <Plug>AirlineSelectTab1
" nmap <leader>2 <Plug>AirlineSelectTab2
" nmap <leader>3 <Plug>AirlineSelectTab3
" nmap <leader>4 <Plug>AirlineSelectTab4
" nmap <leader>5 <Plug>AirlineSelectTab5
" nmap <leader>6 <Plug>AirlineSelectTab6
" nmap <leader>7 <Plug>AirlineSelectTab7
" nmap <leader>8 <Plug>AirlineSelectTab8
" nmap <leader>9 <Plug>AirlineSelectTab9
nnoremap <silent><leader>1 <Cmd>BufferLineGoToBuffer 1<CR>
nnoremap <silent><leader>2 <Cmd>BufferLineGoToBuffer 2<CR>
nnoremap <silent><leader>3 <Cmd>BufferLineGoToBuffer 3<CR>
nnoremap <silent><leader>4 <Cmd>BufferLineGoToBuffer 4<CR>
nnoremap <silent><leader>5 <Cmd>BufferLineGoToBuffer 5<CR>
nnoremap <silent><leader>6 <Cmd>BufferLineGoToBuffer 6<CR>
nnoremap <silent><leader>7 <Cmd>BufferLineGoToBuffer 7<CR>
nnoremap <silent><leader>8 <Cmd>BufferLineGoToBuffer 8<CR>
nnoremap <silent><leader>9 <Cmd>BufferLineGoToBuffer 9<CR>

nnoremap <silent>L :BufferLineCycleNext<CR>
nnoremap <silent>H :BufferLineCyclePrev<CR>
]])

vim.g["airline_left_sep"] = ""
vim.g["airline_left_alt_sep"] = ""
vim.g["airline_right_sep"] = ""
vim.g["airline_right_alt_sep"] = ""
vim.g["airline_symbols.readonly"] = ""
vim.g["airline_symbols.crypt"] = "🔒"
vim.g["airline_symbols.linenr"] = "¶"
vim.g["airline_symbols.colnr"] = ""
vim.g["airline_symbols.maxlinenr"] = ""
-- vim.g["airline_symbols.maxlinenr"] = "☰"
vim.g["airline_symbols.branch"] = ""
vim.g["airline_symbols.paste"] = "ρ"
vim.g["airline_symbols.paste"] = "Þ"
vim.g["airline_symbols.paste"] = "∥"
vim.g["airline_symbols.spell"] = "Ꞩ"
vim.g["airline_symbols.notexists"] = "Ɇ"
vim.g["airline_symbols.whitespace"] = "Ξ"
vim.g["airline_symbols.dirty"] = "⚡"

local status_ok, bufferline = pcall(require, "bufferline")
if not status_ok then
  return
end

bufferline.setup({
  options = {
    -- | "ordinal" | "buffer_id" | "both" | f({ ordinal, id, lower, raise }): string,
    numbers = function(opts) -- opts
      return string.format("%s", opts.ordinal)
    end,
    close_command = "bd! %d",
    right_mouse_command = "bd! %d",
    left_mouse_command = "buffer %d",
    middle_mouse_command = nil,
    indicator_icon = "▎",
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
    diagnostics_indicator = function(count, level, _, _) -- count, level, diagnostics_dict, context
      local icon = level:match("error") and " " or " "
      return icon .. count
    end,
    show_buffer_icons = true,
    show_buffer_close_icons = true,
    show_close_icon = false,
    show_tab_indicators = false,
    persist_buffer_sort = true,
    separator_style = "thin",
    enforce_regular_tabs = false,
    always_show_bufferline = true,
    sort_by = function(a, b)
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
  highlights = {
    fill = {
      guifg = { attribute = "fg", highlight = "#ff0000" },
      guibg = { attribute = "bg", highlight = "TabLine" },
    },
    background = {
      guifg = { attribute = "fg", highlight = "TabLine" },
      guibg = { attribute = "bg", highlight = "TabLine" },
    },
    buffer_selected = {
      guifg = { attribute = "fg", highlight = "#ff0000" },
      guibg = { attribute = "bg", highlight = "#0000ff" },
      gui = "none",
    },
    buffer_visible = {
      guifg = { attribute = "fg", highlight = "TabLine" },
      guibg = { attribute = "bg", highlight = "TabLine" },
    },

    close_button = {
      guifg = { attribute = "fg", highlight = "TabLine" },
      guibg = { attribute = "bg", highlight = "TabLine" },
    },
    close_button_visible = {
      guifg = { attribute = "fg", highlight = "TabLine" },
      guibg = { attribute = "bg", highlight = "TabLine" },
    },
    close_button_selected = {
      guifg = { attribute = "fg", highlight = "TabLineSel" },
      guibg = { attribute = "bg", highlight = "TabLineSel" },
    },

    tab_selected = {
      guifg = { attribute = "fg", highlight = "Normal" },
      guibg = { attribute = "bg", highlight = "Normal" },
    },
    tab = {
      guifg = { attribute = "fg", highlight = "TabLine" },
      guibg = { attribute = "bg", highlight = "TabLine" },
    },
    tab_close = {
      guifg = { attribute = "fg", highlight = "TabLineSel" },
      guibg = { attribute = "bg", highlight = "Normal" },
    },

    duplicate_selected = {
      guifg = { attribute = "fg", highlight = "TabLineSel" },
      guibg = { attribute = "bg", highlight = "TabLineSel" },
      gui = "italic",
    },
    duplicate_visible = {
      guifg = { attribute = "fg", highlight = "TabLine" },
      guibg = { attribute = "bg", highlight = "TabLine" },
      gui = "italic",
    },
    duplicate = {
      guifg = { attribute = "fg", highlight = "TabLine" },
      guibg = { attribute = "bg", highlight = "TabLine" },
      gui = "italic",
    },

    modified = {
      guifg = { attribute = "fg", highlight = "TabLine" },
      guibg = { attribute = "bg", highlight = "TabLine" },
    },
    modified_selected = {
      guifg = { attribute = "fg", highlight = "Normal" },
      guibg = { attribute = "bg", highlight = "Normal" },
    },
    modified_visible = {
      guifg = { attribute = "fg", highlight = "TabLine" },
      guibg = { attribute = "bg", highlight = "TabLine" },
    },

    separator = {
      guifg = { attribute = "bg", highlight = "TabLine" },
      guibg = { attribute = "bg", highlight = "TabLine" },
    },
    separator_selected = {
      guifg = { attribute = "bg", highlight = "Normal" },
      guibg = { attribute = "bg", highlight = "Normal" },
    },
    separator_visible = {
      guifg = { attribute = "bg", highlight = "TabLine" },
      guibg = { attribute = "bg", highlight = "TabLine" },
    },
    indicator_selected = {
      guifg = { attribute = "fg", highlight = "LspDiagnosticsDefaultHint" },
      guibg = { attribute = "bg", highlight = "Normal" },
    },
  },
})
