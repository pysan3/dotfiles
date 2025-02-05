local M = {
  "hrsh7th/nvim-cmp",
  event = "InsertEnter",
  version = false,
  dependencies = {
    { "hrsh7th/cmp-buffer" }, -- buffer completions
    { "riton/cmp-path", branch = "feature/get_cwd_array" }, -- path completions
    { "hrsh7th/cmp-cmdline" }, -- cmdline completions
    { "hrsh7th/cmp-calc" },
    { "f3fora/cmp-spell" },
    { "hrsh7th/cmp-emoji" },
    { "hrsh7th/cmp-cmdline" },
    { "saadparwaiz1/cmp_luasnip" },
    { "uga-rosa/cmp-dictionary" }, -- config
    { "petertriho/cmp-git" }, -- config
    { "Gelio/cmp-natdat", config = { cmp_kind_text = "NatDat" } },
    { "alexander-born/cmp-bazel" },
    { "L3MON4D3/LuaSnip" },
    { "windwp/nvim-autopairs" },
  },
}

M.config = function()
  local cmp = require("cmp")
  local types = require("cmp.types")
  local compare = require("cmp.config.compare")
  local luasnip = require("luasnip")

  local lsp_icons = vim.g.personal_options.lsp_icons
  lsp_icons["NatDat"] = "📆"
  local entry_menu = {
    nvim_lsp = "[LSP ]",
    luasnip = "[Snip]",
    buffer = "[Buff]",
    path = "[Path]",
    dictionary = "[Text]",
    spell = "[Spll]",
    calc = "[Calc]",
    natdat = "[NDat]",
  }

  ---Check whether `check` and call action or fallback
  ---@param do_action boolean: true -> action(), false -> fallback()
  ---@param action function
  ---@param fallback function
  ---@return any: result of calling action or fallback
  local function action_or_fallback(do_action, action, fallback)
    if do_action then
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
      keyword_length = 3,
      get_bufnrs = function() -- from all buffers (less than 1MB)
        local bufs = {}
        for _, bufn in ipairs(vim.api.nvim_list_bufs()) do
          local buf_size = vim.api.nvim_buf_get_offset(bufn, vim.api.nvim_buf_line_count(bufn))
          if buf_size < 10 * 1024 then
            table.insert(bufs, bufn)
          end
        end
        return bufs
      end,
    },
  }
  local cwd = vim.fn.getcwd()
  local paths = {
    name = "path",
    option = {
      get_cwd = function(params)
        return { vim.fn.expand(("#%d:p:h"):format(params.context.bufnr)), cwd }
      end,
    },
  }

  cmp.setup({ ---@diagnostic disable-line
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
      -- ["<C-Space>"] = cmp.mapping(cmp.mapping.complete({}), { "i", "c" }),
      ["<C-e>"] = cmp.mapping(function(fallback)
        action_or_fallback(luasnip.choice_active(), function()
          luasnip.change_choice(-1)
        end, fallback)
      end, { "i", "s" }),
      ["<C-d>"] = cmp.mapping(function(fallback)
        action_or_fallback(luasnip.choice_active(), function()
          luasnip.change_choice(1)
        end, fallback)
      end, { "i", "s" }),
      ["<CR>"] = cmp.mapping.confirm({ select = false }),
      ["<C-l>"] = cmp.mapping(function(fallback)
        action_or_fallback(luasnip.in_snippet() and luasnip.jumpable(1), function()
          luasnip.jump(1)
        end, fallback)
      end, { "i", "s" }),
      ["<C-a>"] = cmp.mapping(function(fallback)
        action_or_fallback(luasnip.jumpable(-1), function()
          luasnip.jump(-1)
        end, fallback)
      end, { "i", "s" }),
      ["<Tab>"] = cmp.mapping.confirm({ select = true }),
      ["<S-Tab>"] = cmp.mapping.select_prev_item(),
    },
    sources = cmp.config.sources({
      { name = "nvim_lsp", keyword_length = 3 },
      { name = "luasnip" },
      { name = "neorg" },
      { name = "bazel" },
      paths,
    }, {
      buffers,
      { name = "dictionary", keyword_length = 3 },
      { name = "spell" },
      { name = "calc" },
      { name = "emoji" },
      { name = "git" },
      { name = "natdat" },
    }),
    formatting = {
      expandable_indicator = true,
      fields = { "kind", "abbr", "menu" },
      format = function(entry, vim_item)
        vim_item.kind = lsp_icons[vim_item.kind] or " "
        vim_item.menu = entry_menu[entry.source.name]
        return vim_item
      end,
    },
    matching = {
      disallow_fuzzy_matching = false, -- fmodify -> fnamemodify
      disallow_fullfuzzy_matching = true,
      disallow_partial_fuzzy_matching = true,
      disallow_partial_matching = false, -- fb -> foo_bar
      disallow_prefix_unmatching = true, -- bar -> foo_bar
      disallow_symbol_nonprefix_matching = false,
    },
    sorting = {
      -- https://github.com/hrsh7th/nvim-cmp/blob/main/lua/cmp/config/compare.lua
      comparators = {
        compare.offset,
        compare.exact,
        -- function(entry1, entry2) -- sort by length ignoring "=~"
        --   local len1 = string.len(string.gsub(entry1.completion_item.label, "[=~()_]", ""))
        --   local len2 = string.len(string.gsub(entry2.completion_item.label, "[=~()_]", ""))
        --   if len1 ~= len2 then
        --     return len1 - len2 < 0
        --   end
        -- end,
        compare.recently_used, ---@diagnostic disable-line
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
      priority_weight = 2,
    },
    confirm_opts = {
      behavior = cmp.ConfirmBehavior.Replace,
      select = false,
    },
    experimental = {
      ghost_text = false,
    },
    performance = {
      debounce = 60,
      throttle = 30,
      fetching_timeout = 500,
      confirm_resolve_timeout = 80,
      async_budget = 1,
      max_view_entries = 200,
    },
    window = {
      completion = cmp.config.window.bordered(),
      documentation = cmp.config.window.bordered(),
    },
  })

  -- from nvim-autopairs
  local cmp_autopairs = require("nvim-autopairs.completion.cmp")
  cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done({ map_char = { tex = "" } }))

  -- from cmdline
  cmp.setup.cmdline(":", { ---@diagnostic disable-line
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = "path" },
    }, {
      { name = "cmdline" },
    }),
  })
end

return M
