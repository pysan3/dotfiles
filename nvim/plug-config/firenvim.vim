if exists('g:started_by_firenvim')
    au BufEnter github.com_*.txt set filetype=markdown

    let g:firenvim_config = {
        \ 'globalSettings': {
            \ 'alt': 'all',
        \  },
        \ 'localSettings': {
            \ '.*': {
                \ 'cmdline': 'neovim',
                \ 'content': 'text',
                \ 'priority': 0,
                \ 'selector': 'textarea',
                \ 'takeover': 'always',
            \ },
        \ }
    \ }

    let fc = g:firenvim_config['localSettings']
    let fc['https?://.*twitter.*/'] = { 'takeover': 'never', 'priority': 1 }
    let fc['https?://.*instagram.*/'] = { 'takeover': 'never', 'priority': 1 }
endif
