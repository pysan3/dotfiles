return {
  "iamcco/markdown-preview.nvim",
  cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
  ft = { "markdown" },
  build = "pnpm install",
  init = function()
    vim.g.mkdp_filetypes = { "markdown" }
  end,
}
