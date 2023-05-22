return {
  "aaron-p1/virt-notes.nvim",
  keys = {
    { vim.g.personal_options.prefix.virt_notes },
  },
  opts = {
    notes_path = vim.fn.stdpath("data") .. "/virt_notes",
    mappings = {
      prefix = vim.g.personal_options.prefix.virt_notes,
    },
  },
}
