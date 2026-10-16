---
name: lx-web-tells
description: The web-native anti-"AI slop" tell catalog (~65 tells) for React, Next.js, Vue, Svelte, and plain HTML/CSS (including Tailwind and CSS-in-JS). Use when reviewing or writing web UI and asking "why does this look AI-generated / like untouched shadcn / like a Vercel template", when choosing colors, type, spacing, shape, motion, copy, or component states on the web, or when you need the fix for a specific generated-looking pattern (indigo accent, Inter, the 3-card hero→features→testimonials→CTA template, from-purple-500 to-pink-500). Distinct from lx-flutter-tells because web's default-look tells are different. Pairs with lx-obsidian (the process) and lx-slop-guard (the detectors).
license: Proprietary
---

# The web tell catalog

The classic anti-slop advice — avoid Tailwind indigo and Inter — is already half-stale. A model
told to avoid them reaches for Space Grotesk and cream + terracotta; a model told nothing
ships the untouched shadcn/Radix defaults under a centered hero and a 3-card feature grid.
This skill is the web catalog: what reads generated in React/Next/Vue/Svelte/HTML+CSS, the
code signal that gives it away, why it reads that way, and the fix.

The full list, with detection signals and web fixes, is in
**`references/tells-web.md`**. Read it before you call UI work done; read the relevant
section while you work.

## How to read a tell

Each tell has: an **ID**, a **dimension**, a **detection signal** (the JSX/CSS/Tailwind that
gives it away), why it **reads AI**, and the **fix**. Two tags matter:

- **⚙ code-certain** — a machine can find it with no model call. `lx-slop-guard` flags these
  (the ESLint + Stylelint plugins).
- **👁 rendered / inferred** — needs the rendered page or a judgment call. Screenshot and look.

Severity is ranked by **who notices**:

- **P0** — a stranger notices in one glance. Fix before shipping.
- **P1** — a designer notices. Should fix.
- **P2** — polish. Nice to fix.

## Calibration (read this before you flag anything)

- **One instance is a choice; a pattern is a tell.** One `from-purple-500 to-pink-500`
  button can be intentional. Every gradient on the page is not. Judge repetition and
  coherence, not isolated elements.
- **Context can redeem a tell.** An untouched shadcn theme is a tell *when it appears
  regardless of brief*; if the brief said "shadcn defaults, ship Friday", it is a choice.
  The brief's own words win.
- **A match is "look here", not "this is wrong".** The catalog is advisory. Human judgment
  ships the work.
- **Three or more recognizable tells on one screen** → people assume a machine made it.
- **The strongest tell is not visual.** Copy that could sit on a competitor's site unchanged
  — "Get Started", "Unlock", "Seamless", "10× faster" — is the single biggest giveaway, and
  no amount of CSS fixes it.

## The cardinal sins (P0)

1. **WEB-CO-01 The indigo/violet default accent.** `bg-indigo-600`, `text-violet-600`, or
   `bg-blue-600` as the primary action — the statistical center of AI color taste on the web.
2. **WEB-CO-03 The purple→pink wash.** `bg-gradient-to-r from-purple-500 to-pink-500` on the
   hero, the buttons, and one `bg-clip-text` headline word.
3. **WEB-TY-01 Inter, untouched.** `font-family: Inter` with no stated reason — the default
   face of generated web UI.
4. **WEB-ST-01/02 The centered hero + 3-card grid.** A `min-h-[80vh] flex items-center
   justify-center` hero over `grid md:grid-cols-3` of identical icon-box cards — the landing
   template skeleton stamped regardless of product.
5. **WEB-CM-06 Untouched shadcn/Radix.** Stock components at stock density with the stock
   `--primary` indigo and stock `--radius` — a fresh scaffold wearing a logo.
6. **WEB-CM-01 Happy path only.** No loading/empty/error/disabled states; the fetch is
   assumed to have succeeded.
7. **WEB-MO-01 Scroll-triggered fade-up on everything.** `whileInView` / `IntersectionObserver`
   on every section, card, and list item.
8. **WEB-CP-01 Filler copy.** "Lorem ipsum", "Acme Inc", "Get Started", "Seamless",
   "10× faster" with no source.

## The dimensions

| Dimension | Section | Example tells |
|---|---|---|
| Structure & layout | A | centered hero, 3-card grid, landing skeleton, dead sections |
| Color | B | indigo/violet default, raw hex in JSX, purple→pink wash, accent everywhere |
| Typography | C | Inter default, Space Grotesk reflex, gradient one-word headline |
| Space, shape, elevation | D | `rounded-lg shadow-md p-4` everywhere, `p-[17px]`, one radius |
| Components & states | E | happy path only, untouched shadcn, emoji icons, hero badge pill |
| Motion | F | fade-up on everything, `opacity-0` gates, no reduced-motion |
| Copy | G | filler, slogans, "It's not X, it's Y", stock testimonials |
| Second-order defaults | H | the shadcn/Vercel template look, cream+terracotta, all-glass |
| Cross-platform | I | fixed width, tiny tap targets, hover-only, div onClick |
| Code that produces generic UI | J | inline styles, no tokens, arbitrary values, boolean state soup |

## Audit protocol (scored 0–20)

Run this on a page or a component screen. Score one point per violation, capped at 20; lower
is better.

1. **Build read** — state the register (expressive/utility) and the subject in one line.
2. **Copy test** — cover the logo and brand name. Could this copy be on a competitor's site?
   If yes, +3.
3. **Contract test** — does every region serve the user's job? Dead sections, +1 each (cap 3).
4. **Color** — indigo/violet/blue default accent? accent used ≥3 visible times? raw hex or
   arbitrary colors? (+1 each)
5. **Type** — Inter/Space Grotesk/Geist with no reason? gradient one-word headline? sizes
   within 2px of each other? (+1 each)
6. **Space/shape/elevation** — arbitrary px values? one radius everywhere? shadow on flat
   surfaces? (+1 each)
7. **States** — missing empty/error/no-results/disabled? (+1 each)
8. **Motion** — fade-up on everything? linear/default easing? content gated at `opacity-0`?
   no reduced-motion? (+1 each, cap 3)
9. **Cross-platform** — run `lx-cross-platform` and add its findings (cap 3).
10. **Detectors** — run `lx-slop-guard` (ESLint + Stylelint plugins); each code-certain hit
    is +1.

Then report: the score, the P0s, and the three fixes with the highest leverage. Fixing
structure and copy beats repainting.

## What "soul" looks like

Aim for **~80% proven patterns + ~20% distinctive choice**. Put the 20% in exactly one place:

- one bold visual move (a type treatment, a single color decision, an unexpected proportion);
- voice and microcopy that only this product could write;
- one micro-interaction a user will remember (a keyboard shortcut hint, a status badge in the
  product's own words, a state transition that feels physical);
- one detail only someone who used the product would add.

The test: screenshot it. Can an outsider name the product? If not, you shipped a template.

Routing: the `⚙` subset is implemented by `lx-slop-guard` (`packages/eslint-plugin-lx-slop`
for JS/TS/JSX/TSX/Vue/Svelte, `packages/stylelint-lx-slop` for CSS/SCSS). Mobile-web,
breakpoints, and responsive behavior get the full treatment in `lx-cross-platform`.
