return {
  "nvim-lualine/lualine.nvim", -- lualine
  event = "VeryLazy",
  dependencies = { "kyazdani42/nvim-web-devicons" },
  config = function()
    if vim.g.started_by_firenvim then
      return
    end
    local function show_macro_recording()
      local reg = vim.fn.reg_recording()
      return reg == "" and "" or "Recording @" .. reg
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
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff", "diagnostics" },
        lualine_c = {
          { "hostname", icon = "@", color = { fg = "#16c60c" } },
          { "filename", path = 3 },
          { "maximized-status", fmt = maximize_status, color = "WarningMsg" },
        },
        lualine_x = {
          { "macro-recording", fmt = show_macro_recording },
          "encoding",
          "fileformat",
          "filetype",
        },
        lualine_y = { "progress" },
        lualine_z = { "location" },
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
