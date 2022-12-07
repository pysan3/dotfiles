autocmd FileType sh,bash,zsh,fish,vim setlocal shiftwidth=2

function! RemoveRequireCache(name)
  lua package.loaded[vim.api.nvim_eval("a:name")] = nil
endfunction

augroup packer_user_config
  autocmd!
  autocmd BufWritePost *config/init.lua call RemoveRequireCache(expand("<afile>:p:h:t"))
augroup end

nnoremap <leader><leader>r :PackerSync<CR>
nnoremap <leader><leader>x :PackerCompile<CR>

lua <<EOF
local aug = vim.api.nvim_create_augroup("DisableNullUserJS", {})

vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
  group = aug,
  pattern = { "user.js" },
  callback = function()
    require("null-ls").disable({
      name = "eslint"
    })
  end
})
EOF
