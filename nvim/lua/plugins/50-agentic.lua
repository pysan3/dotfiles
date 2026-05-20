return {
  "carlos-algms/agentic.nvim",
  event = "VeryLazy",
  keys = {
    {
      "<Leader>at",
      function()
        require("agentic").toggle()
      end,
      mode = { "n", "v" },
      desc = "Toggle Agentic Chat",
    },
    {
      "<Leader>af",
      function()
        require("agentic").add_selection_or_file_to_context()
      end,
      mode = { "n", "v" },
      desc = "Add file or selection to Agentic to Context",
    },
    {
      "<Leader>an",
      function()
        require("agentic").new_session()
      end,
      mode = { "n", "v" },
      desc = "New Agentic Session",
    },
    {
      "<Leader>ap",
      function()
        require("agentic").switch_provider()
      end,
      mode = { "n" },
      desc = "Agentic Switch Provider",
    },
    {
      "<Leader>aP",
      function()
        require("agentic").new_session_with_provider()
      end,
      mode = { "n" },
      desc = "New Agentic Session with Provider",
    },
    {
      "<Leader>as",
      function()
        require("agentic").stop_generation()
      end,
      mode = { "n" },
      desc = "Agentic Stop Generation",
    },
    {
      "<Leader>ar",
      function()
        require("agentic").restore_session()
      end,
      desc = "Agentic Restore session",
      silent = true,
      mode = { "n", "v" },
    },
    {
      "<Leader>al",
      function()
        require("agentic").rotate_layout()
      end,
      desc = "Agentic Rotate Layout",
      mode = { "n" },
    },
    {
      "<leader>ad", -- ai Diagnostics
      function()
        require("agentic").add_current_line_diagnostics()
      end,
      desc = "Add current line diagnostic to Agentic",
      mode = { "n" },
    },
    {
      "<leader>aD", -- ai all Diagnostics
      function()
        require("agentic").add_buffer_diagnostics()
      end,
      desc = "Add all buffer diagnostics to Agentic",
      mode = { "n" },
    },
  },
  opts = {
    -- Set Claude Code as your default preferred backend
    provider = "claude-agent-acp",
    -- Agentic automatically registers standard ACP defaults.
    -- If you ever need to manually pass specific args or environments
    -- to an ACP provider, you can override them here:
    acp_providers = {
      ["claude-agent-acp"] = {
        -- Built-in defaults handle this, but you can explicitly tune it if needed
        env = {
          NODE_NO_WARNINGS = "1",
        },
      },
      ["copilot-acp"] = {
        -- Ready out-of-the-box as your alternative provider
      },
    },
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim", -- Required for fuzzy finding workspace files with @
    { "hakonharnes/img-clip.nvim", opts = {} },
    {
      "MeanderingProgrammer/render-markdown.nvim",
      opts = {
        -- Update the file types to target agentic's internal buffer names
        file_types = {
          "markdown",
          "AgenticChat",
          "AgenticInput",
          "AgenticCode",
          "AgenticFiles",
        },
      },
      ft = { "markdown", "AgenticChat", "AgenticInput" },
    },
  },
}
