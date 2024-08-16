local M = {
  "nvim-neorg/neorg",
  ft = "norg",
  version = false,
  dependencies = {
    "luarocks.nvim",
    "nvim-treesitter/nvim-treesitter",
    "nvim-treesitter/nvim-treesitter-textobjects",
    "nvim-cmp",
    "mason.nvim",
    "plenary.nvim",
    -- "image.nvim",
    -- external modules
    "laher/neorg-exec",
    "phenax/neorg-hop-extras",
    { "pysan3/neorg-templates-draft", dependencies = { "L3MON4D3/LuaSnip" } },
    { "nvim-neorg/neorg-telescope", dependencies = { "nvim-telescope/telescope.nvim" } },
  },
  -- build = ":Neorg sync-parsers",
  cmd = "Neorg",
  default_workspace = "Notes",
  aug = vim.api.nvim_create_augroup("NorgAuG", { clear = true }),
}

M.popup = nil
M.bufnr = nil
M.open_index_in_popup = function()
  if not M.popup then
    M.popup = require("nui.popup")({
      bufnr = M.bufnr,
      size = { width = "80%", height = "90%" },
      position = { col = "50%", row = "50%" },
      enter = true,
      focusable = true,
      relative = "editor",
      border = {
        style = "rounded",
      },
      win_options = {
        winhighlight = "Normal:Normal,FloatBorder:WinSeparator",
      },
    })
  end
  vim.api.nvim_create_autocmd("WinEnter", {
    group = M.aug,
    pattern = "*.norg",
    callback = function()
      if vim.api.nvim_get_current_win() == M.popup.winid then
        vim.keymap.set({ "n", "i", "v" }, "<C-q>", function()
          vim.cmd.write()
          M.popup:hide()
        end, { buffer = M.popup.bufnr, remap = false })
      end
    end,
  })
  vim.api.nvim_create_autocmd("WinLeave", {
    group = M.aug,
    callback = function(args)
      if vim.api.nvim_get_current_win() == M.popup.winid then
        M.bufnr = args.buf
        M.popup:hide()
      end
    end,
  })
  if M.bufnr and vim.api.nvim_buf_is_valid(M.bufnr) then
    M.popup.bufnr = M.bufnr
  end
  M.popup:mount()
  M.popup:show()
  if vim.bo[vim.api.nvim_win_get_buf(M.popup.winid)].filetype ~= "norg" then
    vim.cmd.edit("index.norg")
  end
end

M.keys = {
  { ",ni", "<Cmd>Neorg index<CR>" },
  { "<Leader>tt", M.open_index_in_popup, desc = "Open Neorg index in a popup window" },
}

local function map(ft, mode, key, cmd, opts)
  M.keys[#M.keys + 1] = vim.tbl_extend("force", opts or {}, { key, cmd, mode = mode, ft = ft })
end

local function map_event(ft, mode, key, action, opts)
  opts = opts or {}
  opts.noremap = false
  map(ft, mode, key, string.format("<Plug>(%s)", action), opts)
end

local prefix = vim.g.personal_options.prefix
local neorg_prefix = prefix.neorg
map("norg", "n", neorg_prefix .. "e", function()
  vim.cmd([[!norgc '%' gfm >/dev/null]])
end, { desc = "Neorg: export to markdown and open file" })
map("norg", "n", neorg_prefix .. "E", function()
  vim.cmd([[!norgc '%' gfm >/dev/null]])
  vim.cmd.vsplit(vim.fn.fnameescape(vim.fn.expand("%:p:.:r") .. ".md"))
  vim.cmd([[GithubPreviewStart]])
end, { desc = "Neorg: export to markdown and open MarkdownPreview" })
map_event("norg", "n", neorg_prefix .. "c", "neorg.looking-glass.magnify-code-block")
map("norg", "n", neorg_prefix .. "q", "<Cmd>Neorg return<CR>")
map("norg", "n", "[h", function()
  require("norg-config.keybinds").goto_headline("previous")
end, { desc = "Neorg: Go to previous headline" })
map("norg", "n", "]h", function()
  require("norg-config.keybinds").goto_headline("next")
end, { desc = "Neorg: Go to next headline" })
map_event("norg", "i", "<M-CR>", "neorg.itero.next-iteration")
map("norg", "n", prefix.iron .. "x", "<Cmd>Neorg exec cursor<CR>")
map("norg", "n", prefix.iron .. "X", "<Cmd>Neorg exec current-file<CR>")
-- https://github.com/nvim-neorg/neorg-telescope
map_event("norg", "n", prefix.telescope .. "l", "neorg.integrations.telescope.find_linkable")

M.init = function()
  require("norg-config.commands").setup({})
  vim.api.nvim_create_autocmd("BufWritePost", {
    group = M.aug,
    pattern = "*.norg",
    command = "Neorg tangle current-file",
  })
end

local function list_workspaces(w_dirs)
  local res = {}
  for _, w in ipairs(w_dirs) do
    res[w] = "~/Nextcloud/" .. w
  end
  return res
end

local function load_plugins()
  return {
    ["core.defaults"] = {},
    ["core.concealer"] = {
      config = {
        icon_preset = "diamond",
        icons = { code_block = { spell_check = false } },
      },
    },
    ["core.completion"] = { config = { engine = "nvim-cmp", name = "[Norg]" } },
    ["core.esupports.metagen"] = { config = { type = "auto", update_date = true } },
    ["core.integrations.nvim-cmp"] = {},
    ["core.integrations.telescope"] = {},
    -- ["core.integrations.image"] = {},
    -- ["core.latex.renderer"] = {},
    ["core.qol.toc"] = {},
    ["core.qol.todo_items"] = {},
    ["core.looking-glass"] = {},
    ["core.export"] = {},
    ["core.export.markdown"] = { config = { extensions = "all" } },
    ["core.presenter"] = { config = { zen_mode = "zen-mode" } },
    ["core.summary"] = {},
    ["core.tangle"] = { config = { report_on_empty = false } },
    ["core.ui.calendar"] = {},
    ["core.journal"] = {
      config = {
        strategy = "nested",
        workspace = M.default_workspace,
      },
    },
    ["core.dirman"] = {
      config = {
        workspaces = list_workspaces({
          M.default_workspace,
          "Works",
        }),
        default_workspace = "default",
      },
    },
    ["core.keybinds"] = {
      -- https://github.com/nvim-neorg/neorg/blob/main/lua/neorg/modules/core/keybinds/keybinds.lua
      config = {
        default_keybinds = true,
      },
    },
    ["external.templates"] = {
      config = {
        templates_dir = vim.fn.stdpath("config") .. "/templates/norg",
        keywords = require("norg-config.templates"),
      },
    },
    -- ["external.exec"] = {},
    -- ["external.hop-extras"] = {},
  }
end

M.config = function()
  require("neorg").setup({
    load = load_plugins(),
  })
end

return M
