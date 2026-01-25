local function select(target)
  return function()
    require("nvim-treesitter-textobjects.select").select_textobject(target, "textobjects")
  end
end

local function swap(target, previous)
  return function()
    local method = previous and "swap_previous" or "swap_next"
    require("nvim-treesitter-textobjects.swap")[method](target, "textobjects")
  end
end

local function swapn(target)
  return swap(target, false)
end

local function swapp(target)
  return swap(target, true)
end

local function move(target, previous, group)
  return function()
    local method = string.format([[goto_%s_start]], previous and "previous" or "next")
    require("nvim-treesitter-textobjects.move")[method](target, group or "textobjects")
  end
end

local function moven(target, locals)
  return move(target, false, locals)
end

local function movep(target, locals)
  return move(target, true, locals)
end

local function repeatable(func)
  return function()
    return require("nvim-treesitter-textobjects.repeatable_move")[func]()
  end
end

local function makemap(lhs, rhs, modes, opts)
  opts = opts or {}
  opts.mode = {}
  for i = 1, #modes do
    opts.mode[i] = modes:sub(i, i)
  end
  opts[1] = lhs
  opts[2] = rhs
  return opts
end

return {
  "nvim-treesitter/nvim-treesitter-textobjects",
  branch = "main",
  keys = {
    -- Select
    makemap("af", select("@function.outer"), "ox"),
    makemap("if", select("@function.inner"), "ox"),
    makemap("ac", select("@class.outer"), "ox"),
    makemap("ic", select("@class.inner"), "ox"),
    makemap("aa", select("@parameter.outer"), "ox"),
    makemap("ia", select("@parameter.inner"), "ox"),
    -- Swap
    makemap("]a", swapn("@parameter.inner"), "n"),
    makemap("[a", swapp("@parameter.inner"), "n"),
    -- Move
    makemap("]f", moven("@function.outer"), "nxo"),
    makemap("[f", movep("@function.outer"), "nxo"),
    makemap("]c", moven("@class.outer"), "nxo"),
    makemap("[c", movep("@class.outer"), "nxo"),
    makemap("]s", moven("@local.scope", "locals"), "nxo"),
    makemap("[s", movep("@local.scope", "locals"), "nxo"),
    makemap("]d", moven("@conditional.outer"), "nxo"),
    makemap("[d", movep("@conditional.outer"), "nxo"),
    -- Repeatable move
    makemap(";", repeatable("repeat_last_move_next"), "nxo"),
    makemap(",", repeatable("repeat_last_move_previous"), "nxo"),
    makemap("f", repeatable("builtin_f_expr"), "nxo", { expr = true }),
    makemap("F", repeatable("builtin_F_expr"), "nxo", { expr = true }),
    makemap("t", repeatable("builtin_t_expr"), "nxo", { expr = true }),
    makemap("T", repeatable("builtin_T_expr"), "nxo", { expr = true }),
  },
  opts = {
    select = {
      lookahead = true,
      selection_modes = {
        ["@function.outer"] = "V",
        ["@class.outer"] = "V",
      },
    },
  },
}
