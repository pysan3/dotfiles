---
name: commit-writer
description: 'Execute git commit with conventional commit message analysis, intelligent staging, and message generation. Use when user asks to commit changes, create a git commit, or mentions "/commit". Supports: (1) Auto-detecting type and scope from changes, (2) Generating conventional commit messages from diff, (3) Interactive commit with optional type/scope/description overrides, (4) Intelligent file staging for logical grouping'
license: MIT
allowed-tools: Bash
---

# Git Commit with Conventional Commits

## Format

```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

| Type       | Purpose                        |
| ---------- | ------------------------------ |
| `feat`     | New feature                    |
| `fix`      | Bug fix                        |
| `docs`     | Documentation only             |
| `style`    | Formatting/style (no logic)    |
| `refactor` | Code refactor (no feature/fix) |
| `perf`     | Performance improvement        |
| `test`     | Add/update tests               |
| `build`    | Build system/dependencies      |
| `ci`       | CI/config changes              |
| `chore`    | Maintenance/misc               |
| `revert`   | Revert commit                  |

Breaking changes take a `!` after the type/scope (`feat!: remove
deprecated endpoint`) or a `BREAKING CHANGE:` footer.

## Workflow

1. Read the diff — `git diff --staged` if anything is staged, otherwise `git diff`, plus `git status --porcelain`.
2. Stage what belongs in one logical commit (`git add <paths>`, `git add -p`). **Never commit secrets** (`.env`, credentials, private keys).
3. Derive type, scope, and a one-line description from the diff.
4. Commit with a single `-m`:

```bash
git commit -m "feat(parser): accept trailing commas in config

Explain why the change was made and any non-obvious trade-offs
in the design or implementation.

Refs #123"
```

A `-m "$(cat <<'EOF' ... EOF)"` heredoc works too. Never `-F` or `--body-file`, never repeated `-m` flags.

## Message rules

- Subject: imperative present tense ("add", not "added"), no trailing period, under 50 chars (72 hard limit). It should complete "If applied, this commit will ...". Capitalizing the description after the type prefix is your call.
- Blank line between subject and body. Hard-wrap the body at 72 chars — `git log` indents without reflowing.
- The body explains what and why, not how — the diff already shows how.
- Types and short snippets in backticks; a full line or more of code in an indented block.
- Reference issues in the footer: `Closes #123`, `Refs #456`.
- One logical change per commit.

## Safety

- NEVER update git config.
- NEVER run destructive commands (`--force`, hard reset) without an explicit request.
- NEVER skip hooks (`--no-verify`) unless asked.
- NEVER force push to main/master.
- If a commit fails due to hooks, fix the issue and create a NEW commit rather than amending.
