return {
  "max397574/colortils.nvim",
  cmd = "Colortils",
  keys = {
    {
      "<Leader>Y",
      function()
        local suc, err = pcall(require("colortils").exec_command, { fargs = {} })
        if not suc then
          vim.print(err)
        end
      end,
      desc = "Colortils",
    },
  },
  opts = {},
}
