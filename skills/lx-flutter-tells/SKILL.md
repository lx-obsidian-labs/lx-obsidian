---
name: lx-flutter-tells
description: The Flutter-native anti-"AI slop" tell catalog (~75 tells). Use when reviewing or writing Dart UI and asking "why does this look AI-generated / generic / like default Material", when choosing colors, type, spacing, shape, elevation, motion, copy, or component states in Flutter, or when you need the fix for a specific generated-looking pattern. Distinct from web anti-slop lists because Flutter's default-look tells are different. Pairs with lx-obsidian (the process) and lx-slop-guard (the detector).
license: Proprietary
---

# The Flutter tell catalog

Web anti-slop lists tell you to avoid Tailwind indigo and Inter. In Flutter the tells are
different, and a few of them are *invisible on the web's radar*. This skill is the catalog:
what reads generated in Flutter, the code signal that gives it away, why it reads that way,
and the fix.

The full list, with detection signals and Dart fixes, is in
**`references/tells-flutter.md`**. Read it before you call UI work done; read the relevant
section while you work.

## How to read a tell

Each tell has: an **ID**, a **dimension**, a **detection signal** (the Dart that gives it
away), why it **reads AI**, and the **fix**. Two tags matter:

- **⚙ code-certain** — a machine can find it with no model call. `lx-slop-guard` flags these.
- **👁 rendered / inferred** — needs the running app or a judgment call. Screenshot and look.

Severity is ranked by **who notices**:

- **P0** — a stranger notices in one glance. Fix before shipping.
- **P1** — a designer notices. Should fix.
- **P2** — polish. Nice to fix.

## Calibration (read this before you flag anything)

- **One instance is a choice; a pattern is a tell.** One gradient can be intentional. Every
  card having a gradient is not. Judge repetition and coherence, not isolated elements.
- **Context can redeem a tell.** A cream + terracotta palette is a tell *when it appears
  regardless of subject*; if the brief asked for it, it is a choice. The brief's own words win.
- **A match is "look here", not "this is wrong".** The catalog is advisory. Human judgment
  ships the work.
- **Three or more recognizable tells on one screen** → people assume a machine made it.
- **The strongest tell is not visual.** Copy that could sit on a competitor's app unchanged
  is the single biggest giveaway, and no amount of CSS or Flutter fixes it.

## The seven cardinal sins (P0)

1. **FLS-CO-01 Default Material seed.** `ColorScheme.fromSeed(seedColor: Colors.deepPurple)`
   or a `ThemeData` with no `colorScheme` → the M3 purple baseline. Indigo/violet is the
   statistical center of AI color taste.
2. **FLS-ST-01 The centered column screen.** A whole screen is
   `Center(child: Column(mainAxisAlignment: center, …))`.
3. **FLS-SH-01 One soft shadow + one radius under every surface.** The SaaS-card kit in Dart:
   every `Card`/container is `elevation: 4`, `borderRadius: 12`, same grey shadow.
4. **FLS-TY-01 Untouched `TextTheme`.** No `textTheme:` in `ThemeData`, default Roboto at
   default sizes, hierarchy by size alone.
5. **FLS-CM-02 Happy path only.** No loading/empty/error states; just `Center(CircularProgressIndicator())`
   and then content.
6. **FLS-CP-01 Filler / unfalsifiable copy.** "Lorem ipsum", "Item 1", "Get Started",
   "Unlock", "Seamless", "10× faster" with no source.
7. **FLS-X-01 Material-everywhere on web.** The default `AppBar`/`NavigationBar`, no hover,
   no focus ring, no keyboard, no URL — a phone app in a browser tab.

## The dimensions

| Dimension | Section | Example tells |
|---|---|---|
| Structure & layout | A | centered column, uniform grid, nested cards |
| Color | B | default seed, `Colors.blue`, accent everywhere, gradient wash |
| Typography | C | Roboto default, accent one word, ALL-CAPS kickers |
| Space, shape, elevation | D | magic `16`s, one radius, shadow on everything |
| Components & states | E | FAB-for-everything, spinner-only loading, no empty state |
| Motion | F | uniform fade-up on every element, linear curves, no reduced-motion |
| Copy | G | filler, slogan fragments, "Get Started" pairs |
| Second-order defaults | H | cream+terracotta, acid-on-black, all-glass, "tasteful" chrome |
| Cross-platform | I | summary — full matrix in `lx-cross-platform` |
| Code that produces generic UI | J | sealed-state missing, no tokens, hardcoded values |

## Audit protocol (scored 0–20)

Run this on a screen or the whole app. Score one point per violation, capped at 20; lower is
better.

1. **Build read** — state the register (expressive/utility) and the subject in one line.
2. **Copy test** — cover the logo. Could this copy be on a competitor's app? If yes, +3.
3. **Contract test** — does every region serve the user's job? Dead regions, +1 each (cap 3).
4. **Color** — default seed? accent used ≥3 visible times? raw literals? (+1 each)
5. **Type** — default family? one-word accent? sizes within 2px of each other? (+1 each)
6. **Space/shape/elevation** — ad-hoc spacing? one radius everywhere? shadow on flat? (+1 each)
7. **States** — missing empty/error/no-results/disabled? (+1 each)
8. **Motion** — uniform entrance on all sections? linear? no reduced-motion? (+1 each)
9. **Cross-platform** — run `lx-cross-platform` and add its findings (cap 3).
10. **Analyzer** — run `lx-slop-guard`; each code-certain hit is +1.

Then report: the score, the P0s, and the three fixes with the highest leverage. Fixing
structure and copy beats repainting.

## What "soul" looks like

Aim for **~80% proven patterns + ~20% distinctive choice**. Put the 20% in exactly one place:

- one bold visual move (a type treatment, a single color decision, an unexpected proportion);
- voice and microcopy that only this product could write;
- one micro-interaction a user will remember;
- one detail only someone who used the product would add (a keyboard hint, a status badge in
  the product's own words).

The test: screenshot it. Can an outsider name the product? If not, you shipped a template.
