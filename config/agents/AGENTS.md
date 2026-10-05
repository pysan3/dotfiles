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

# HTTP requests

- `curl` and `wget` are denied; never retry them. `node` and `gh api … -f` prompt every time.
- Ad-hoc request: httpie, allowed as `http *`. The whole request stays visible in the command line; a body larger than a few fields goes in a scratchpad file passed as `@file`:

      http --ignore-stdin --body POST https://host/path key=value

- A request that needs logic around it: a Python `urllib.request` script in the scratchpad, run with `python <path>`. It needs no prompt either.

# Code style

- Comment only where the code is not straightforward, and then explain the *why* — business logic, design decisions, constraints — not the what.
- Keep comments, docstrings, and documentation short. Current state only; no history of what changed.
- Document intentionally omitted code the reader might expect to find.
- Add TODO comments for nuances deliberately deferred.
- Prefer clear inline code over decomposition that only organizes files, and over depending on shared utilities for straightforward logic. Functions should serve genuine reusability.
- Validate where data enters, never where it is used. A check you find yourself adding in the middle of a function is evidence the door let it through unchecked — fix the door, and the check has one home by construction. This is the main way the same few lines end up in two files: neither looked like a candidate for extraction, because both were two lines inside something bigger.
- Some shapes are rules wearing local clothes: a `try`/`except` around a parse, an `isinstance` guard, a refusal with a literal message, a constant tuple of enum members. When you type one, grep for it before finishing the line — you are probably writing something's second copy.
- Before writing a check, a refusal, a conversion or a constant you can state as one English sentence, grep for that sentence. The same rule in two files is one rule with two homes, and they drift. Identical error-message strings in two modules are proof, and the fastest thing to grep for.
- When you do find the second copy, ask **which layer owns the rule**, not whether to extract a helper — the second question has no good answer at four lines, the first always does. If another layer owns it, call it and react to its refusal rather than predicting it. If both sides genuinely need it, put it where the shared shapes already live. If it has one caller and no owner, leave it inline; a helper with one caller is a name to maintain. Extracting a shared helper is the answer least often right: it makes the duplicate tidy while leaving it in the wrong place, and it can preserve the bug the duplication was hiding.
- Fix the second copy, not the third. Rule-of-three is for shapes; a *rule* is a divergence risk the moment it exists twice.
- A test double reimplementing what it fakes is the exception that has to exist — and it needs a contract test running the same scenarios against the double and the real thing, or it drifts and hides the bug it was standing in for.
