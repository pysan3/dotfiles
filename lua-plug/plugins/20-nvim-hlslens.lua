local function keys(key)
  key.noremap = true
  key.silent = true
  key.desc = key[2]
  return key
end

return {
  "kevinhwang91/nvim-hlslens",
  dependencies = {
    "haya14busa/vim-asterisk",
  },
  keys = {
    keys({ "n", [[<Cmd>execute("normal! " . v:count1 . "n")<CR><Cmd>lua require("hlslens").start()<CR>]] }),
    keys({ "N", [[<Cmd>execute("normal! " . v:count1 . "N")<CR><Cmd>lua require("hlslens").start()<CR>]] }),
    keys({ "*", [[<Plug>(asterisk-z*)<Cmd>lua require("hlslens").start()<CR>]], mode = { "n", "x" } }),
    keys({ "#", [[<Plug>(asterisk-z#)<Cmd>lua require("hlslens").start()<CR>]], mode = { "n", "x" } }),
    keys({ "g*", [[<Plug>(asterisk-g*)<Cmd>lua require("hlslens").start()<CR>]], mode = { "n", "x" } }),
    keys({ "g#", [[<Plug>(asterisk-g#)<Cmd>lua require("hlslens").start()<CR>]], mode = { "n", "x" } }),
  },
  config = {
    auto_enable = true,
    enable_incsearch = true,
    calm_down = true,
    virt_priority = 0,
  },
}
