return {
  setup = {
    "terryma/vim-expand-region", -- + to expand, _ to shrink
    "unblevable/quick-scope", -- highlights f, t, F, T
    "justinmk/vim-sneak", -- s, S to jump anywhere
  },
  install = {
    "vim-scripts/ReplaceWithRegister", -- {Visual}["x]gr - replace {Visual} with register x
    "tpope/vim-repeat", -- better repetition
    "christoomey/vim-titlecase", -- gzz
    "christoomey/vim-sort-motion", -- gs<motion> eg. gs2j => sort 3 lines
    "tpope/vim-surround", -- s is motion, ys to add
    -- "michaeljsmith/vim-indent-object", -- ai, ii, aI, iI: object of same indent (i; above, a; above and below)
    -- "PeterRincker/vim-argumentative",
    "wellle/targets.vim", -- 2i, 2a for more inner and outer selection
  },
}
