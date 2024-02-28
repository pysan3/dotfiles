local function plugin(repo, name, maps, setup)
  local m = {
    repo,
    dependencies = {
      "telescope.nvim",
    },
    keys = {},
  }
  for _, map in ipairs(maps) do
    m.keys[#m.keys + 1] = {
      vim.g.personal_options.prefix.telescope .. map.key,
      function()
        local telescope = require("telescope")
        local t_ext = require("telescope._extensions")
        t_ext._config[name] = setup
        telescope.load_extension(name)
        if map.func then
          map.func(map.opts)
        else
          telescope.extensions[name][map.picker or name](map.opts)
        end
      end,
      desc = string.format([[Telescope.%s: %s]], name, map.picker or name),
    }
  end
  return m
end

return {
  plugin("nvim-telescope/telescope-media-files.nvim", "media_files", {
    { key = "i", picker = "media_files" },
  }, {
    filetypes = { "png", "webp", "jpg", "jpeg", "mp4", "pdf" },
    find_cmd = "rg",
  }),
  plugin("crispgm/telescope-heading.nvim", "heading", {
    { key = "a", picker = "heading" },
  }, {
    picker_opts = {
      layout_config = { width = 0.8, preview_width = 0.5 },
      layout_strategy = "horizontal",
    },
  }),
}
