" telescope setup
lua << EOF
require('telescope').setup {
    defaults = {
        mappings = {
            i = {
                ["<esc>"] = require('telescope.actions').close,
                }
            },
        -- put prompt (input box) position to the top
        layout_config = {
            prompt_position = "top",
            },
        -- ripgrep remove indentation
        vimgrep_arguments = {
            "rg",
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--smart-case",
            "--trim"
            }
        },
    pickers = {
        -- remove ./ from fd results
        find_files = {
            find_command = { "fd", "--type", "f", "--strip-cwd-prefix" }
            }
        },
    extensions = {
        fzf = {
            fuzzy = true,                    -- false will only do exact matching
            override_generic_sorter = true,  -- override the generic sorter
            override_file_sorter = true,     -- override the file sorter
            case_mode = "smart_case",        -- or "ignore_case" or "respect_case", the default case_mode is "smart_case"
            }
        }
    }
require('telescope').load_extension('fzf')
EOF

nnoremap <leader>fp <cmd>Telescope git_files<cr>
nnoremap <leader>fl <cmd>Telescope find_files<cr>
nnoremap <leader>fs <cmd>Telescope live_grep<cr>
" nnoremap <leader>fb <cmd>Telescope buffers<cr>
" nnoremap <leader>fh <cmd>Telescope help_tags<cr>

