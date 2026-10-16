---
name: lx-swiftui-tells
description: The SwiftUI-native anti-"AI slop" tell catalog (~70 tells). Use when reviewing or writing SwiftUI (iOS/iPadOS/macOS/watchOS) and asking "why does this look AI-generated / like a default SwiftUI app / like an untouched Xcode preview", when choosing color, type, spacing, shape, motion, or component states in SwiftUI, or when you need the fix for a specific generated-looking pattern. Distinct from web and Flutter anti-slop lists because SwiftUI's default-look tells are different. Pairs with lx-obsidian (the process) and lx-slop-guard's SwiftLint config (the detector).
license: MIT
---

# The SwiftUI tell catalog

Web lists tell you to avoid Tailwind indigo and Inter; Flutter tells you to fear
`ColorScheme.fromSeed`. In SwiftUI the statistical center of gravity is its own thing: the
default `.blue` tint, untouched `.font(.body)` SF Pro, a `NavigationStack` with a `List` of
default rows, `Color.blue` / `.gray` / `.red` used as if they were UI roles, `.padding()`
with no value, `RoundedRectangle(cornerRadius: 12)` under every surface, `.shadow(radius: 4)`
on everything, and the `UIColor`-era habit of hardcoding colors instead of wiring an asset
catalog. This skill is the catalog: what reads generated in SwiftUI, the code signal that
gives it away, why it reads that way, and the fix.

The full list, with detection signals and Swift fixes, is in
**`references/tells-swiftui.md`**. Read it before you call UI work done; read the relevant
section while you work.

## How to read a tell

Each tell has: an **ID**, a **dimension**, a **detection signal** (the Swift that gives it
away), why it **reads AI**, and the **fix**. Two tags matter:

- **⚙ code-certain** — a machine can find it with no model call. The SwiftLint custom rules
  in `lint/swiftui/.swiftlint.yml` flag these.
- **👁 rendered / inferred** — needs the running app, a preview screenshot, or a judgment
  call. Screenshot and look.

Severity is ranked by **who notices**:

- **P0** — a stranger notices in one glance. Fix before shipping.
- **P1** — a designer notices. Should fix.
- **P2** — polish. Nice to fix.

## Calibration (read this before you flag anything)

- **One instance is a choice; a pattern is a tell.** One `.blue` button can be intentional.
  Every interactive element in system blue is not. Judge repetition and coherence, not
  isolated elements.
- **Context can redeem a tell.** Cream + terracotta is a tell *when it appears regardless of
  subject*; if the brief asked for it, it is a choice. The brief's own words win.
- **A match is "look here", not "this is wrong".** The catalog is advisory. Human judgment
  ships the work.
- **Three or more recognizable tells on one screen** → people assume a machine made it.
- **The strongest tell is not visual.** Copy that could sit on a competitor's app unchanged
  is the single biggest giveaway, and no amount of SwiftUI fixes it.

## The cardinal sins (P0)

1. **SWS-CO-01 Default system tint left in place.** `.tint(.blue)` (or nothing at all — the
   default *is* blue), `Color.blue` for buttons, links, icons, and headers. The iOS blue
   default is SwiftUI's indigo-seed moment.
2. **SWS-ST-01 The centered `VStack` screen.** A whole screen is
   `VStack { … }.frame(maxWidth: .infinity, maxHeight: .infinity)` with everything centered —
   the Xcode template's empty state stamped on real content.
3. **SWS-TY-01 Untouched system type.** No `.font` customization beyond `.body`/`.headline`
   defaults; hierarchy by default sizes alone; SF Pro exactly as it ships.
4. **SWS-SH-01 `cornerRadius: 12` + `shadow(radius: 4)` under everything.** The SaaS-card
   kit in Swift: every container is the same `RoundedRectangle(cornerRadius: 12)` with the
   same soft shadow.
5. **SWS-CM-01 Happy path only.** No `@State`-driven loading/empty/error/no-results states;
   the view assumes data is always present and the network is always up.
6. **SWS-CP-01 Filler / unfalsifiable copy.** "Lorem ipsum", "Item 1", "Get Started",
   "Learn More", "Seamless", "10× faster" with no source.
7. **SWS-X-01 iPhone-only fixed layout.** `.frame(width: 375)`-shaped thinking, no
   `horizontalSizeClass`, no `NavigationSplitView` — a phone layout parked on an iPad and a
   Mac.
8. **SWS-CD-01 Raw visual values in the view.** `Color(red: 0.1, green: 0.1, blue: 0.1)`,
   `.system(size: 17)`, `.padding(16)` inline in body code — no token layer, no asset
   catalog.

## The dimensions

| Dimension | Section | Example tells |
|---|---|---|
| Structure & layout | A | centered `VStack`, uniform `LazyVGrid`, template skeleton, nested `GroupBox` |
| Color | B | default `.blue` tint, `Color.gray` as a role, raw `Color(red:)`, purple→blue gradient |
| Typography | C | untouched `.font(.body)`, reflex fonts, fixed `.system(size:)`, Dynamic Type ignored |
| Space, shape, elevation | D | magic `.padding(16)`, one `cornerRadius`, `.shadow(radius:)` everywhere |
| Components & states | E | spinner-only loading, SF Symbol in a tinted rounded rect, default `List`/`TabView`, stock CTA pair |
| Motion | F | `.animation(.default)`, uniform entrance, no `accessibilityReduceMotion` |
| Copy | G | filler, slogan fragments, "Get Started" pairs |
| Second-order defaults | H | cream+terracotta, acid-on-black, all-`.ultraThinMaterial`, untouched form look |
| Platform honesty | I | no iPad/size-class adaptation, 44pt violations, no keyboard avoidance, missing VoiceOver labels |
| Code that produces generic UI | J | raw colors in views, no tokens, boolean state soup, inline strings |

## Audit protocol (scored 0–20)

Run this on a screen or the whole app. Score one point per violation, capped at 20; lower is
better.

1. **Build read** — state the register (expressive/utility) and the subject in one line.
2. **Copy test** — cover the app name. Could this copy be on a competitor's app? If yes, +3.
3. **Contract test** — does every region serve the user's job? Dead regions, +1 each (cap 3).
4. **Color** — default blue tint? accent used ≥3 visible times? raw `Color(red:)`? (+1 each)
5. **Type** — all system defaults? one-word accent? fixed sizes ignoring Dynamic Type? (+1 each)
6. **Space/shape/elevation** — magic padding? one radius? shadow on flat? (+1 each)
7. **States** — missing empty/error/no-results/disabled? (+1 each)
8. **Motion** — uniform `.onAppear` entrance? `.default` curve? reduce-motion ignored? (+1 each)
9. **Platform** — iPad/macOS unadapted? tap targets < 44pt? keyboard not avoided? (+1 each,
   cap 3)
10. **Detector** — run `swiftlint lint --config lint/swiftui/.swiftlint.yml`; each code-certain
    hit is +1.

Then report: the score, the P0s, and the three fixes with the highest leverage. Fixing
structure and copy beats repainting.

## What "soul" looks like

Aim for **~80% proven patterns + ~20% distinctive choice**. Put the 20% in exactly one place:

- one bold visual move (a type treatment, a single color decision, an unexpected proportion);
- voice and microcopy that only this product could write;
- one micro-interaction a user will remember (a spring, a haptic, a transition that means
  something);
- one detail only someone who used the product would add (a shortcut hint, a status badge in
  the product's own words).

The test: screenshot it. Can an outsider name the product? If not, you shipped a template —
a default SwiftUI app.

## Routing

- **Full catalog** → `references/tells-swiftui.md`.
- **Detector** → the `⚙` subset is implemented as SwiftLint custom rules in
  `lint/swiftui/.swiftlint.yml` (regex-based — SwiftLint exposes no third-party AST API, so
  these are heuristics; honest about it). Run:
  `swiftlint lint --config lint/swiftui/.swiftlint.yml`. Suppress an intentional hit with
  `// swiftlint:disable:next lx_slop_hardcoded_color` (or the relevant rule) and a reason.
- **Process** → `lx-obsidian`. **Cross-platform depth** → `lx-cross-platform`.
  **Rendered verification** → `lx-design-verify` (Xcode previews + snapshot tests).
