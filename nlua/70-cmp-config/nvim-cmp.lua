-- stylua: ignore start
local cmp_icons = { Text = "", Method = "m", Function = "", Constructor = "",
  Field = "", Variable = "", Class = "", Interface = "", Module = "",
  Property = "", Unit = "", Value = "", Enum = "", Keyword = "", Snippet = "",
  Color = "", File = "", Reference = "", Folder = "", EnumMember = "",
  Constant = "", Struct = "", Event = "", Operator = "", TypeParameter = "" }
-- stylua: ignore end
-- find more here: https://www.nerdfonts.com/cheat-sheet

local cmp = require("cmp")
local types = require("cmp.types")
local compare = require("cmp.config.compare")
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

---@type table<integer, integer>
local modified_priority = {
  [types.lsp.CompletionItemKind.Variable] = types.lsp.CompletionItemKind.Method,
  [types.lsp.CompletionItemKind.Snippet] = 0, -- top
  [types.lsp.CompletionItemKind.Keyword] = 0, -- top
  [types.lsp.CompletionItemKind.Text] = 100, -- bottom
}
---@param kind integer: kind of completion entry
local function modified_kind(kind)
  return modified_priority[kind] or kind
end

local buffers = {
  name = "buffer",
  option = {
    keyword_length = 2,
    get_bufnrs = function() -- from all buffers (less than 1MB)
      local bufs = {}
      for _, bufn in ipairs(vim.api.nvim_list_bufs()) do
        local buf_size = vim.api.nvim_buf_get_offset(bufn, vim.api.nvim_buf_line_count(bufn))
        if buf_size < 1024 * 1024 then
          table.insert(bufs, bufn)
        end
      end
      return bufs
    end,
  },
}

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
    ["<C-Space>"] = cmp.mapping(cmp.mapping.complete({}), { "i", "c" }),
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
      call_with_fallback(luasnip.in_snippet() and luasnip.jumpable() or false, function()
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
    { name = "git" },
    { name = "nvim_lsp" },
    { name = "nvim_lua" },
    { name = "luasnip" },
    { name = "path" },
  }, {
    buffers,
    { name = "dictionary", keyword_length = 3 },
    { name = "spell" },
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
        spell = "[Spll]",
        calc = "[Calc]",
      })[entry.source.name]
      return vim_item
    end,
  },
  sorting = {
    -- https://github.com/hrsh7th/nvim-cmp/blob/main/lua/cmp/config/compare.lua
    comparators = {
      compare.offset,
      compare.exact,
      compare.recently_used,
      function(entry1, entry2) -- sort by length ignoring "=~"
        local len1 = string.len(string.gsub(entry1.completion_item.label, "[=~()]", ""))
        local len2 = string.len(string.gsub(entry2.completion_item.label, "[=~()]", ""))
        if len1 ~= len2 then
          return len1 - len2 < 0
        end
      end,
      function(entry1, entry2) -- sort by compare kind (Variable, Function etc)
        local kind1 = modified_kind(entry1:get_kind())
        local kind2 = modified_kind(entry2:get_kind())
        if kind1 ~= kind2 then
          return kind1 - kind2 < 0
        end
      end,
      function(entry1, entry2) -- score by lsp, if available
        local t1 = entry1.completion_item.sortText
        local t2 = entry2.completion_item.sortText
        if t1 ~= nil and t2 ~= nil and t1 ~= t2 then
          return t1 < t2
        end
      end,
      compare.score,
      compare.order,
    },
  },
  confirm_opts = {
    behavior = cmp.ConfirmBehavior.Replace,
    select = false,
  },
  experimental = {
    ghost_text = true,
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

-- from cmdline
cmp.setup.cmdline(":", {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = "path" },
  }, {
    { name = "cmdline" },
  }),
})
