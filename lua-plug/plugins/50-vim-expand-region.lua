return {
  "terryma/vim-expand-region",
  keys = {
    { "v", "<Plug>(expand_region_expand)", mode = "x", remap = true, desc = "<Plug>(expand_region_expand)" },
    { "<C-v>", "<Plug>(expand_region_shrink)", mode = "x", remap = true, desc = "<Plug>(expand_region_shrink)" },
  },
}
