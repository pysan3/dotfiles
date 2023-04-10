local function maximize_status()
  return vim.t["maximized"] and " " or ""
end

return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  enabled = vim.g.started_by_firenvim,
  dependencies = {
    "nvim-tree/nvim-web-devicons",
    "meuter/lualine-so-fancy.nvim",
  },
  init = function()
    local lualine_aug = vim.api.nvim_create_augroup("StatusLineWatchRecording", { clear = true })
    local function refresh_lualine_callback()
      require("lualine").refresh({ place = { "statusline" } })
    end
    vim.api.nvim_create_autocmd("RecordingEnter", {
      group = lualine_aug,
      callback = refresh_lualine_callback,
    })
    vim.api.nvim_create_autocmd("RecordingLeave", {
      group = lualine_aug,
      callback = function()
        local timer = vim.loop.new_timer()
        if timer ~= nil then
          timer:start(50, 0, vim.schedule_wrap(refresh_lualine_callback))
        end
      end,
    })
  end,
  opts = {
    options = {
      icons_enabled = true,
      theme = "auto",
      component_separators = { left = "", right = "" },
      section_separators = { left = "", right = "" },
      disabled_filetypes = { "toggleterm" },
      always_divide_middle = false,
    },
    sections = {
      lualine_a = {
        { "mode" },
      },
      lualine_b = {
        { "branch" },
        { "fancy_diff" },
        { "fancy_diagnostics" },
      },
      lualine_c = {
        { "hostname", icon = "@", color = { fg = "#16c60c" } },
        { "fancy_cwd", substitute_home = true },
        { "filename", path = 1 },
        {
          "maximized-status",
          fmt = maximize_status,
          color = { fg = vim.g.personal_options.hlargs_lookup[vim.g.personal_options.colorscheme] },
        },
      },
      lualine_x = {
        { "fancy_macro" },
        { "fancy_diagnostics" },
        { "fancy_searchcount", icon = { "", color = { fg = "#fcba03" } } },
      },
      lualine_y = {
        { "encoding" },
        { "fileformat" },
        { "fancy_filetype", ts_icon = "" },
        { "fancy_lsp_servers", icon = { "", color = { fg = "#ffff00" } } },
      },
      lualine_z = {
        { "location" },
      },
    },
    inactive_sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = {},
      lualine_x = { "location" },
      lualine_y = {},
      lualine_z = {},
    },
    tabline = {},
    extensions = {},
  },
}
