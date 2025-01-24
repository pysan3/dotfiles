return {
  "chrisgrieser/nvim-various-textobjs",
  event = "BufReadPre",
  opts = {
    keymaps = {
      useDefaults = true,
      disabledDefaults = { "gc", "n", "L" },
    },
  },
}

--- keybinds: https://github.com/chrisgrieser/nvim-various-textobjs#list-of-text-objects
