return {
  "nvim-lualine/lualine.nvim", -- lualine
  event = "VeryLazy",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
    "meuter/lualine-so-fancy.nvim",
  },
  config = function()
    if vim.g.started_by_firenvim then
      return
    end
    local function maximize_status()
      return vim.t["maximized"] and " " or ""
    end

    require("lualine").setup({
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
          { "maximized-status", fmt = maximize_status, color = "WarningMsg" },
        },
        lualine_x = {
          { "fancy_macro" },
          { "fancy_diagnostics" },
          { "fancy_searchcount" },
        },
        lualine_y = {
          { "encoding" },
          { "fileformat" },
          { "fancy_filetype", ts_icon = "" },
          { "fancy_lsp_servers" },
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
    })

    local aug = vim.api.nvim_create_augroup("StatusLineWatchRecording", { clear = true })
    local function refresh_lualine_callback()
      require("lualine").refresh({ place = { "statusline" } })
    end
    vim.api.nvim_create_autocmd("RecordingEnter", {
      group = aug,
      callback = refresh_lualine_callback,
    })
    vim.api.nvim_create_autocmd("RecordingLeave", {
      group = aug,
      callback = function()
        local timer = vim.loop.new_timer()
        if timer ~= nil then
          timer:start(50, 0, vim.schedule_wrap(refresh_lualine_callback))
        end
      end,
    })
  end,
}
