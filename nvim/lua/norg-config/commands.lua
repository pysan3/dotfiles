M = {}

local function subcmd_alias(_)
  vim.api.nvim_create_user_command(
    "Metadata",
    "Neorg inject-metadata",
    { desc = "Neorg: alias to inject-metadata", bar = true }
  )
  local days = { "Yesterday", "Today", "Tomorrow" }
  for _, cmd in ipairs(days) do
    vim.api.nvim_create_user_command(cmd, function()
      pcall(vim.cmd, [[Neorg journal ]] .. cmd:lower()) ---@diagnostic disable-line
      vim.schedule(function()
        vim.cmd([[Metadata | w]])
        vim.cmd([[normal ]h]h]]) -- move down to {** Daily Review}
      end)
    end, { desc = "Neorg: open " .. cmd .. "'s journal", force = true })
  end
end

M.setup = function(opts)
  subcmd_alias(opts)
end

return M
