-- stylua: ignore start
local cmp_icons = { Text = "", Method = "m", Function = "", Constructor = "",
Field = "", Variable = "", Class = "", Interface = "", Module = "",
Property = "", Unit = "", Value = "", Enum = "", Keyword = "", Snippet =
"", Color = "", File = "", Reference = "", Folder = "", EnumMember = "",
Constant = "", Struct = "", Event = "", Operator = "", TypeParameter = ""}
-- stylua: ignore end
-- find more here: https://www.nerdfonts.com/cheat-sheet

local cmp = require("cmp")
local ultimap = require("cmp_nvim_ultisnips.mappings")
cmp.setup({
  snippet = {
    expand = function(args)
      vim.fn["UltiSnips#Anon"](args.body)
    end,
  },
  sources = {
    { name = "nvim_lsp" },
    { name = "nvim_lua" },
    { name = "ultisnips" },
    { name = "buffer" },
    { name = "dictionary", keyword_length = 3 },
    { name = "path" },
    { name = "spell" },
    { name = "emoji" },
    { name = "calc" },
  },
  formatting = {
    fields = { "kind", "abbr", "menu" },
    format = function(entry, vim_item)
      vim_item.kind = string.format("%s", cmp_icons[vim_item.kind])
      vim_item.menu = ({
        nvim_lsp = "[LSP ]",
        nvim_lua = "[NLUA]",
        ultisnips = "[Snip]",
        buffer = "[Buff]",
        path = "[Path]",
        dictionary = "[Text]",
        emoji = "[Text]",
        spell = "[Spll]",
        calc = "[Calc]",
      })[entry.source.name]
      return vim_item
    end,
  },
  mapping = {
    ["<C-p>"] = cmp.mapping.select_prev_item(),
    ["<C-n>"] = cmp.mapping.select_next_item(),
    ["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-1), { "i", "c" }),
    ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(1), { "i", "c" }),
    ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
    ["<C-y>"] = cmp.config.disable, -- disable default keybind
    ["<C-e>"] = cmp.mapping({
      i = cmp.mapping.abort(),
      c = cmp.mapping.close(),
    }),
    ["<CR>"] = cmp.mapping.confirm({ select = false }),
    ["<C-l>"] = cmp.mapping(function(fallback)
      ultimap.compose({ "expand", "jump_forwards" })(fallback)
    end, { "i", "s" }),
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.confirm({ select = true })
      else
        ultimap.compose({ "expand", "select_next_item" })(fallback)
      end
    end, { "i", "s" }),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      ultimap.jump_backwards(fallback)
    end, { "i", "s" }),
  },
  confirm_opts = {
    behavior = cmp.ConfirmBehavior.Replace,
    select = false,
  },
  documentation = {
    border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
  },
  experimental = {
    ghost_text = true,
    -- native_menu = true,
  },
})

-- from UltiSnips
require("cmp_nvim_ultisnips").setup({})
vim.cmd([[
augroup CMP_NVIM_ULTISNIPS
  autocmd BufWritePost *.snippets :CmpUltisnipsReloadSnippets
augroup END
]])

-- from nvim-autopairs
local cmp_autopairs = require("nvim-autopairs.completion.cmp")
cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done({ map_char = { tex = "" } }))

-- from cmp-dictionary
local dict_source = {}
-- add my spell lists; $XDG_CONFIG_HOME/nvim/spell/*.add
for filepath in string.gmatch(vim.fn.glob(vim.env.XDG_CONFIG_HOME .. "/nvim/spell/*.add"), "[^\n]+") do
  table.insert(dict_source, filepath)
end
-- add system installed dictionaries
local share_dict_source = {
  "american-english", -- wamerican
  "american-english-insane", -- wamerican-insane
  "ngerman", -- wngerman
}
for _, source in ipairs(share_dict_source) do
  if vim.fn.filereadable(vim.fn.expand("/usr/share/dict/" .. source)) ~= 0 then
    table.insert(dict_source, "/usr/share/dict/" .. source)
  end
end
print(vim.inspect(dict_source))

require("cmp_dictionary").setup({
  dic = {
    ["*"] = dict_source,
    -- ["lua"] = "path/to/lua.dic",
    -- ["javascript,typescript"] = { "path/to/js.dic", "path/to/js2.dic" },
    -- filename = {
    --   ["xmake.lua"] = { "path/to/xmake.dic", "path/to/lua.dic" },
    -- },
    -- filepath = {
    --   ["%.tmux.*%.conf"] = "path/to/tmux.dic"
    -- },
  },
  exact = 3,
  first_case_insensitive = true,
  async = false,
  capacity = 5,
  debug = false,
})
