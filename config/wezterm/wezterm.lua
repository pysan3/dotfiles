local wezterm = require("wezterm")
local act = wezterm.action

-- COLORS
local colorschemes = {
  "PaperColorDark (Gogh)",
  -- "Japanesque",
  -- "Jellybeans",
}

local keys = {
  -- Full Screen
  { key = "Enter", mods = "ALT", action = act.ToggleFullScreen },
  { key = "F11", mods = "NONE", action = act.ToggleFullScreen },

  -- Modify font size
  { key = "+", mods = "CTRL", action = act.IncreaseFontSize },
  { key = "+", mods = "SHIFT|CTRL", action = act.IncreaseFontSize },
  { key = "-", mods = "CTRL", action = act.DecreaseFontSize },
  { key = "-", mods = "SHIFT|CTRL", action = act.DecreaseFontSize },
  { key = "=", mods = "CTRL", action = act.IncreaseFontSize },
  { key = "=", mods = "SHIFT|CTRL", action = act.IncreaseFontSize },

  -- Clipboard
  { key = "c", mods = "SHIFT|CTRL", action = act.CopyTo("Clipboard") },
  { key = "v", mods = "SHIFT|CTRL", action = act.PasteFrom("Clipboard") },
  { key = "phys:Space", mods = "SHIFT|CTRL", action = act.QuickSelect },

  -- Tabs
  { key = "T", mods = "SHIFT|CTRL", action = act.SpawnTab("CurrentPaneDomain") },
  { key = "W", mods = "SHIFT|CTRL", action = act.CloseCurrentTab({ confirm = true }) },
  { key = "Tab", mods = "CTRL", action = act.ActivateTabRelative(1) },
  { key = "Tab", mods = "SHIFT|CTRL", action = act.ActivateTabRelative(-1) },
  { key = "1", mods = "ALT|CTRL", action = act.ActivateTab(0) },
  { key = "2", mods = "ALT|CTRL", action = act.ActivateTab(1) },
  { key = "3", mods = "ALT|CTRL", action = act.ActivateTab(2) },
  { key = "4", mods = "ALT|CTRL", action = act.ActivateTab(3) },
  { key = "5", mods = "ALT|CTRL", action = act.ActivateTab(4) },
  { key = "6", mods = "ALT|CTRL", action = act.ActivateTab(5) },
  { key = "7", mods = "ALT|CTRL", action = act.ActivateTab(6) },
  { key = "8", mods = "ALT|CTRL", action = act.ActivateTab(7) },
  { key = "9", mods = "ALT|CTRL", action = act.ActivateTab(8) },
  { key = "0", mods = "ALT|CTRL", action = act.ActivateTab(-1) },

  -- Full Screen
  { key = "Enter", mods = "ALT", action = act.ToggleFullScreen },
  { key = "F11", mods = "NONE", action = act.ToggleFullScreen },

  -- Debug and Configuration
  { key = "L", mods = "SHIFT|CTRL", action = act.ShowDebugOverlay },
  { key = "R", mods = "SHIFT|CTRL", action = act.ReloadConfiguration },

  -- open url
  {
    key = "o",
    mods = "SHIFT|CTRL",
    action = wezterm.action.QuickSelectArgs({
      label = "Open URL",
      patterns = { -- NOTE: rust regex
        [[h?t?t?p?s?:?/?/?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9]{1,6}\b[-a-zA-Z0-9@:%_\+.~#?&/=]*]],
        [[h?t?t?p?:?/?/?localhost:?[0-9]*]],
      },
      action = wezterm.action_callback(function(window, pane)
        local url = window:get_selection_text_for_pane(pane)
        wezterm.log_info("opening: " .. url)
        wezterm.open_with(url)
      end),
    }),
  },
}

return {
  -- Fonts
  font = wezterm.font("PlemolJP Console NF"),
  font_size = 12,
  -- Settings
  scrollback_lines = 10000,
  enable_tab_bar = false,
  cursor_blink_rate = 0, -- stop cursor blinking
  window_padding = { left = 0, right = 0, top = 0, bottom = 0 },
  use_ime = true,
  adjust_window_size_when_changing_font_size = true,
  allow_square_glyphs_to_overflow_width = "WhenFollowedBySpace",
  check_for_updates = false,
  keys = keys,
  disable_default_key_bindings = true,
  color_scheme = colorschemes[1],
  colors = { -- overwrite colorscheme with jellybeans-nvim cursor colors
    cursor_bg = "#b0d0f0",
    cursor_fg = "#151515",
    cursor_border = "#b0d0f0",
  },
}
