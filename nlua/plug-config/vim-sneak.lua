vim.g["sneak#label"] = 1

-- case insensitive sneak
vim.g["sneak#use_ic_scs"] = 1

-- immediately move to the next instance of search, if you move the cursor sneak is back to default behavior
vim.g["sneak#s_next"] = 1

-- Cool prompts
vim.g["sneak#prompt"] = "🔎"

-- remap so I can use , and ; with f and t
vim.cmd([[
map gS <Plug>Sneak_,
map gs <Plug>Sneak_;
]])
