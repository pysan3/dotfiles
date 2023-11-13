return {
  "nvim-neo-tree/neo-tree.nvim",
  dev = vim.g.personal_options.debug.neotree,
  version = false,
  dependencies = {
    { "MunifTanjim/nui.nvim" },
    { "nvim-tree/nvim-web-devicons" },
    { "3rd/image.nvim" },
  },
  cmd = { "Neotree" },
  keys = {
    { "<Leader>e", "<Cmd>Neotree toggle reveal<CR>", remap = false, silent = true, desc = "<Cmd>Neotree<CR>" },
  },
  init = function()
    vim.g.neo_tree_remove_legacy_commands = 1
    ---@type string[]
    local argv = vim.fn.argv() or {} ---@diagnostic disable-line
    if vim.tbl_contains(argv, ".") then
      vim.schedule(function()
        pcall(require, "neo-tree")
      end)
    end
  end,
  opts = {
    sources = {
      "filesystem",
      "buffers",
      "git_status",
      "document_symbols",
    },
    auto_clean_after_session_restore = true,
    close_if_last_window = true,
    log_level = vim.g.personal_options.debug.neotree and "trace" or "fatal",
    log_to_file = vim.g.personal_options.debug.neotree,
    sort_case_insensitive = true,
    source_selector = {
      winbar = true,
      sources = {
        { source = "filesystem", display_name = " 󰉓 File " },
        { source = "git_status", display_name = " 󰊢 Git " },
        { source = "buffers", display_name = " 󰓩 Buf " },
        { source = "document_symbols", display_name = "  Sym " },
      },
      content_layout = "center",
    },
    default_component_configs = {
      container = {
        enable_character_fade = true,
      },
      indent = {
        padding = 0,
      },
      icon = {
        folder_empty = "",
        default = "",
        highlight = "None",
      },
      modified = {
        symbol = "[+]",
      },
      git_status = {
        symbols = {
          deleted = "󰧧",
          renamed = "󰁕",
          untracked = "",
          unstaged = "󰄱",
        },
      },
      file_size = { enabled = true },
      type = { enabled = true },
      last_modified = { enabled = false },
      created = { enabled = false },
      symlink_target = { enabled = false },
    },
    nesting_rules = {
      ["js"] = {
        pattern = "(.+)%.js$",
        files = { "%1.js.map", "%1.min.js", "%1.d.ts" },
      },
      [".gitignore"] = {
        pattern = "^%.gitignore$",
        files = { ".gitattributes", ".gitmodules", ".gitmessage", ".mailmap", ".git-blame*" },
      },
      ["package.json"] = {
        pattern = "^package%.json$",
        files = {
          "package-lock.json",
          "yarn*",
          ".browserslist*",
          ".circleci*",
          ".commitlint*",
          ".cz-config.js",
          ".czrc",
          ".dlint.json",
          ".dprint.json*",
          ".editorconfig",
          ".eslint*",
          ".firebase*",
          ".flowconfig",
          ".github*",
          ".gitlab*",
          ".gitpod*",
          ".huskyrc*",
          ".jslint*",
          ".lintstagedrc*",
          ".markdownlint*",
          ".node-version",
          ".nodemon*",
          ".npm*",
          ".nvmrc",
          ".pm2*",
          ".pnp.*",
          ".pnpm*",
          ".prettier*",
          ".release-please*.json",
          ".releaserc*",
          ".sentry*",
          ".simple-git-hooks*",
          ".stackblitz*",
          ".styleci*",
          ".stylelint*",
          ".tazerc*",
          ".textlint*",
          ".tool-versions",
          ".travis*",
          ".versionrc*",
          ".vscode*",
          ".watchman*",
          ".xo-config*",
          ".yamllint*",
          ".yarnrc*",
          "Procfile",
          "apollo.config.*",
          "appveyor*",
          "azure-pipelines*",
          "bower.json",
          "build.config.*",
          "bun.lockb",
          "commitlint*",
          "crowdin*",
          "dangerfile*",
          "dlint.json",
          "dprint.json*",
          "electron-builder.*",
          "eslint*",
          "firebase.json",
          "grunt*",
          "gulp*",
          "jenkins*",
          "lerna*",
          "lint-staged*",
          "nest-cli.*",
          "netlify*",
          "nodemon*",
          "npm-shrinkwrap.json",
          "nx.*",
          "package.nls*.json",
          "phpcs.xml",
          "pm2.*",
          "pnpm*",
          "prettier*",
          "pullapprove*",
          "pyrightconfig.json",
          "release-please*.json",
          "release-tasks.sh",
          "release.config.*",
          "renovate*",
          "rollup.config.*",
          "rspack*",
          "simple-git-hooks*",
          "stylelint*",
          "tslint*",
          "tsup.config.*",
          "turbo*",
          "typedoc*",
          "unlighthouse*",
          "vercel*",
          "vetur.config.*",
          "webpack*",
          "workspace.json",
          "xo.config.*",
        },
      },
      ["readme"] = {
        pattern = "^readme.md",
        ignore_case = true,
        files = {
          "authors",
          "backers*",
          "changelog*",
          "citation*",
          "code_of_conduct*",
          "codeowners",
          "contributing*",
          "contributors",
          "copying*",
          "credits",
          "governance.md",
          "history.md",
          "license*",
          "maintainers",
          "security.md",
          "sponsors*",
        },
      },
      ["go"] = {
        pattern = "(.*)%.go$",
        files = { "%1_test.go" },
      },
      ["docker"] = {
        pattern = "^dockerfile$",
        ignore_case = true,
        files = { ".dockerignore", "docker-compose.*", "dockerfile*" },
      },
      ["composer.json"] = {
        pattern = "^composer%.json$",
        files = { ".php*.cache", "composer.lock", "phpunit.xml*", "psalm*.xml" },
      },
      [".env"] = {
        pattern = "^%.env$",
        files = { "*.env", ".env.*", ".envrc", "env.d.ts" },
      },
      ["vite.config"] = {
        pattern = "^vite%.config%..*",
        files = {
          "*.env",
          ".babelrc*",
          ".codecov",
          ".cssnanorc*",
          ".env.*",
          ".envrc",
          ".htmlnanorc*",
          ".lighthouserc.*",
          ".mocha*",
          ".postcssrc*",
          ".terserrc*",
          "api-extractor.json",
          "ava.config.*",
          "babel.config.*",
          "contentlayer.config.*",
          "cssnano.config.*",
          "cypress.*",
          "env.d.ts",
          "formkit.config.*",
          "formulate.config.*",
          "histoire.config.*",
          "htmlnanorc.*",
          "i18n.config.*",
          "jasmine.*",
          "jest.config.*",
          "jsconfig.*",
          "karma*",
          "lighthouserc.*",
          "playwright.config.*",
          "postcss.config.*",
          "puppeteer.config.*",
          "rspack.config.*",
          "svgo.config.*",
          "tailwind.config.*",
          "tsconfig.*",
          "tsdoc.*",
          "uno.config.*",
          "unocss.config.*",
          "vitest.config.*",
          "vuetify.config.*",
          "webpack.config.*",
          "windi.config.*",
        },
      },
      ["tex"] = {
        pattern = "^(.*)%.tex$",
        files = {
          "%1.acn",
          "%1.acr",
          "%1.alg",
          "%1.aux",
          "%1.bbl",
          "%1.blg",
          "%1.fdb_latexmk",
          "%1.fls",
          "%1.glg",
          "%1.glo",
          "%1.gls",
          "%1.idx",
          "%1.ind",
          "%1.ist",
          "%1.lof",
          "%1.log",
          "%1.lot",
          "%1.out",
          "%1.pdf",
          "%1.synctex.gz",
          "%1.toc",
          "%1.xdv",
        },
      },
      ["jsx"] = {
        pattern = "^(.*)%.jsx$",
        files = { "%1.js", "%1.*.jsx", "%1_*.js", "%1_*.jsx", "%1.less", "%1.module.less" },
      },
      ["ts"] = {
        pattern = "^(.*)%.ts",
        files = { "%1.js", "%1.d.ts.map", "%1.*.ts", "%1_*.js", "%1_*.ts" },
      },
      ["svg"] = { "svgz", "svg.br" }, -- configuration via extensions ist still possible
      ["css"] = { "css.map", "min.css" }, -- configuration via extensions ist still possible
      ["zsh"] = {
        pattern = "^(.*).zsh",
        files = { "%1.zsh.zwc" },
      },
    },
    commands = {
      system_open = function(state)
        vim.api.nvim_command(string.format("silent !xdg-open '%s'", state.tree:get_node():get_id()))
      end,
      trash = function(state)
        local inputs = require("neo-tree.ui.inputs")
        local path = state.tree:get_node().path
        local msg = "Are you sure you want to delete " .. path
        inputs.confirm(msg, function(confirmed)
          if not confirmed then
            return
          end
          vim.fn.system({ "trash-put", vim.fn.fnameescape(path) })
          require("neo-tree.sources.manager").refresh(state.name)
        end)
      end,
    },
    window = {
      position = "float",
      -- popup = { size = { width = "80%" } },
      auto_expand_width = false,
      mappings = {
        ["l"] = "open",
        ["s"] = "open_split",
        ["v"] = "open_vsplit",
        ["h"] = "close_node",
        ["a"] = { "add", config = { show_path = "relative" } },
        ["A"] = "add_directory",
        ["P"] = { "toggle_preview", config = { use_float = true, use_image_nvim = true } },
      },
    },
    filesystem = {
      window = {
        mappings = {
          ["/"] = "noop",
          ["f"] = "filter_on_submit",
          ["O"] = "system_open",
          ["D"] = "trash",
        },
      },
      bind_to_cwd = false,
      filtered_items = {
        hide_dotfiles = false,
        hide_gitignored = false,
        hide_by_name = {
          ".DS_Store",
          "thumbs.db",
        },
        hide_by_pattern = {
          "*.meta",
          "*:Zone.Identifier",
        },
        never_show = {
          ".DS_Store",
          "thumbs.db",
        },
      },
      find_by_full_path_words = true,
      follow_current_file = {
        enabled = true,
        leave_dirs_open = true,
      },
      hijack_netrw_behavior = "open_current",
      use_libuv_file_watcher = true,
    },
    document_symbols = {
      kinds = vim.tbl_map(function(value)
        return { icon = value }
      end, vim.g.personal_options.lsp_icons),
    },
    event_handlers = {
      {
        event = "file_opened",
        handler = function(_)
          require("neo-tree.sources.manager").close_all()
        end,
      },
      {
        event = "neo_tree_window_after_open",
        handler = function(args)
          if args.position == "left" or args.position == "right" then
            vim.cmd.wincmd("=")
          end
        end,
      },
      {
        event = "neo_tree_window_after_close",
        handler = function(args)
          if args.position == "left" or args.position == "right" then
            vim.cmd.wincmd("=")
          end
        end,
      },
    },
  },
}
