return {
  "mrcjkb/rustaceanvim",
  lazy = false,
  config = function()
    ---@type rustaceanvim.Opts
    vim.g.rustaceanvim = {
      server = {
        on_attach = function(client, bufnr)
          require("lsp-config.base").on_attach(client, bufnr)
        end,
      },
    }
  end,
}
