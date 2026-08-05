---
name: rust
description: Personal Rust conventions for error handling, panics, public API design, ad-hoc debugging, and testing. Read this BEFORE writing or editing any Rust code — when touching a `.rs` file, `Cargo.toml`, or `build.rs`, adding a dependency, designing a `pub` API, writing tests, or debugging a Rust build.
license: MIT
---

# Rust conventions

- Add dependencies with `cargo add`.
- In code using `eyre`/`anyhow` `Result`s, use `.context()` before every `?`. Messages are simple present tense, completing the sentence "while attempting to ...".
- Prefer `expect()` over `unwrap()`, with a concise message explaining why it cannot fail.
- For `pub` or crate-wide APIs, consult <https://rust-lang.github.io/api-guidelines/checklist.html>.
- For ad-hoc debugging, create a temporary example in `examples/`, run it with `cargo run --example <name>`, then remove it.

## Testing

- `quickcheck` for property-based tests when an obviously-correct comparison exists.
- `insta` for snapshot tests — run `cargo insta test` in place of `cargo test`.
- Use `compile_fail` doctests to verify code that should *not* compile (type-state patterns, trait-based enforcement). One error condition per test, since the result is only pass/fail — explain in the doctest exactly why it must fail. If there is no obvious item to hang it on, create a private `#[allow(dead_code)]` item and document that purpose.
