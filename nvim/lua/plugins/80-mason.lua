local M = {
  "williamboman/mason.nvim",
  event = "VeryLazy",
  dependencies = {
    { "WhoIsSethDaniel/mason-tool-installer.nvim" },
  },
}

M.tools = {
  -- DAP
  "debugpy",
  -- "node-debug2-adapter",

  -- Linter
  "cmakelang",
  "cpplint",
  "eslint_d",
  "flake8",
  -- "luacheck",
  "markdownlint",
  "pylint",
  "yamllint",

  -- Formatter
  "autopep8",
  "cmakelang",
  "isort",
  -- "luaformatter",
  "prettier",
  "shfmt",
  "stylua",
}

M.config = function(_)
  require("mason").setup({
    ui = {
      keymaps = {
        -- Keymap to expand a package
        toggle_package_expand = "<CR>",
        -- Keymap to install the package under the current cursor position
        install_package = "i",
        -- Keymap to reinstall/update the package under the current cursor position
        update_package = "u",
        -- Keymap to check for new version for the package under the current cursor position
        check_package_version = "c",
        -- Keymap to update all installed packages
        update_all_packages = "U",
        -- Keymap to check which installed packages are outdated
        check_outdated_packages = "C",
        -- Keymap to uninstall a package
        uninstall_package = "X",
        -- Keymap to cancel a package installation
        cancel_installation = "<C-c>",
        -- Keymap to apply language filter
        apply_language_filter = "<C-f>",
      },
    },
    max_concurrent_installers = 8,
  })
  require("mason-tool-installer").setup({
    ensure_installed = M.tools,
    auto_update = true,
    run_on_start = true,
  })
end

return M
