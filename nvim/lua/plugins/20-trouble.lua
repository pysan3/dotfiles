-- better diagnostics list and others
return {
  "folke/trouble.nvim",
  cmd = { "TroubleToggle", "Trouble" },
  keys = {
    { "<Leader>xx", "<Cmd>TroubleToggle document_diagnostics<CR>", desc = "Trouble: Document Diagnostics" },
    { "<Leader>xX", "<Cmd>TroubleToggle workspace_diagnostics<CR>", desc = "Trouble: Workspace Diagnostics" },
    { "<Leader>xL", "<Cmd>TroubleToggle loclist<CR>", desc = "Trouble: Location List" },
    { "<Leader>xQ", "<Cmd>TroubleToggle quickfix<CR>", desc = "Trouble: Quickfix List" },
    { "<Leader>xc", "<Cmd>TroubleToggle<CR>", desc = "Trouble: toggle" },
    {
      "<C-p>",
      function()
        if require("trouble").is_open() then
          require("trouble").previous({ skip_groups = true, jump = true })
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
          require("trouble").next({ skip_groups = true, jump = true })
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
