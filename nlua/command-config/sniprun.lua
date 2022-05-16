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
vmap r <Plug>SnipRun
]])
