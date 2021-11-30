lua << EOF
require("neogit").setup {
    disable_signs = false,
    disable_hint = false,
    disable_context_highlighting = false,
    disable_commit_confirmation = true,
    auto_refresh = true,
    disable_builtin_notifications = false,
    commit_popup = {
        kind = "split",
        },
    -- Change the default way of opening neogit
    kind = "tab",
    -- customize displayed signs
    signs = {
        -- { CLOSED, OPENED }
        section = { ">", "v" },
        item = { ">", "v" },
        hunk = { "", "" },
        },
    integrations = {
        diffview = true
        },
    -- Setting any section to `false` will make the section not render at all
    sections = {
        untracked = {
            folded = false
            },
        unstaged = {
            folded = false
            },
        staged = {
            folded = false
            },
        stashes = {
            folded = true
            },
        unpulled = {
            folded = false
            },
        unmerged = {
            folded = false
            },
        recent = {
            folded = false
            },
        },
    -- override/add mappings
    mappings = {
        -- modify status buffer mappings
        status = {
            -- Adds a mapping with "B" as key that does the "BranchPopup" command
            ["B"] = "BranchPopup",
            -- Removes the default mapping of "s"
            -- ["s"] = "",
            -- ["tab"] = "",
            }
        }
    }
EOF

" nnoremap [neogit]s :G<CR>
" nnoremap [neogit]a :G add .<CR>
" nnoremap [neogit]t :GBranches<CR>
" nnoremap [neogit]p :G push --quiet<CR>
" nnoremap [neogit]l :G pull --quiet<CR>
" nnoremap [neogit]b :G blame<CR>
" nnoremap [neogit]d :Gdiff<CR>
" nnoremap [neogit]m :G merge<CR>
" nnoremap [neogit]d :diffget //2<CR>
" nnoremap [neogit]k :diffget //3<CR>
" nnoremap [neogit]v dv<CR>

nnoremap [neogit] <Nop>

nmap <Leader>g [neogit]

nnoremap [neogit]g :Neogit<CR>
nnoremap [neogit]d :DiffviewOpen<CR>
nnoremap [neogit]D :DiffviewOpen master<CR>
nnoremap [neogit]l :Neogit log<CR>
nnoremap [neogit]p :Neogit push<CR>
