return {
  hook = function(kb)
    local norg_utils = require("norg-config.utils")
    kb.map("norg", "n", vim.g.personal_options.prefix.neorg .. "e", function()
      norg_utils.export_file(".md", { open_file = true, open_markdown_preview = false })
    end, { desc = "Neorg: export to markdown and open file" })
    kb.map("norg", "n", vim.g.personal_options.prefix.neorg .. "E", function()
      norg_utils.export_file(".md", { open_file = true, open_markdown_preview = true })
    end, { desc = "Neorg: export to markdown and open MarkdownPreview" })
    kb.map_event("norg", "n", vim.g.personal_options.prefix.neorg .. "c", "core.looking-glass.magnify-code-block")
    kb.map("norg", "n", vim.g.personal_options.prefix.neorg .. "q", "<Cmd>Neorg return<CR>")
  end,
}
