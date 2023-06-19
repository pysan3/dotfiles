return {
  {
    "zirrostig/vim-schlepp", -- dragvisuals
    init = function()
      vim.g["Schlepp#allowSquishingLines"] = 1
      vim.g["Schlepp#allowSquishingBlock"] = 1
      vim.g["Schlepp#trimWS"] = 0
    end,
    keys = {
      { "<up>", "<Plug>SchleppUp", remap = true, mode = "x", desc = "<Plug>SchleppUp" },
      { "<down>", "<Plug>SchleppDown", remap = true, mode = "x", desc = "<Plug>SchleppDown" },
      { "<left>", "<Plug>SchleppLeft", remap = true, mode = "x", desc = "<Plug>SchleppLeft" },
      { "<right>", "<Plug>SchleppRight", remap = true, mode = "x", desc = "<Plug>SchleppRight" },
      { "D", "<Plug>SchleppDup", remap = true, mode = "x", desc = "<Plug>SchleppDup" },
      { "Dk", "<Plug>SchleppDupUp", remap = true, mode = "x", desc = "<Plug>SchleppDupUp" },
      { "Dj", "<Plug>SchleppDupDown", remap = true, mode = "x", desc = "<Plug>SchleppDupDown" },
      { "Dh", "<Plug>SchleppDupLeft", remap = true, mode = "x", desc = "<Plug>SchleppDupLeft" },
      { "Dl", "<Plug>SchleppDupRight", remap = true, mode = "x", desc = "<Plug>SchleppDupRight" },
    },
  },
  {
    "nixon/vim-vmath",
    keys = {
      { "++", "vip++", remap = true, desc = "Vim-vmath: inner paragraph VMATH_YankAndAnalyse" },
      {
        "++",
        function()
          vim.api.nvim_call_function("VMATH_YankAndAnalyse", {})
        end,
        mode = "x",
        expr = true,
        desc = "Vim-vmath: VMATH_YankAndAnalyse",
      },
    },
  },
  {
    "folke/zen-mode.nvim", -- zenmode
    cmd = "ZenMode",
    opts = {},
  },
  {
    --  ╭──────────────────────────────────────────────────────────╮
    --  │                  aligns: `l`, `c`, `r`                   │
    --  ╰──────────────────────────────────────────────────────────╯
    --  ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
    --  ┃ :CB <box-align> <text-align> box <line-type>             ┃
    --  ┃ :CB <line-align> <line-type>                             ┃
    --  ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
    "LudoPinelli/comment-box.nvim",
    event = "VeryLazy",
  },
}
