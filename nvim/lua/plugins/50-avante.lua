return {
  "yetone/avante.nvim",
  build = function()
    -- conditionally use the correct build system for the current OS
    if vim.fn.has("win32") == 1 then
      return "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false"
    else
      return "make"
    end
  end,
  event = "VeryLazy",
  version = false, -- Never set this value to "*"! Never!
  dir = "~/Git/avante.nvim/",
  opts = {
    debug = vim.g.personal_options.debug.avante or false,
    provider = vim.env.NVIM_AVANTE_PROVIDER or "copilot",
    auto_suggestions_provider = nil,
    behaviour = {
      allow_access_to_git_ignored_files = true,
    },
    providers = {
      copilot = {
        model = "claude-sonnet-4",
      },
    },
    acp_providers = {
      ["gemini-cli"] = {
        command = "gemini",
        args = { "--experimental-acp" },
        env = {
          NODE_NO_WARNINGS = "1",
        },
      },
    },
    disabled_tools = {
      "bash",
      "create_dir",
      "create_file",
      "create",
      "delete_dir",
      "delete_file",
      "edit_file",
      "insert",
      "list_files", -- Built-in file operations
      "read_file",
      "rename_dir",
      "rename_file",
      "replace_in_file",
      "search_files",
      "str_replace",
      "undo_edit",
      "view",
      "write_to_file",
    },
    system_prompt = function()
      local hub = require("mcphub").get_hub_instance()
      if hub then
        vim.print(hub:get_active_servers_prompt())
      end
      return hub and hub:get_active_servers_prompt() or ""
    end,
    custom_tools = function()
      return {
        require("mcphub.extensions.avante").mcp_tool(),
      }
    end,
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    --- The below dependencies are optional,
    "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
    "hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
    "folke/snacks.nvim", -- for input provider snacks
    "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
    "zbirenbaum/copilot.lua", -- for providers='copilot'
    "mcphub.nvim",
    {
      -- support for image pasting
      "HakonHarnes/img-clip.nvim",
      event = "VeryLazy",
      opts = {
        default = {
          embed_image_as_base64 = false,
          prompt_for_file_name = false,
          drag_and_drop = {
            insert_mode = true,
          },
          use_absolute_path = true,
        },
      },
    },
    {
      -- Make sure to set this up properly if you have lazy=true
      "MeanderingProgrammer/render-markdown.nvim",
      opts = {
        file_types = { "markdown", "Avante" },
      },
      ft = { "markdown", "Avante" },
    },
  },
}
