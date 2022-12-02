autocmd FileType sh,bash,zsh,fish,vim setlocal shiftwidth=2

function! RemoveRequireCache(name)
  lua package.loaded[vim.api.nvim_eval("a:name")] = nil
  lua require("packer").reset()
  source nlua/00-plug-config/init.lua
endfunction

augroup packer_user_config
  autocmd!
  autocmd BufWritePost *config/init.lua call RemoveRequireCache(expand("<afile>:p:h:t")) | PackerSync
augroup end

nnoremap <leader><leader>r :PackerSync<CR>

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
