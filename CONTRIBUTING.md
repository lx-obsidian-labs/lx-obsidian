# Contributing to LX Obsidian

Thanks for helping make agent-built UI look commissioned instead of generated.
This project is **proprietary** (see [LICENSE](LICENSE)); contributions are
accepted under the terms in [CONTRIBUTING-LICENSE](#contribution-license) below.

## Ground rules

- **Positive-first.** Every tell comes with the better pattern, not just a ban.
- **One universal vocabulary.** Detectors use the canonical rule names in
  `skills/lx-obsidian/references/slop-taxonomy.md`. Never invent a parallel name.
- **Honest about divergence.** If a pattern is correct on one platform and wrong
  on another, say so and cite the platform guidance.
- **Low false positives.** A detector must be *code-certain*. If a human would
  reasonably ship it, it is not a finding.

## Ways to contribute

| I want to… | Edit |
|---|---|
| Add or sharpen a tell | the matching `skills/lx-*-tells/references/tells-*.md` |
| Change the shared taxonomy/process | `skills/lx-obsidian/**` |
| Add a machine check | the matching package under `packages/` or config under `lint/` |
| Fix cross-surface guidance | `skills/lx-cross-platform/**` |
| Improve the pre-ship gate | `skills/lx-design-verify/**` |

## Adding a tell

1. Find the existing section in the pack's `tells-*.md`.
2. Follow the shape used everywhere:
   **What it looks like · Why it reads generated · Fix · Severity (`P0`/`P1`/`P2`)**.
3. Add the fix, not just the smell. Show the token/pattern that replaces it.
4. If it is machine-detectable, add a detector rule (below) and cross-link it.
5. Keep the pack's tell count in the SKILL frontmatter accurate.

## Adding a detector rule

1. Use the canonical rule name. Rule-id casing per stack:
   - Dart: `snake_case`
   - ESLint / Stylelint: `lx-slop/kebab-case`
   - SwiftLint: `lx_slop_snake_case`
   - detekt: `LxSlopCamelCase`
2. Register it in the plugin entry point and export it from the public surface.
3. Add a focused test with a minimal, self-contained snippet.
4. Confirm the rule only fires on the tell, not on the token-based fix.
5. Update the package `README.md` rules table.

## Testing

Run everything the CI runs, from the repo root:

```powershell
# Dart analyzer plugin
dart test packages/lx_slop_lint
dart analyze packages/lx_slop_lint/lib

# JS / CSS plugins
npm --prefix packages/eslint-plugin-lx-slop test
npm --prefix packages/stylelint-lx-slop test

# Config sanity
python -c "import yaml; yaml.safe_load(open('lint/swiftui/.swiftlint.yml'))"
python -c "import yaml; yaml.safe_load(open('lint/compose/detekt.yml'))"
```

A change is ready when tests pass, `dart analyze` is clean, and no new detector
fires on the token-based "good" example.

## Commit style

Short imperative subject, optional body. Reference the tell/rule id when useful:

```
Add hardcoded_duration detector rule

Catches magic-number Duration(...) values; FLS-MO-03.
```

## Contribution license

By submitting a contribution you agree it becomes the property of LX Obsidian
and is licensed under the project's proprietary terms. Do not submit code you
cannot license this way.
