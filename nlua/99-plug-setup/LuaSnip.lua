-- Command to edit snippets of the current file
local snippet_file_infos = {
  snipmate = {
    prefix = vim.fn.stdpath("config") .. "/snippets",
    ext = "snippets",
  },
  lua = {
    prefix = vim.fn.stdpath("config") .. "/lua/snippets",
    ext = "lua",
  },
}
local function edit_snippet_files(sniptype, ft)
  local file_found = nil
  require("luasnip.loaders").edit_snippet_files({
    format = function(file, source_name)
      if source_name ~= sniptype or string.find(file, "site") then
        return nil
      end
      file_found = file
      return file_found
    end,
  })
  if file_found == nil then
    file_found = snippet_file_infos[sniptype].prefix .. "/" .. ft .. "." .. snippet_file_infos[sniptype].ext
    vim.notify("Create new snippet file for " .. ft .. " at " .. file_found)
    vim.cmd("edit " .. file_found)
  end
  return file_found
end

vim.api.nvim_create_user_command("LsEditSnip", function()
  edit_snippet_files("snipmate", vim.bo.filetype)
end, {})
vim.api.nvim_create_user_command("LsEditLua", function()
  edit_snippet_files("lua", vim.bo.filetype)
end, {})
