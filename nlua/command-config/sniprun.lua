require("sniprun").setup({
  display = {
    "VirtualTextOk",
    "TerminalWithCode",
    "NvimNotify",
  },
})

vim.cmd([[
nmap <leader>rf <Plug>SnipRun
nmap <leader>r <Plug>SnipRunOperator
xmap r <Plug>SnipRun
]])
