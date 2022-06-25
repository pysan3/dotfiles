vim.g.startify_session_dir = vim.fn.stdpath("data") .. "/session"

vim.g.startify_lists = {
  { type = "sessions", header = { "   Sessions" } },
  { type = "files", header = { "   Files" } },
  { type = "dir", header = { "   Current Directory " .. vim.fn.getcwd() } },
  { type = "bookmarks", header = { "   Bookmarks" } },
}

vim.g.startify_session_autoload = 1
vim.g.startify_session_delete_buffers = 1
vim.g.startify_change_to_vcs_root = 1
vim.g.startify_fortune_use_unicode = 1
vim.g.startify_session_persistence = 0
vim.g.startify_enable_special = 0
