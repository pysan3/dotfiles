return {
  "klen/nvim-config-local", -- load local config
  "mhinz/vim-startify", -- startify
  {
    "pysan3/autosession.nvim", -- restore previous session
    -- "~/Git/autosession.nvim",
    requires = { "mhinz/vim-startify" },
  },
  { "mbbill/undotree", event = { "CursorHold", "FocusLost", "InsertEnter" } }, -- undo tree
  { "ziontee113/color-picker.nvim", cmd = { "PickColor" }, module = { "color-picker" } },
  { "windwp/nvim-spectre", module = { "spectre" }, wants = { "plenary.nvim" } }, -- better search and replace plugin
  { "numToStr/Navigator.nvim", module = { "Navigator" } },
  { "rcarriga/nvim-notify", module = { "notify" } }, -- notifications
  {
    "folke/noice.nvim",
    event = { "BufRead", "BufNewFile", "InsertEnter", "CmdlineEnter" },
    requires = { "MunifTanjim/nui.nvim", "rcarriga/nvim-notify" },
    wants = { "nui.nvim", "nvim-notify", "nvim-treesitter" },
    module = { "noice" },
    setup = function()
      -- HACK: avoid to set duplicatedly (ex. after PackerCompile)
      if not _G.__vim_notify_overwritten then
        vim.notify = function(...) ---@diagnostic disable-line
          local args = { ... }
          require("notify")
          require("noice")
          vim.schedule(function()
            vim.notify(unpack(args))
          end)
        end
        _G.__vim_notify_overwritten = true
      end
    end,
  },
  {
    "inkarkat/vim-SearchHighlighting",
    requires = { "inkarkat/vim-ingo-library" },
    wants = { "vim-ingo-library" },
    event = { "ModeChanged" },
  }, -- search word under corsor
}
