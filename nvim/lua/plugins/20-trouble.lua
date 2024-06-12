-- better diagnostics list and others
return {
  "folke/trouble.nvim",
  cmd = { "TroubleToggle", "Trouble" },
  keys = {
    { "<Leader>xx", "<Cmd>Trouble document_diagnostics toggle<CR>", desc = "Trouble: Document Diagnostics" },
    { "<Leader>xX", "<Cmd>Trouble workspace_diagnostics toggle<CR>", desc = "Trouble: Workspace Diagnostics" },
    { "<Leader>xL", "<Cmd>Trouble loclist toggle<CR>", desc = "Trouble: Location List" },
    { "<Leader>xQ", "<Cmd>Trouble quickfix toggle<CR>", desc = "Trouble: Quickfix List" },
    { "<Leader>X", "<Cmd>Trouble toggle<CR>", desc = "Trouble: toggle" },
    {
      "<C-p>",
      function()
        if require("trouble").is_open() then
          require("trouble").prev({ skip_groups = true, jump = true }) ---@diagnostic disable-line
        else
          vim.cmd.cprev()
        end
      end,
      desc = "Trouble: Previous trouble/quickfix item",
    },
    {
      "<C-n>",
      function()
        if require("trouble").is_open() then
          require("trouble").next({ skip_groups = true, jump = true }) ---@diagnostic disable-line
        else
          vim.cmd.cnext()
        end
      end,
      desc = "Trouble: Next trouble/quickfix item",
    },
  },
  opts = {
    use_diagnostic_signs = true,
  },
}
