-- Refer to https://github.com/Microsoft/vscode-eslint#settings-options for documentation.
return {
  validate = "on",
  packageManager = nil,
  useESLintClass = false,
  experimental = {
    useFlatConfig = false,
  },
  codeActionOnSave = {
    enable = true,
    mode = "all",
  },
  format = {
    enable = true,
  },
  quiet = false,
  onIgnoredFiles = "off",
  rulesCustomizations = {},
  run = "onType",
  problems = {
    shortenToSingleLine = false,
  },
  -- nodePath configures the directory in which the eslint server should start its node_modules resolution.
  -- This path is relative to the workspace folder (root dir) of the server instance.
  nodePath = "",
  -- use the workspace folder location or the file location (if no workspace folder is open) as the working directory
  workingDirectory = { mode = "location" },
  codeAction = {
    disableRuleComment = {
      enable = true,
      location = "separateLine",
    },
    showDocumentation = {
      enable = true,
    },
  },
}
