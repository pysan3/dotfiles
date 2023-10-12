local function fugitive_map(key, method, no_fugitive)
  return {
    vim.g.personal_options.prefix.neogit .. key,
    string.format([[<Cmd>%s%s<CR>]], no_fugitive and "" or "G ", method),
    desc = "Fugitive: " .. method,
  }
end

return {
  "tpope/vim-fugitive",
  cmd = { "G", "GBranches", "Gdiff" },
  cond = vim.g.personal_options.use_git_plugins,
  keys = {
    fugitive_map("S", ""),
    fugitive_map("j", "diffget //2", true),
    fugitive_map("k", "diffget //3", true),
  },
  init = function()
    vim.env.FZF_DEFAULT_OPTS = "--reverse"
  end,
}
