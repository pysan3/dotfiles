---@param callback fun(menu: dropbar_menu_t): nil
local function menu_cb(callback)
  local menu = require("dropbar.api").get_current_dropbar_menu()
  if not menu then
    return
  end
  return callback(menu)
end

---@param callback fun(menu: dropbar_menu_t): nil
local function menu_callback(callback)
  return function()
    return menu_cb(callback)
  end
end

---@param entry dropbar_menu_entry_t
---@param nth integer
---@param callback fun(component: dropbar_symbol_t): nil
local function nth_component_cb(entry, nth, callback)
  local component, range = entry:first_clickable(0)
  for _ = 1, nth do
    local last = range and range["end"] or 0
    component, range = entry:first_clickable(last + 1)
    if not component then
      return
    end
  end
  if component then
    return callback(component)
  end
end

---@param menu dropbar_menu_t
local function entry_at_row(menu)
  local cursor = vim.api.nvim_win_get_cursor(menu.win)
  return menu.entries[cursor[1]]
end

local function tab(menu)
  return nth_component_cb(entry_at_row(menu), 0, function(component)
    menu:click_on(component, nil, 1, "<CR>")
  end)
end

local function enter(menu)
  return nth_component_cb(entry_at_row(menu), 1, function(component)
    menu:click_on(component, nil, 1, "<CR>")
  end)
end

return {
  "Bekaboo/dropbar.nvim",
  cond = not vim.g.started_by_firenvim and not vim.g.personal_options.start_light_env,
  dependencies = {
    { "nvim-tree/nvim-web-devicons" },
  },
  event = "VeryLazy",
  keys = {
    {
      "<Leader>mp",
      function()
        require("dropbar.api").pick()
      end,
      desc = "Dropbar Pick",
    },
  },
  opts = {
    icons = {
      kinds = { symbols = vim.g.personal_options.lsp_icons },
      ui = { bar = { separator = "  " } },
    },
    bar = {
      padding = { left = 0, right = 0 },
      pick = { pivots = "asdfghjklqwertyuiop" },
    },
    menu = {
      entry = { padding = { left = 0, right = 0 } },
      keymaps = {
        ["<Tab>"] = menu_callback(tab),
        ["l"] = menu_callback(tab),
        ["q"] = menu_callback(enter),
        ["<Esc>"] = menu_callback(enter),
        ["<S-Tab>"] = "<C-w>c",
        ["<BS>"] = "<C-w>c",
        ["h"] = "<C-w>c",
      },
    },
  },
}
