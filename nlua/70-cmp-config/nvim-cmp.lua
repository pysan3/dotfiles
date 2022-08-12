-- stylua: ignore start
local cmp_icons = { Text = "", Method = "m", Function = "", Constructor = "",
  Field = "", Variable = "", Class = "", Interface = "", Module = "",
  Property = "", Unit = "", Value = "", Enum = "", Keyword = "", Snippet = "",
  Color = "", File = "", Reference = "", Folder = "", EnumMember = "",
  Constant = "", Struct = "", Event = "", Operator = "", TypeParameter = "" }
-- stylua: ignore end
-- find more here: https://www.nerdfonts.com/cheat-sheet

local cmp = require("cmp")
local luasnip = require("luasnip")

---Check whether `check` and call action or fallback
---@param check boolean: true -> action(), false -> fallback()
---@param action function
---@param fallback function
---@return any: result of calling action or fallback
local function call_with_fallback(check, action, fallback)
  if check then
    return action()
  else
    return fallback()
  end
end

cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = {
    ["<C-p>"] = cmp.mapping.select_prev_item(),
    ["<C-n>"] = cmp.mapping.select_next_item(),
    ["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
    ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
    ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
    ["<C-y>"] = cmp.config.disable, -- disable default keybind
    ["<C-e>"] = cmp.mapping(function(fallback)
      call_with_fallback(luasnip.choice_active(), function()
        luasnip.change_choice(-1)
      end, fallback)
    end, { "i", "s" }),
    ["<C-d>"] = cmp.mapping(function(fallback)
      call_with_fallback(luasnip.choice_active(), function()
        luasnip.change_choice(1)
      end, fallback)
    end, { "i", "s" }),
    ["<CR>"] = cmp.mapping.confirm({ select = false }),
    ["<C-l>"] = cmp.mapping(function(fallback)
      call_with_fallback(luasnip.in_snippet() and luasnip.jumpable(), function()
        luasnip.jump(1)
      end, fallback)
    end, { "i", "s" }),
    ["<C-h>"] = cmp.mapping(function(fallback)
      call_with_fallback(luasnip.jumpable(-1), function()
        luasnip.jump(-1)
      end, fallback)
    end, { "i", "s" }),
    ["<Tab>"] = cmp.mapping.confirm({ select = true }),
    ["<S-Tab>"] = cmp.mapping.select_prev_item(),
  },
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "nvim_lua" },
    { name = "luasnip" },
    { name = "path" },
  }, {
    {
      name = "buffer",
      option = {
        keyword_length = 2,
        get_bufnrs = function() -- from all visible buffers
          local bufs = {}
          for _, win in ipairs(vim.api.nvim_list_wins()) do
            bufs[vim.api.nvim_win_get_buf(win)] = true
          end
          return vim.tbl_keys(bufs)
        end,
      },
    },
    { name = "dictionary", keyword_length = 2 },
    { name = "spell" },
    { name = "emoji" },
    { name = "calc" },
  }),
  formatting = {
    fields = { "kind", "abbr", "menu" },
    format = function(entry, vim_item)
      vim_item.kind = string.format("%s", cmp_icons[vim_item.kind])
      vim_item.menu = ({
        nvim_lsp = "[LSP ]",
        nvim_lua = "[NLUA]",
        luasnip = "[Snip]",
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
  confirm_opts = {
    behavior = cmp.ConfirmBehavior.Replace,
    select = false,
  },
  experimental = {
    -- ghost_text = true,
  },
  window = {
    documentation = {
      border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
    },
  },
})

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
    -- ["lua"] = "path/to/lua.dic",
    -- ["javascript,typescript"] = { "path/to/js.dic", "path/to/js2.dic" },
    -- filename = {
    --   ["xmake.lua"] = { "path/to/xmake.dic", "path/to/lua.dic" },
    -- },
    -- filepath = {
    --   ["%.tmux.*%.conf"] = "path/to/tmux.dic"
    -- },
  },
  exact = 2,
  first_case_insensitive = true,
  async = false,
  capacity = 5,
  debug = false,
})
