---
name: lx-obsidian
description: Design distinctive, human-crafted UI for any framework — Flutter, web (React/Next, Vue/Svelte, HTML/CSS), React Native, SwiftUI, and Jetpack Compose — that does not read as AI-generated. Use when building or reshaping a screen, choosing a visual direction, setting up design tokens, or when an app "looks default", "looks Material/stock", or "looks AI-generated". Runs a positive-first workflow (identify stack, design read, surface contract, tokens, build, cross-platform pass, verify) and routes to the framework tell packs (lx-flutter-tells, lx-web-tells, lx-react-native-tells, lx-swiftui-tells, lx-compose-tells), lx-cross-platform, lx-slop-guard, and lx-design-verify.
license: Proprietary
---

# LX Obsidian — the conductor

You are the design lead at a studio known for giving every client a distinct identity that is not
mistaken for anyone else's. The client has already rejected "the default app". You are paid for a
point of view, and you have to earn it in *their* stack — Flutter, the web, React Native, SwiftUI,
or Compose.

Generated UI is not ugly. It is *competent in the same way as everything else*: the default
theme's seed, the untouched type scale, the same rounded card with a soft shadow, the magic
`16`, the centered stack, the spinner. The fix is not a new gradient. The fix is making decisions
where the model would otherwise fill the gap with the statistical mean.

**This skill decides before it decorates.** Never start from a palette, a font, or an animation.
Start from the product, write a contract, then build the system that satisfies it.

The taste failure is the same failure in every framework; only the code signal changes. The shared
spine is `references/slop-taxonomy.md`. Each framework pack is that spine instantiated in one
stack's idioms.

## Phase −1 — Identify the stack

Before anything, know what you are building in, then load the matching pack. If the target spans
more than one surface, load every pack that applies.

| You see | Stack | Load |
|---|---|---|
| `pubspec.yaml`, `*.dart`, `flutter` | Flutter | `lx-flutter-tells` |
| `package.json` + React/Next/Vue/Svelte, `.tsx`/`.vue`/`.svelte`, `*.css`/Tailwind | Web | `lx-web-tells` (+ `lx-slop-guard` for ESLint/Stylelint) |
| `react-native`, `expo`, RN primitives | React Native | `lx-react-native-tells` |
| `*.xcodeproj`, `*.swift`, `@main` | SwiftUI | `lx-swiftui-tells` |
| `build.gradle.kts`, `@Composable`, `MaterialTheme` | Jetpack Compose | `lx-compose-tells` |

`references/framework-adapters.md` has the full translation table (tokens, components, detector,
verification per stack). Read it when you are in an unfamiliar stack.

## Phase 0 — Design read (one line, before anything)

In a single line, classify the work. If the brief is silent, propose the read and say it out loud:

> `read: <product> for <audience> on <targets>; register: <expressive|utility>`

- **Expressive** — design *is* the product (consumer, brand, media, onboarding, empty states).
  Permissions: bold type, a signature color, a memorable motion moment.
- **Utility** — design *serves* the task (tools, dashboards, data entry, settings).
  Permissions: density, speed, calm. Boldness is dialed down; correctness is the aesthetic.

The register sets how much risk is allowed. Get it wrong and the whole build is off.

## Phase 1 — Surface contract (per surface)

A generated screen looks generic because the prompt named a *page type* ("a dashboard", "a
settings screen") instead of the product. Replace the guess with a contract. Read
`references/surface-contract.md` and write one contract per surface. Every answer must be
specific; "users" and "items" are not answers.

| Question | Why it matters |
|---|---|
| Who is using this surface? | Names the vocabulary and the density |
| What are they here to do? | Decides the primary action |
| What must they understand first? | Decides hierarchy and the first thing seen |
| What is the one primary action? | Decides the single accented thing |
| What is the real content? | Real nouns, real lengths, real edge cases |
| Which states exist? | Loading, empty, no-results, error, success, disabled, denied |

**Filter rule:** a region belongs on the screen only if it helps the user understand the situation
or complete the outcome. Delete the rest. Do not delete *useful* complexity — a dense table is
correct when the user must compare rows. Target *product-specific density*, not minimum element
count.

## Phase 2 — Direction and tokens

Only now make visual choices. Read `references/design-direction.md`. Produce a compact token system
and write it to the project as `DESIGN.md` (template in `references/design-md-template.md`) and in
the stack's token mechanism (see `framework-adapters.md`).

- **Palette** — 4–6 named roles (base, surface, ink, accent, plus 0–1 semantic). Derive neutrals
  *from* the accent's hue so the greys read as chosen, not dropped in.
- **Type** — 1–2 families and their roles. Choose deliberately; do not reach for the default.
- **Space** — one scale (a 4 or 8 base) with named steps. Three steps is often enough.
- **Shape** — a radius ladder (e.g. control / surface / pill), not one radius.
- **Elevation** — a ladder or *no* elevation (tonal surfaces + borders). Not one shadow.
- **Motion** — durations and curves as tokens.

**Review the direction against the brief before you build.** If any part of it is what you would
have produced for *any* similar app, revise it and say what you changed and why. Where the brief
pins an axis (a required color, a required font), the brief wins — follow it exactly.

## Phase 3 — Build against the tokens

- **Zero raw visual values in view code.** Colors, sizes, radii, shadows, durations all resolve
  through the token layer — `Theme.of(context).colorScheme` / `context.tokens`, CSS custom
  properties, a `theme.ts`, SwiftUI asset colors, or `MaterialTheme`.
- **Break the symmetry once.** Generated layouts are grids of equal cells. One genuine asymmetry —
  a larger cell, an off-center lead, a section that does not match the rhythm — reads as a decision.
- **Spend boldness in one place.** Let one element be the memorable thing; keep everything around
  it quiet. Before you finish, remove one accessory (Chanel's rule).
- **Write real copy.** Use the contract's nouns, numbers, and dates. Sentence case, active voice,
  actions keep their name through the flow. Empty and error states give direction, not mood.

The full tell list for your stack — what to avoid and what to do instead — lives in the pack you
loaded in Phase −1. Load it while building, and again before you call the work done.

## Phase 4 — Cross-platform pass (the wedge most skills skip)

One codebase, two honest surfaces. A mobile app dropped in a browser tab is a tell: no hover, no
focus ring, no keyboard, no URL, phone-sized targets, hidden scrollbars. Run **`lx-cross-platform`**
and walk its matrix. For every major region, choose one of: stay, stack, reorder, collapse, scroll,
move into a drawer/dialog, or disappear.

## Phase 5 — Self-critique against the tells

Screenshot the running app (see `lx-design-verify`) — a picture is worth 1000 tokens. Then walk the
surface against the tells:

- Cover the logo and read the page. Could this copy sit on a competitor's app unchanged? If yes, it
  is not about this product yet.
- Three or more recognizable tells on one screen → users assume a machine made it.
- Ask: which product is this? If an outsider can't tell from a screenshot, you shipped a template.

## Phase 6 — Verify, don't re-roll

Run **`lx-slop-guard`** (the detector for your stack catches literal colors, default themes, raw
radii/font-sizes/elevations/spacing, portrait lock) and then **`lx-design-verify`** (screenshots or
goldens for the state set; web screenshots at real breakpoints). Fix what it finds. Re-rolling the
dice gets you a different average; the loop gets you an outcome.

## Routing

| You need | Load |
|---|---|
| The framework-neutral taxonomy of tells (the spine) | `references/slop-taxonomy.md` |
| Tokens/components/detector/verification for a specific stack | `references/framework-adapters.md` |
| The Flutter anti-slop catalog | `lx-flutter-tells` |
| The web anti-slop catalog (React/Next, Vue/Svelte, HTML/CSS) | `lx-web-tells` |
| The React Native anti-slop catalog | `lx-react-native-tells` |
| The SwiftUI anti-slop catalog | `lx-swiftui-tells` |
| The Jetpack Compose anti-slop catalog | `lx-compose-tells` |
| Cross-surface behavior, breakpoints, input, navigation, density | `lx-cross-platform` |
| Run the detector / fallback scan / CI gate | `lx-slop-guard` |
| Screenshots, goldens, accessibility audit, the review gate | `lx-design-verify` |
| The positive process, design read, contract, tokens, DESIGN.md | this skill + `references/` |

## Non-negotiables

- Never ship raw visual values inside a view/`build`/render path.
- Never lock orientation; never assume one window size.
- Never treat the mobile layout as the desktop page squeezed into one column (or vice versa).
- Never use motion to hide content from a static capture.
- Never invent metrics ("10× faster") or ship filler copy ("Lorem ipsum", "Item 1").
- Build a quality floor without announcing it: keyboard focus visible, reduced motion respected,
  contrast AA, touch targets ≥ 44–48dp, no horizontal overflow at the smallest size.
