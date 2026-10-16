# LX Obsidian

**UI taste for coding agents — so what they build looks commissioned, not generated.**

Most anti-slop tooling fights the web's tells: the indigo accent, Inter, the three-card grid,
untouched shadcn. That advice doesn't transfer. Every stack has its own statistical center of
gravity — Flutter's default purple `ColorScheme.fromSeed`, the untouched `TextTheme`, the same
`Card` with `elevation: 4`; Tailwind's stock palette and `rounded-lg`; React Native's Material
defaults on iOS; SwiftUI's stock `.accentColor`; Compose's `dynamicColorScheme()` and
`CardDefaults.cardElevation()`. Ship one of them to a second surface and the defaults get louder:
a phone app in a browser tab, Material gestures on iOS, a desktop app with 48dp phone targets.

LX Obsidian is a set of Agent Skills (Claude Code / `SKILL.md`) that replace those defaults with
decisions — positive-first, framework-idiomatic, and honest about how each platform differs.

## Scope

| Surface | Framework pack | Detector |
|---|---|---|
| Flutter (Android/iOS/web/desktop) | `lx-flutter-tells` | `packages/lx_slop_lint` (Dart analyzer plugin) |
| Web (React/Next, Vue, Svelte, HTML/CSS) | `lx-web-tells` | `packages/eslint-plugin-lx-slop` + `packages/stylelint-lx-slop` |
| React Native / Expo (iOS/Android/web) | `lx-react-native-tells` | `packages/eslint-plugin-lx-slop` |
| SwiftUI (iPhone/iPad/Mac/visionOS) | `lx-swiftui-tells` | `lint/swiftui/.swiftlint.yml` |
| Jetpack Compose (phone/tablet/foldable/desktop) | `lx-compose-tells` | `lint/compose/detekt.yml` |

A framework-agnostic **core** (`lx-obsidian`) holds the universal taxonomy, process, and adapters;
each pack instantiates it. All detectors speak the **same universal rule names** (`hardcoded_color`,
`framework_color`, `default_theme`, `hardcoded_spacing`, `hardcoded_radius`, `hardcoded_font_size`,
`hardcoded_elevation`, `hardcoded_duration`, `reflex_font`, `linear_motion`, `emoji_icon`,
`orientation_lock`), so findings and CI gates read the same everywhere.

## What makes it different

| Axis | Web anti-slop<br>(`avoid-ai-design`, `design-antislop`) | Single-framework skills | **LX Obsidian** |
|---|---|---|---|
| Tell catalog | Web-shaped (Tailwind, shadcn, Inter) | One framework | **5 framework packs + one universal taxonomy** |
| Cross-surface | n/a | mentioned, not a system | **First-class adaptation ladder** — width/modality first, OS second |
| Detection | Regex (`detect.mjs`) | `grep` shell script | **Real analyzers per stack** (Dart plugin, ESLint, Stylelint, SwiftLint, detekt) + a no-toolchain fallback |
| Process | Audit → rewrite | Interview → audit | **Positive-first**: design read → surface contract → tokens → build → cross-platform → verify |
| Verification | Screenshots | Golden tests | **Rendered proof at real breakpoints** (goldens/screenshots) |

The four wedges: **native tells per stack**, **cross-surface honesty**, **real static analysis**,
and **deciding before you decorate**.

## Install

**Claude Code (plugin marketplace)**

```bash
/plugin marketplace add lx-obsidian/lx-obsidian
/plugin install lx-obsidian
/reload-plugins
```

**Any agent that reads `SKILL.md`** (Cursor, Codex, VS Code Copilot, opencode, …)

```bash
git clone https://github.com/lx-obsidian/lx-obsidian.git ~/.agents/skills/lx-obsidian
# Claude Code also reads:
git clone https://github.com/lx-obsidian/lx-obsidian.git ~/.claude/skills/lx-obsidian
```

For a single project, clone into `.agents/skills/` or `.claude/skills/` at the repo root.

## The skills

| Skill | Job | Reach for it when |
|---|---|---|
| `lx-obsidian` | Conductor: universal taxonomy, positive-first workflow, routing, adapters | Any UI work; "make this not look generated" |
| `lx-flutter-tells` | Flutter-native anti-slop catalog (~75 tells) | Reviewing or writing Dart UI |
| `lx-web-tells` | Web catalog (~65 tells) for React/Next/Vue/Svelte/HTML/CSS | Reviewing or writing web UI |
| `lx-react-native-tells` | RN/Expo catalog (~55 tells) across iOS/Android/web | Reviewing or writing RN UI |
| `lx-swiftui-tells` | SwiftUI catalog (~70 tells) for Apple platforms | Reviewing or writing SwiftUI |
| `lx-compose-tells` | Compose catalog (~65 tells) for Android/desktop | Reviewing or writing Compose |
| `lx-cross-platform` | The width/modality adaptation ladder across all stacks | One codebase, many surfaces |
| `lx-slop-guard` | Runs the per-stack detectors + fallback scan; CI gate | Before shipping; wiring a hook; auditing a repo |
| `lx-design-verify` | Rendered proof at real breakpoints; review gate | Proving the UI, not vibing it |

## The workflow (the conductor)

1. **Identify the stack** and load the matching framework pack (Phase −1).
2. **Design read** — one line: product, audience, platforms, register (expressive vs utility).
3. **Surface contract** — per surface: who, job, first thing seen, primary action, real content, states.
4. **Direction & tokens** — palette roles, type roles, spacing scale, radius/elevation ladder, motion tokens → `DESIGN.md` + the stack's token primitive.
5. **Build against tokens** — no raw visual values in view code.
6. **Cross-platform pass** — run `lx-cross-platform`; make each surface native.
7. **Verify** — run `lx-slop-guard`, then `lx-design-verify`. Fix, don't re-roll.

## The detectors

One real analyzer per stack, plus a dependency-free fallback:

```bash
# Flutter/Dart — single file (folder mode misses plugin diagnostics; see package README)
dart analyze lib/screens/home.dart

# Web / React Native
npx eslint .            # packages/eslint-plugin-lx-slop

# CSS/SCSS
npx stylelint "**/*.css"  # packages/stylelint-lx-slop

# SwiftUI
swiftlint lint --config lint/swiftui/.swiftlint.yml

# Compose
detekt --config lint/compose/detekt.yml

# No toolchain? best-effort regex pass:
pwsh scripts/lx_scan.ps1 -Path lib        # Dart
bash scripts/lx_scan.sh lib
```

## Repo layout

```
skills/
  lx-obsidian/            SKILL.md + references/ (taxonomy, adapters, DESIGN.md template, surface contract)
  lx-flutter-tells/       SKILL.md + references/tells-flutter.md
  lx-web-tells/           SKILL.md + references/tells-web.md
  lx-react-native-tells/  SKILL.md + references/tells-react-native.md
  lx-swiftui-tells/       SKILL.md + references/tells-swiftui.md
  lx-compose-tells/       SKILL.md + references/tells-compose.md
  lx-cross-platform/      SKILL.md + references/cross-platform-matrix.md
  lx-slop-guard/          SKILL.md + references/rules.md
  lx-design-verify/       SKILL.md + references/verification-playbook.md
packages/
  lx_slop_lint/            Dart analyzer plugin (10 rules)
  eslint-plugin-lx-slop/   ESLint plugin (12 rules)
  stylelint-lx-slop/       Stylelint plugin
lint/
  swiftui/                 SwiftLint custom config
  compose/                 detekt config + ruleset guidance
scripts/                   lx_scan.sh, lx_scan.ps1 (fallback)
```

## Design philosophy

- **Decide, don't decorate.** A pattern in its stock form reads generated; the same pattern with
  a reason behind it reads crafted. The skill forces a reason before the first pixel.
- **80/20.** Use proven patterns, then spend one bold move. Burn the boldness in one place.
- **Native to each surface.** "Works everywhere" is not the bar. *Designed* is.
- **The tells rot.** Every match is "look here", never "this is wrong". Human judgment ships.

## License

Proprietary — All Rights Reserved. Copyright © 2026 LX Obsidian. See [LICENSE](LICENSE).
