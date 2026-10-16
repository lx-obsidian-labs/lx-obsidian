---
name: lx-slop-guard
description: Detect the code-certain "AI slop" tells automatically across stacks — Dart/Flutter (analyzer plugin), JS/TS/JSX/TSX/React/Vue/Svelte/RN (ESLint plugin), CSS/SCSS (Stylelint plugin), SwiftUI (SwiftLint config), and Compose (detekt config). Use when you want to lint rather than review by eye, when wiring detectors into CI, when interpreting findings, or when asking "which of these are machine-detectable". Complements the framework tell packs and lx-obsidian (the process).
license: Proprietary
---

# Slop guard

The universal tell catalog maps to `⚙ code-certain` (machine-finds) and `👁 rendered` (needs
eyes). This skill is the machine side: detectors per stack, all using the **same universal rule
names** (`hardcoded_color`, `framework_color`, `default_theme`, `hardcoded_spacing`,
`hardcoded_radius`, `hardcoded_font_size`, `hardcoded_elevation`, `hardcoded_duration`,
`reflex_font`, `linear_motion`, `emoji_icon`, `orientation_lock`) from `slop-taxonomy.md`.

## What it can and cannot do

**Can (no model needed):** hardcoded colors/spacing/radii/font-sizes/elevations/durations,
framework/default theme, reflex fonts, emoji-as-icon, linear motion curves, orientation lock,
missing hover/focus on web custom controls.

**Cannot:** copy quality, layout tension, palette harmony, whether the design has *soul*, and
anything requiring the rendered result. For those, use the relevant framework pack and
`lx-design-verify`.

A finding is a **"look here"**, not a verdict. Suppress intentional ones with the stack's
ignore/comment syntax and a short reason.

## One real analyzer per stack

| Stack | Detector | Notes |
|---|---|---|
| Flutter/Dart | `packages/lx_slop_lint` (Dart analyzer plugin) | Loaded by analysis server/IDE. `dart analyze <file>` reports them; `dart analyze <folder>` misses due to an SDK bug ([dart-lang/sdk#62710]). `flutter analyze` may not surface plugin diagnostics ([flutter/flutter#187999]). |
| Web (React/Next, Vue/Svelte, HTML/CSS) + React Native/Expo | `packages/eslint-plugin-lx-slop` (ESLint plugin) | AST-based, runs on JS/TS/JSX/TSX (covers RN/RN Web). Pair with `packages/stylelint-lx-slop` for CSS/SCSS. |
| CSS/SCSS | `packages/stylelint-lx-slop` (Stylelint plugin) | Catches hardcoded colors/spacing/radii/font-sizes in stylesheets. |
| SwiftUI | `lint/swiftui/.swiftlint.yml` (SwiftLint custom rules) | Regex-based (SwiftLint has no AST API for custom rules); heuristic but real. |
| Jetpack Compose (Kotlin) | `lint/compose/detekt.yml` + `lint/compose/ruleset/` (detekt) | Kotlin AST-based where the custom ruleset is built; use the provided config and the scanner fallback if building the jar is impractical. |

All share the same universal rule names. See `references/rules.md` for the full mapping.

## Option 1 — Flutter (Dart analyzer plugin)

Requires **Dart 3.10+**. In the app project:
```yaml
# pubspec.yaml (dev_dependencies)
dev_dependencies:
  lx_slop_lint:
    path: <path-to>/packages/lx_slop_lint
```
```yaml
# analysis_options.yaml
plugins:
  lx_slop_lint:
    path: <path-to>/packages/lx_slop_lint
```

Run:
```powershell
dart analyze lib/screens/home.dart  # prefer single file (folder mode is buggy)
```

Suppress: `// ignore: hardcoded_color`.

## Option 2 — Web/RN (ESLint)

Install and configure `eslint-plugin-lx-slop` in the consuming project (flat config):
```js
import lxSlop from "eslint-plugin-lx-slop";
export default [ { plugins: { "lx-slop": lxSlop }, rules: { "lx-slop/hardcoded-color": "error" } } ];
```
Runs on JS/TS/JSX/TSX (React, Next, Vue via vue-eslint-parser, Svelte via svelte-eslint-parser,
React Native/RN Web).

## Option 3 — CSS/SCSS (Stylelint)

Install `stylelint-lx-slop` and add to `stylelint.config.js`:
```js
export default { plugins: ["stylelint-lx-slop"], rules: { "lx-slop/hardcoded-color": true } };
```

## Option 4 — SwiftUI (SwiftLint)

Point SwiftLint to the provided config:
```bash
swiftlint lint --config lint/swiftui/.swiftlint.yml
```
Suppress: `// swiftlint:disable:next lx_slop_hardcoded_color`.

## Option 5 — Compose (detekt)

Use the detekt config: `detekt --config lint/compose/detekt.yml`. If the custom ruleset jar is
not built, rely on the regex fallback in the scanner or the built-in subset. See
`lint/compose/README.md`.

## Option 6 — Fallback scanner (dependency-free)

If no detector is installed, run the generic scanner:
```powershell
pwsh scripts/lx_scan.ps1 -Path lib -MinSeverity P1
bash scripts/lx_scan.sh lib P0
```
It greps the `⚙` signals and honors `// ignore:`. No analyzer needed; advisory.

## CI guidance

Fail PRs when code-certain severity ≥ P1 findings increase. Keep a committed baseline so
existing debt doesn't block; block regressions only. Prefer fixing the root (introduce tokens,
replace the default theme, add states) over silencing hits.

## Rule index

See `references/rules.md` for every universal rule, what it matches (per-stack), fix, and how
to suppress it. All detectors implement the same universal names.
