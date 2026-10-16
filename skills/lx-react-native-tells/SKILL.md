---
name: lx-react-native-tells
description: The React Native (Expo, including React Native Web) anti-"AI slop" tell catalog (RNX, ~55 tells). Use when reviewing or writing RN/Expo UI and asking "why does this look AI-generated / like a default Expo starter / like a stock React Native app", when choosing color, type, spacing, shape, motion, or component states in RN/TSX, or when you need the React Native-specific fix for a generated-looking pattern. Distinct from web and Flutter anti-slop lists because React Native's default-look tells are different. Pairs with lx-obsidian (the process) and lx-slop-guard (the ESLint detector).
license: MIT
---

# The React Native tell catalog

Web anti-slop lists warn you about Tailwind indigo and Inter; Flutter tells you to fear
`ColorScheme.fromSeed`. React Native has its own statistical center of gravity, and most of it
is invisible on web lists' radar: the untouched Expo starter (`app/(tabs)` with two default
tabs and a counter), `StyleSheet.create` full of raw hex and magic numbers, screens that are a
`flex: 1` + `justifyContent: 'center'` stack, the stock React Navigation header on every route,
a bottom tab bar wrapped around every feature, `Platform.OS` branches doing the job width
should do, and an unvirtualized `ScrollView` with a `.map` over the data. This skill is the
catalog: what reads generated in React Native, the code signal that gives it away, why it
reads that way, and the fix.

The full list, with detection signals and TSX fixes, is in
**`references/tells-react-native.md`**. Read it before you call UI work done; read the relevant
section while you work.

## How to read a tell

Each tell has: an **ID**, a **dimension**, a **detection signal** (the RN/TSX that gives it
away), why it **reads AI**, and the **fix**. Two tags matter:

- **⚙ code-certain** — a machine can find it with no model call. `lx-slop-guard`'s ESLint
  plugin flags these.
- **👁 rendered / inferred** — needs the running app (Expo web, a device/simulator) or a
  judgment call. Screenshot and look.

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
  is the single biggest giveaway, and no amount of styling or token work fixes it.

## The cardinal sins (P0)

1. **RNX-CO-01 Raw hex, no token layer.** `backgroundColor: '#0B0B12'`, `color: '#fff'`
   inside `StyleSheet.create` — a palette invented per screen, `#fff`/`#000` as the base
   surface/ink pair, nothing to switch on.
2. **RNX-ST-01 The centered `flex: 1` screen.** A whole screen is
   `<View style={{ flex: 1, justifyContent: 'center', alignItems: 'center' }}>`.
3. **RNX-SH-03 One shadow kit under every surface.** `shadowColor` + `shadowOpacity` +
   `shadowRadius` + `shadowOffset` *and* `elevation` copied onto every card, row, and button —
   the SaaS-card kit in RN.
4. **RNX-TY-01 Untouched system type at hardcoded sizes.** No `fontFamily` anywhere (SF Pro /
   Roboto exactly as they ship), hierarchy by weight alone, `fontSize: 15` literals in the
   stylesheet.
5. **RNX-CM-01 Happy path only.** No empty/loading/error/disabled states — data renders, or it
   doesn't, and nothing explains which.
6. **RNX-CD-03 Unvirtualized `ScrollView` + `.map`.** The whole list rendered at once, memory
   and jank included, when `FlatList` exists.
7. **RNX-X-01 / RNX-ST-05 Platform-shaped layout.** `Platform.OS` branches deciding layout
   instead of width, and on RN Web a phone-shaped column in a browser tab with no hover,
   focus, or keyboard path.
8. **RNX-CP-01 Filler / unfalsifiable copy.** "Lorem ipsum", "Item 1", "Get Started",
   "Seamless", "10× faster" with no source.

## The dimensions

| Dimension | Section | Example tells |
|---|---|---|
| Structure & layout | A | centered `flex:1` screen, uniform `.map` cards, no `useWindowDimensions`, missing insets |
| Color | B | raw hex in `StyleSheet`, accent everywhere, purple→pink `LinearGradient`, dark-by-inversion |
| Typography | C | untouched system font, reflex Google font, hardcoded `fontSize`, `allowFontScaling={false}` |
| Space, shape, elevation | D | magic spacing, one `borderRadius`, one shadow kit, uniform padding |
| Components & states | E | spinner-only loading, emoji icons, default nav header, bottom-tabs-for-everything, stateless `Pressable` |
| Motion | F | default/linear `Animated.timing`, `LayoutAnimation` on every mount, scroll-gated content, reduce-motion ignored |
| Copy | G | filler, slogan fragments, "Get Started" pairs, `Alert.alert('Error', …)` |
| Second-order defaults | H | cream+terracotta, acid-on-black, all-`expo-blur`, neubrutalism, untouched Expo template |
| Platform honesty | I | no web surface on RN Web, tabs on a wide window, <44pt targets, portrait lock, keyboard not avoided |
| Code that produces generic UI | J | raw values in `StyleSheet`, no theme, `ScrollView`+`.map`, boolean state soup, `Dimensions.get` |

## Audit protocol (scored 0–20)

Run this on a screen or the whole app. Score one point per violation, capped at 20; lower is
better.

1. **Build read** — state the register (expressive/utility) and the subject in one line.
2. **Copy test** — cover the app name. Could this copy be on a competitor's app? If yes, +3.
3. **Contract test** — does every region serve the user's job? Dead regions, +1 each (cap 3).
4. **Color** — raw hex in styles? accent used ≥3 visible times? purple→pink gradient? (+1 each)
5. **Type** — system font untouched? hardcoded `fontSize`? one-word accent? (+1 each)
6. **Space/shape/elevation** — magic spacing? one radius? shadow kit on everything? (+1 each)
7. **States** — missing empty/error/no-results/disabled? spinner-only loading? (+1 each)
8. **Motion** — uniform entrance on every element? default/linear curve? reduce-motion ignored?
   (+1 each)
9. **Platform** — run `lx-cross-platform` and add its findings (cap 3).
10. **Detector** — run `lx-slop-guard` (the ESLint plugin); each code-certain hit is +1.

Then report: the score, the P0s, and the three fixes with the highest leverage. Fixing
structure and copy beats repainting.

## What "soul" looks like

Aim for **~80% proven patterns + ~20% distinctive choice**. Put the 20% in exactly one place:

- one bold visual move (a type treatment, a single color decision, an unexpected proportion);
- voice and microcopy that only this product could write;
- one micro-interaction a user will remember (a spring, a haptic, a transition that means
  something);
- one detail only someone who used the product would add (a keyboard hint, a status badge in
  the product's own words).

The test: screenshot it on a device. Can an outsider name the product? If not, you shipped a
template — a default Expo starter.

## Routing

- **Full catalog** → `references/tells-react-native.md`.
- **Detector** → the `⚙` subset is implemented by `packages/eslint-plugin-lx-slop`, an ESLint
  AST plugin over JS/TS/JSX/TSX — which covers React Native, Expo, and React Native Web — using
  the universal rule names from `slop-taxonomy.md` (`hardcoded_color`, `hardcoded_spacing`,
  `hardcoded_radius`, `hardcoded_font_size`, `hardcoded_elevation`, `hardcoded_duration`,
  `reflex_font`, `linear_motion`, `emoji_icon`, `orientation_lock`, …). Suppress an intentional
  hit with `// eslint-disable-next-line lx-slop/hardcoded-color -- reason`.
- **Process** → `lx-obsidian`. **Cross-platform depth** → `lx-cross-platform` (window classes,
  the per-region adaptation menu, navigation per host). **Rendered verification** →
  `lx-design-verify` (Expo web + device, screenshots of the state set).
