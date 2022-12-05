-- from cmp-dictionary
local dict_source = {}
-- add my spell lists; $XDG_CONFIG_HOME/nvim/spell/*.add
for filepath in string.gmatch(vim.fn.glob(vim.env.XDG_CONFIG_HOME .. "/nvim/spell/*.add"), "[^\n]+") do
  table.insert(dict_source, filepath)
end
-- add system installed dictionaries
local share_dict_source = {
  "words",
  "american-english", -- wamerican
  -- "american-english-insane", -- wamerican-insane
  -- "ngerman", -- wngerman
}
for _, source in ipairs(share_dict_source) do
  if vim.fn.filereadable(vim.fn.expand("/usr/share/dict/" .. source)) ~= 0 then
    table.insert(dict_source, "/usr/share/dict/" .. source)
  end
end

require("cmp_dictionary").setup({
  dic = {
    ["*"] = dict_source,
  },
  first_case_insensitive = true,
  async = true,
  capacity = 5,
  max_items = 1000,
})
