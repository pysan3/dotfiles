local function goto_headline(which)
  local ts_utils = require("nvim-treesitter.ts_utils")
  local tsparser = vim.treesitter.get_parser()
  local tstree = tsparser:parse()
  local root = tstree[1]:root()
  local cursor = vim.api.nvim_win_get_cursor(0)
  local cursor_range = { cursor[1] - 1, cursor[2] }
  -- Query all headings (from 1 to 6)
  local query = vim.treesitter.query.parse(
    "norg",
    [[
    (heading1) @h1
    (heading2) @h2
    (heading3) @h3
    (heading4) @h4
    (heading5) @h5
    (heading6) @h6
    ]]
  )
  local previous_headline = nil
  local next_headline = nil
  -- Find the previous and next heading from the captures
  for _, captures, metadata in query:iter_matches(root) do ---@diagnostic disable-line
    for _, node in pairs(captures) do
      local row = node:start()
      if row < cursor_range[1] then
        previous_headline = node
      elseif row > cursor_range[1] and next_headline == nil then
        next_headline = node
        break
      end
    end
  end
  if which == "previous" then
    ts_utils.goto_node(previous_headline)
  elseif which == "next" then
    ts_utils.goto_node(next_headline)
  end
end

return {
  hook = function(kb)
    local prefix = vim.g.personal_options.prefix
    local neorg_prefix = prefix.neorg
    kb.map("norg", "n", neorg_prefix .. "e", function()
      vim.cmd([[!norgc % gfm >/dev/null]])
    end, { desc = "Neorg: export to markdown and open file" })
    kb.map("norg", "n", neorg_prefix .. "E", function()
      vim.cmd([[!norgc % gfm >/dev/null]])
      vim.cmd.vsplit(vim.fn.expand("%:p:.:r") .. ".md")
      vim.cmd([[GithubPreviewStart]])
    end, { desc = "Neorg: export to markdown and open MarkdownPreview" })
    kb.map_event("norg", "n", neorg_prefix .. "c", "core.looking-glass.magnify-code-block")
    kb.map("norg", "n", neorg_prefix .. "q", "<Cmd>Neorg return<CR>")
    kb.map("norg", "n", "[h", function()
      goto_headline("previous")
    end, { desc = "Neorg: Go to previous headline" })
    kb.map("norg", "n", "]h", function()
      goto_headline("next")
    end, { desc = "Neorg: Go to next headline" })
    kb.remap_key("norg", "i", "<M-d>", "<C-b>")
    kb.map("norg", "n", prefix.iron .. "x", "<Cmd>Neorg exec cursor<CR>")
    kb.map("norg", "n", prefix.iron .. "X", "<Cmd>Neorg exec current-file<CR>")
    -- https://github.com/nvim-neorg/neorg-telescope
    kb.map_event("norg", "n", prefix.telescope .. "l", "core.integrations.telescope.find_linkable")
    kb.map_event("norg", "i", "<C-l>", "core.integrations.telescope.insert_link")
  end,
}
