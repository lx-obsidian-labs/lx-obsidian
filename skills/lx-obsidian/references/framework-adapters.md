# Framework adapters

The process in `lx-obsidian` is stack-neutral. This file is the translation table: where each
stack keeps its tokens, components, detector, and verification, and the exact steps to run the
workflow on that stack. Load the pack for the stack you are in; this file tells you how the pack
plugs into the process.

## The stacks

| Stack | Pack (tells) | Language | Design tokens live in | Component system | Detector | Verify |
|---|---|---|---|---|---|---|
| **Flutter** (Android + Web) | `lx-flutter-tells` | Dart | `ThemeData` + an `AppTokens` `ThemeExtension` | `flutter/material` + `flutter/cupertino` | `packages/lx_slop_lint` (Dart analyzer plugin) | `flutter run`; goldens; `-d chrome` |
| **Web** (React/Next, Vue/Svelte, HTML/CSS) | `lx-web-tells` | TS/JS/CSS | CSS custom properties (`:root`) / a tokens JSON / the Tailwind theme | your component layer (Radix, shadcn, Svelte, hand-rolled) | `packages/eslint-plugin-lx-slop` + `packages/stylelint-lx-slop` | Playwright / Storybook screenshots at breakpoints |
| **React Native** (+ Expo, incl. web) | `lx-react-native-tells` | TS/TSX | a `theme.ts` token object exposed via context | RN core primitives + your components | `packages/eslint-plugin-lx-slop` | Expo web + device; screenshots |
| **SwiftUI** (iOS/iPadOS/macOS/watchOS) | `lx-swiftui-tells` | Swift | Asset catalog + `Color`/`Font` extensions + `Environment` | SwiftUI views | `lint/swiftui/.swiftlint.yml` (SwiftLint custom rules) | Xcode previews; snapshot tests |
| **Jetpack Compose** (Android) | `lx-compose-tells` | Kotlin | `MaterialTheme` + `CompositionLocal` token providers | Compose Material 3 + your components | `lint/compose/` detekt ruleset + config | `@Preview`s; Paparazzi/Roborazzi screenshots |

Every stack maps its tells onto the shared dimensions (`ST CO TY SH CM MO CP SD X CD`) and the
shared rule names in `slop-taxonomy.md`. The pack prefix distinguishes them (`FLS`, `WEB`, `RNX`,
`SWS`, `CMP`).

## How to run the workflow on any stack

The six phases are the same. Only step 0 and the artifact names change.

1. **Identify the stack** (Phase −1). Read `pubspec.yaml` / `package.json` / `*.xcodeproj` /
   `build.gradle.kts`. Load the matching pack from the table above — and `lx-web-tells` too if the
   target includes the web.
2. **Design read** — one line: product, audience, platforms, register. (No code.)
3. **Surface contract** — per surface: who, job, first thing seen, primary action, real content,
   states. Same template for every stack (`references/surface-contract.md`).
4. **Direction & tokens** — produce the neutral token spec (`design-md-template.md`) and then emit
   it in the stack's mechanism from the table above.
5. **Build against tokens** — the pack's `CD`/`J` section lists the stack's "raw values in the
   render path" smells.
6. **Cross-platform pass** (if multi-target) — `lx-cross-platform`.
7. **Detect + verify** — run the stack's detector from the table, then `lx-design-verify`.

## Tokens, per stack (the same roles, four mechanisms)

The neutral roles (see `design-md-template.md`): `base · surface · surfaceAlt · ink · inkMuted ·
accent · accentInk · <semantic>`, plus the type scale, space scale, radius ladder, elevation
ladder, and motion tokens.

**Flutter** — a `ThemeExtension` read via `context.tokens`:
```dart
Theme.of(context).extension<AppTokens>()!.spaceMd;
Theme.of(context).colorScheme.primary;
```

**Web / CSS** — custom properties on `:root`, consumed by everything:
```css
:root { --surface: #fbfaf7; --ink: #1b1a17; --accent: #b4472f; --space-md: 1rem; --radius-surface: 14px; }
.card { background: var(--surface); border-radius: var(--radius-surface); }
```
With Tailwind, map the same names into `tailwind.config` `theme.extend` so `bg-surface`,
`text-ink`, `rounded-surface`, `p-md` exist. **Never** `bg-indigo-600` or `#1b1a17` in JSX.

**React Native** — one typed token object:
```ts
export const tokens = { color: { surface:'#fbfaf7', ink:'#1b1a17', accent:'#b4472f' },
  space: { md: 16 }, radius: { surface: 14 }, motion: { base: 240 } } as const;
// <View style={{ backgroundColor: tokens.color.surface, borderRadius: tokens.radius.surface }} />
```

**SwiftUI** — Asset catalog colors + `Color`/`Font` extensions + `Environment`:
```swift
extension Color { static let surface = Color("Surface"); static let ink = Color("Ink") }
extension CGFloat { static let spaceMd: CGFloat = 16 }
Text("…").font(.body).foregroundStyle(.ink)
```

**Compose** — `MaterialTheme` extension + `CompositionLocal`:
```kotlin
val AppTokens = staticCompositionLocalOf { ... } // or extend MaterialTheme.colorScheme
MaterialTheme(colorScheme = AppScheme, typography = AppType) { … }
```

## Detectors, per stack

One real analyzer per stack, all implementing the universal rule names.

- **Flutter** → `packages/lx_slop_lint` (Dart `analysis_server_plugin`). See `lx-slop-guard`.
- **Web + React Native + Vue/Svelte** → `packages/eslint-plugin-lx-slop` (ESLint AST rules;
  runs on JS/TS/JSX/TSX, so it covers React, Next, Vue SFCs via `vue-eslint-parser`, Svelte via
  `svelte-eslint-parser`, and React Native).
- **CSS/SCSS** → `packages/stylelint-lx-slop` (Stylelint plugin rules; catches raw colors,
  spacing, radii, font-sizes in stylesheets).
- **SwiftUI** → `lint/swiftui/.swiftlint.yml` (SwiftLint custom rules; SwiftLint has no AST API
  for third parties, so these are regex rules — honest about their limits).
- **Compose** → `lint/compose/` (a detekt ruleset module + `detekt.yml`; detekt is Kotlin AST
  based).

Any stack without its detector installed: use `scripts/lx_scan.sh` as a best-effort pass, and lean
on the pack's `👁` catage and `lx-design-verify`.

## Verify, per stack

- **Flutter** — `flutter run` + Chrome; golden tests for widget states. See `lx-design-verify`.
- **Web** — Playwright (or Storybook + a snapshot addon) at 320·600·840·1200·1920; axe for a11y.
- **React Native** — Expo web + a device/emulator; screenshots of the state set.
- **SwiftUI** — Xcode previews for the state set + a snapshot-test library (swift-snapshot-testing).
- **Compose** — `@Preview` for the state set + Paparazzi/Roborazzi screenshot tests.

The verification *content* is identical everywhere: capture the state set, capture breakpoints,
audit contrast/focus/targets/text-scale/reduce-motion, then run the blind test.
