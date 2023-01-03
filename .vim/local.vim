autocmd FileType sh,bash,zsh,fish,vim setlocal shiftwidth=2

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
