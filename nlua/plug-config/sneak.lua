vim.g["sneak#label"] = 1

-- case insensitive sneak
vim.g["sneak#use_ic_scs"] = 1

-- immediately move to the next instance of search, if you move the cursor sneak is back to default behavior
vim.g["sneak#s_next"] = 1

-- remap so I can use , and ; with f and t
vim.cmd([[
map gS <Plug>Sneak_,
map gs <Plug>Sneak_;
]])

-- Change the colors
vim.cmd([[
highlight Sneak guifg=black guibg=#00C7DF ctermfg=black ctermbg=cyan
highlight SneakScope guifg=red guibg=yellow ctermfg=red ctermbg=yellow
]])
