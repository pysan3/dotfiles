local function image_ft_options(ft)
  return {
    enabled = true,
    clear_in_insert_mode = false,
    download_remote_images = false,
    only_render_image_at_cursor = true,
    filetypes = ft,
  }
end

return {
  "3rd/image.nvim",
  ft = vim.g.personal_module.md({ "norg" }),
  lazy = false,
  version = false,
  init = function()
    vim.g.personal_module.load_luarocks()
  end,
  opts = {
    backend = "kitty",
    integrations = {
      markdown = image_ft_options({ "markdown", "vimwiki" }),
      neorg = image_ft_options({ "norg" }),
    },
    tmux_show_only_in_active_window = true,
  },
}
