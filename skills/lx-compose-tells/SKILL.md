---
name: lx-compose-tells
description: The Jetpack Compose (Kotlin/Android) anti-"AI slop" tell catalog (~65 tells). Use when reviewing or writing Compose UI and asking "why does this look AI-generated / like a default Material 3 app / like the Android Studio New Project template", when choosing colors, type, spacing, shape, elevation, motion, or component states in Compose, or when you need the Kotlin fix for a specific generated-looking pattern (default MaterialTheme, dynamicColor treated as a design, 16.dp everywhere, RoundedCornerShape(8.dp) on everything, Color(0xFF...) literals). Distinct from the Flutter and web packs because Compose's default-look tells are different. Pairs with lx-obsidian (the process) and the detekt ruleset in lint/compose/.
license: Proprietary
---

# The Jetpack Compose tell catalog

Anti-slop lists trained on the web tell you to avoid Tailwind indigo and Inter. In Compose the
statistical center of gravity is different and a few tells are invisible on their radar: a
`MaterialTheme` wrapping a generated/default `lightColorScheme`, dynamic color treated as a
design decision, an untouched `MaterialTheme.typography`, `Scaffold` + default `TopAppBar`
chrome on every screen, `16.dp` everywhere, one `RoundedCornerShape(8.dp)` on every surface,
`Color(0xFF…)` literals invented per composable, and `MaterialTheme.colorScheme.primary`
painted on buttons, icons, headings, borders and badges at once. This skill is the catalog:
what reads generated in Compose, the Kotlin that gives it away, why it reads that way, and
the fix.

The full list, with detection signals and Kotlin fixes, is in
**`references/tells-compose.md`**. Read it before you call UI work done; read the relevant
section while you work.

## How to read a tell

Each tell has: an **ID**, a **dimension**, a **detection signal** (the Kotlin that gives it
away), why it **reads AI**, and the **fix**. Two tags matter:

- **⚙ code-certain** — a machine can find it with no model call. The detekt ruleset in
  `lint/compose/` flags these.
- **👁 rendered / inferred** — needs the running app or a judgment call. Screenshot and look.

Severity is ranked by **who notices**:

- **P0** — a stranger notices in one glance. Fix before shipping.
- **P1** — a designer notices. Should fix.
- **P2** — polish. Nice to fix.

## Calibration (read this before you flag anything)

- **One instance is a choice; a pattern is a tell.** One `drawBehind` gradient can be
  intentional. Every `Card` having one is not. Judge repetition and coherence, not isolated
  composables.
- **Context can redeem a tell.** Cream + terracotta is a tell *when it appears regardless of
  subject*; if the brief asked for it, it is a choice. The brief's own words win.
- **`@Preview` and design-time scaffolding are not the product.** A demo composable full of
  literals is fine; the same literals in the render path are the tell.
- **A match is "look here", not "this is wrong".** The catalog is advisory. Human judgment
  ships the work.
- **Three or more recognizable tells on one screen** → people assume a machine made it.
- **The strongest tell is not visual.** Copy that could sit on a competitor's app unchanged
  is the single biggest giveaway, and no amount of Compose fixes it.

## The cardinal sins (P0)

1. **CMP-CO-01 Default MaterialTheme / dynamic color as the design.**
   `MaterialTheme(colorScheme = dynamicColorScheme(LocalContext.current))` or a
   `lightColorScheme(primary = Purple40)` straight from the New Project template. The M3
   baseline is the starting point, not a palette.
2. **CMP-ST-01 The centered column screen.** A whole screen is
   `Column(Modifier.fillMaxSize(), horizontalAlignment = Alignment.CenterHorizontally, verticalArrangement = Arrangement.Center)`.
3. **CMP-SH-01 The SaaS-card kit.** Every surface: `RoundedCornerShape(8.dp)`,
   `elevation = 4.dp` (or `shadow(4.dp)`), `16.dp` padding — one radius, one shadow, one gap.
4. **CMP-TY-01 Untouched `MaterialTheme.typography`.** No `typography =` argument; default
   Roboto at default sizes, hierarchy by size alone.
5. **CMP-CM-01 Happy path only.** No loading/empty/error/disabled states; just
   `CircularProgressIndicator()` centered, then content.
6. **CMP-CP-01 Filler / unfalsifiable copy.** "Lorem ipsum", "Item 1", "Get Started",
   "Seamless", "10× faster" with no source — `stringResource` or not.
7. **CMP-X-01 + CMP-X-04 The phone-only fixed app.** One layout at every window size (no
   `WindowSizeClass`), plus a locked orientation in the manifest.

## The dimensions

| Dimension | Section | Example tells |
|---|---|---|
| Structure & layout | A | centered column, uniform `LazyVerticalGrid`, nested `Card`s, no `WindowSizeClass` |
| Color | B | default theme, `Color(0xFF…)` literals, `Color.Blue` roles, accent everywhere, gradient wash |
| Typography | C | untouched `MaterialTheme.typography`, reflex font, weak hierarchy, `fontSize = 18.sp` |
| Space, shape, elevation | D | magic `16.dp`, one `RoundedCornerShape(8.dp)`, `elevation = 4.dp` on everything |
| Components & states | E | happy path only, spinner-only loading, emoji icons, default `TopAppBar`/`Scaffold` chrome |
| Motion | F | default `animate*AsState` specs, `AnimatedVisibility` on everything, scroll-gated alpha |
| Copy | G | filler, slogans, "Get Started" pairs, "Something went wrong." |
| Second-order defaults | H | cream+terracotta, acid-on-black, all-`Modifier.blur` glass, stock M3 "seed" look |
| Cross-platform | I | phone-only fixed layout, tiny targets, orientation lock, no `imePadding`, no semantics |
| Code that produces generic UI | J | raw values in composables, no token layer, boolean state soup, missing list `key`s |

## Audit protocol (scored 0–20)

Run this on a screen or the whole app. Score one point per violation, capped at 20; lower is
better.

1. **Build read** — state the register and the subject in one line.
2. **Copy test** — cover the logo. Could this copy be on a competitor's app? If yes, +3.
3. **Contract test** — does every region serve the user's job? Dead regions, +1 each (cap 3).
4. **Color** — default/dynamic scheme? accent used ≥3 visible times? raw literals? (+1 each)
5. **Type** — default type? one-word accent? sizes within 2sp of each other? (+1 each)
6. **Space/shape/elevation** — ad-hoc `dp` literals? one radius everywhere? shadow on flat? (+1 each)
7. **States** — missing empty/error/no-results/disabled? (+1 each)
8. **Motion** — uniform entrance on all sections? linear/default specs? no reduce-motion? (+1 each)
9. **Platform** — one window size only? locked orientation? missing semantics/`imePadding`? (+1 each)
10. **Detector** — run detekt with `lint/compose/detekt.yml`; each `⚙` hit is +1.

Then report: the score, the P0s, and the three fixes with the highest leverage. Fixing
structure and copy beats repainting.

## What "soul" looks like

Aim for **~80% proven patterns + ~20% distinctive choice**. In Compose the 20% lives in:

- one bold visual move (a type treatment, a single color decision, an unexpected proportion)
  wired through real tokens — `MaterialTheme.colorScheme` roles you authored, or a
  `CompositionLocal` token provider, never literals in composables;
- voice and microcopy that only this product could write;
- one micro-interaction a user will remember (a spring that means something, a haptic that
  answers a real event);
- one detail only someone who used the product would add (a keyboard hint, a status row in
  the product's own words).

The test: screenshot the `@Preview`/Paparazzi capture. Can an outsider name the product? If
not, you shipped the Android Studio template.

## Detection

The `⚙` subset is implemented for Compose as a **detekt** ruleset + config in
`lint/compose/` (detekt is Kotlin AST based), using the universal rule names from
`lx-obsidian`'s `slop-taxonomy.md` (`hardcoded_color`, `default_theme`, `hardcoded_spacing`,
…). Honest status: the provided `detekt.yml` enables the relevant built-in rules today and
documents the custom rules; the custom rules require building the ruleset jar — see
`lint/compose/README.md`. The regex fallback is `scripts/lx_scan.sh`. For everything `👁`,
use `lx-design-verify` and eyes.
