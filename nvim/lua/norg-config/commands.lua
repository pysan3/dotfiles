M = {}

M.subcmd_alias = function(_)
  vim.api.nvim_create_user_command("Metadata", "Neorg inject-metadata", { desc = "Neorg: alias to inject-metadata" })
  vim.api.nvim_create_user_command("Today", function()
    vim.cmd([[
    Neorg journal today
    Metadata
    ]])
  end, { desc = "Neorg: open today's journal", force = true })
end

M.setup = function(opts)
  M.subcmd_alias(opts)
end

return M
