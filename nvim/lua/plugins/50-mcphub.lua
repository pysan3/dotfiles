return {
  "ravitemer/mcphub.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  build = "bundled_build.lua", -- Bundles `mcp-hub` binary along with the neovim plugin
  version = false,
  opts = {
    use_bundled_binary = true, -- Use local `mcp-hub` binary
    ---Chat-plugin related options-----------------
    auto_approve = true, -- Auto approve mcp tool calls
    auto_toggle_mcp_servers = true, -- Let LLMs start and stop MCP servers automatically
    log = {
      level = vim.g.personal_options.debug.avante and vim.log.levels.DEBUG or vim.log.levels.WARN,
      to_file = false,
      file_path = nil,
      prefix = "MCPHub",
    },
    extensions = {
      avante = {
        make_slash_commands = true, -- make /slash commands from MCP server prompts
      },
      copilotchat = {
        enabled = true,
        convert_tools_to_functions = true, -- Convert MCP tools to CopilotChat functions
        convert_resources_to_functions = true, -- Convert MCP resources to CopilotChat functions
        add_mcp_prefix = false, -- Add "mcp_" prefix to function names
      },
    },
  },
}
