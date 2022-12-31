local function fugitive_map(key, method, no_fugitive)
  return {
    vim.g.personal_options.prefix.fugitive .. key,
    string.format([[<Cmd>%s%s<CR>]], no_fugitive and "" or "G ", method),
    desc = "Fugitive: " .. method,
  }
end

return {
  "tpope/vim-fugitive",
  cmd = { "G", "GBranches", "Gdiff" },
  keys = {
    fugitive_map("s", ""),
    fugitive_map("a", "add ."),
    fugitive_map("t", "GBranches", true),
    fugitive_map("p", "push --quiet"),
    fugitive_map("l", "pull --quiet"),
    fugitive_map("b", "blame"),
    fugitive_map("d", "Gdiff", true),
    fugitive_map("m", "merge"),
    fugitive_map("d", "diffget //2", true),
    fugitive_map("k", "diffget //3", true),
  },
  init = function()
    vim.env.FZF_DEFAULT_OPTS = "--reverse"
  end,
}
