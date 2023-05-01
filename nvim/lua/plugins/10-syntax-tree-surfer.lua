local function keymaps(lhs, rhs, modes, is_expr, noremap, desc)
  return { lhs, rhs, mode = modes, expr = is_expr, noremap = noremap, silent = true, desc = desc }
end

return {
  "ziontee113/syntax-tree-surfer",
  keys = {
    -- Swap The Master Node relative to the cursor with it's siblings, Dot Repeatable
    keymaps("vU", function()
      vim.opt.opfunc = "v:lua.STSSwapUpNormal_Dot"
      return "g@l"
    end, "n", true, false, "v:lua.STSSwapUpNormal_Dot"),
    keymaps("vD", function()
      vim.opt.opfunc = "v:lua.STSSwapDownNormal_Dot"
      return "g@l"
    end, "n", true, false, "v:lua.STSSwapDownNormal_Dot"),
    -- Swap Current Node at the Cursor with it's siblings, Dot Repeatable
    keymaps("vd", function()
      vim.opt.opfunc = "v:lua.STSSwapCurrentNodeNextNormal_Dot"
      return "g@l"
    end, "n", true, false, "v:lua.STSSwapCurrentNodeNextNormal_Dot"),
    keymaps("vd", function()
      vim.opt.opfunc = "v:lua.STSSwapCurrentNodePrevNormal_Dot"
      return "g@l"
    end, "n", true, false, "v:lua.STSSwapCurrentNodePrevNormal_Dot"),
    -- Visual Selection from Normal Mode
    keymaps("vx", "<Cmd>STSSelectMasterNode<CR>", "n", false, true),
    keymaps("vn", "<Cmd>STSSelectCurrentNode<CR>", "n", false, true),
    -- Select Nodes in Visual Mode
    keymaps("J", "<Cmd>STSSelectNextSiblingNode<CR>", "x", false, true),
    keymaps("K", "<Cmd>STSSelectPrevSiblingNode<CR>", "x", false, true),
    keymaps("H", "<Cmd>STSSelectParentNode<CR>", "x", false, true),
    keymaps("L", "<Cmd>STSSelectChildNode<CR>", "x", false, true),
    -- Swapping Nodes in Visual Mode
    keymaps("[n", "<Cmd>STSSwapPrevVisual<CR>", "x", false, true),
    keymaps("]n", "<Cmd>STSSwapNextVisual<CR>", "x", false, true),
  },
  config = function()
    require("syntax-tree-surfer")
  end,
}
