# Git

- Anything published — commit messages, PR bodies, issue comments, release notes — must appear in full in the approval prompt, because it is public once it lands. Pass it inline (`git commit -m "..."`, `gh pr create --body "..."`) or as `-m "$(cat <<'EOF' ... EOF)"`. Never `-F` or `--body-file`, never repeated `-m` flags.
- Use `git mv` for files already tracked.
- Use the `commit-writer` skill, if available.

# Shell

- The priority is builtin tools (read, write, MCP), then coreutils and other dedicated cli tools, then python scripting.
- Never `cd`. Commands run from the git root, so `git -C` is unnecessary too.
- All comamnds are executed relative to git root so no absolute path is required.
- Avoid variable expansion; it is usually blocked for lack of permission. Use it freely in long, complex commands — a human reviews those.
- Do not rely on python to replace code. Simply make your edit since a false-positive may occur (for example in docstrings).
- Run shell scripts through shellcheck.
- To test a CLI with ad-hoc input, write the input to a scratchpad file and pass it by path instead of piping from `cat`/`echo`/heredoc; this avoids permission prompts in sub-agents. Test input is throwaway and local; published content goes inline instead.
- Commands you want me to run go in one pasteable block:

      command1 \
      && command2

# Code style

- Comment only where the code is not straightforward, and then explain the *why* — business logic, design decisions, constraints — not the what.
- Keep comments, docstrings, and documentation short. Current state only; no history of what changed.
- Document intentionally omitted code the reader might expect to find.
- Add TODO comments for nuances deliberately deferred.
- Prefer clear inline code over decomposition that only organizes files, and over depending on shared utilities for straightforward logic. Functions should serve genuine reusability.
