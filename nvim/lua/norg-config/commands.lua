M = {}

M.subcmd_alias = function(_)
  vim.api.nvim_create_user_command("Metadata", "Neorg inject-metadata", { desc = "Neorg: alias to inject-metadata" })
  local days = { "Yesterday", "Today", "Tomorrow" }
  for _, cmd in ipairs(days) do
    vim.api.nvim_create_user_command(cmd, function()
      vim.cmd(([[
      Neorg journal %s
      Metadata
      ]]):format(cmd:lower()))
    end, { desc = "Neorg: open " .. cmd .. "'s journal", force = true })
  end
end

M.setup = function(opts)
  M.subcmd_alias(opts)
end

return M
