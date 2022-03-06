lua << EOF
require("neogit").setup {
    disable_signs = false,
    disable_hint = false,
    disable_context_highlighting = false,
    disable_commit_confirmation = true,
    disable_insert_on_commit = false,
    auto_refresh = true,
    disable_builtin_notifications = false,
    commit_popup = {
        kind = "split",
        },
    -- Change the default way of opening neogit
    kind = "split",
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
            folded = false
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

nnoremap [neogit] <Nop>

nmap <Leader>g [neogit]
nnoremap [neogit]s :Neogit kind=split<CR>
nnoremap [neogit]d :DiffviewOpen<CR>
nnoremap [neogit]D :DiffviewOpen master<CR>
nnoremap [neogit]g :Neogit log<CR>
nnoremap [neogit]l :Neogit pull<CR>
nnoremap [neogit]p :Neogit push<CR>

lua << EOF
require('gitsigns').setup()
EOF

" highlight conflicts
" details: https://github.com/rhysd/conflict-marker.vim
highlight ConflictMarkerBegin guibg=#2f7366
highlight ConflictMarkerOurs guibg=#2e5049
highlight ConflictMarkerTheirs guibg=#344f69
highlight ConflictMarkerEnd guibg=#2f628e
highlight ConflictMarkerCommonAncestorsHunk guibg=#754a81
