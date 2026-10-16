# Design Direction

Contents
1. The problem: distributional convergence
2. The two orders of default (and why "tasteful" is still a tell)
3. Palette
4. Typography
5. Space, shape, elevation
6. Motion
7. Layout and composition
8. The plan → review step (do this before you build)
9. Sources

---

## 1. The problem: distributional convergence

A generative model asked for "a clean modern app" samples from the high-probability center of
its training data. That center is not ugly; it is *median*. Every model trained on the same
corpus drifts to the same house style, so the output looks like everything else — and generic
reads as machine-made. Escaping it is not about skill; it is about **supplying the decisions
the model would otherwise average over.** Constraints are what convert raw capability into a
designed result. Write them down before generating.

## 2. The two orders of default

There are two layers of tell, and the second is the trap for anyone who has read an anti-slop
list.

**First order — the median.** The purple/indigo accent, the two-stop gradient, the untouched
component library, the identical feature cards, the centered hero. Avoid these; everyone knows
them.

**Second order — the "tasteful escape" that became the new median.** As soon as the field
learned to avoid indigo, it converged again. In Flutter (and the web it borrows from), watch:

- Warm cream background (#F4F1EA-ish) + high-contrast serif + terracotta/clay accent
  (#D97757-ish). This is Anthropic's own interaction accent, so it now reads as a tell.
- Near-black background + a single acid-green or vermilion accent.
- Broadsheet chrome: hairline rules, zero radius everywhere, dense columns.
- The SaaS-card kit: identical rounded cards, one radius regardless of hierarchy, the same
  soft `rgba(0,0,0,.1)` shadow under each.
- Template chrome regardless of subject: a tracked ALL-CAPS eyebrow above every heading;
  meta joined with middots ("A · B · C"); "WORD — fragment" labels; tinted near-black
  (#0B0B0B) standing in for black; mono for small labels; "→" appended to buttons.
- All-glass (`BackdropFilter` everywhere), all-neubrutalism, one "Space Grotesk" reflex,
  "I used M3 Expressive so it's fine".

All of these are legitimate for *some* briefs. They are tells when they appear **regardless
of subject** — i.e. when they are the default rather than a choice. Where the brief pins an
axis, the brief wins. Where an axis is free, do not spend that freedom on one of these.

## 3. Palette

Pick **one neutral family** (warm paper-and-ink, cool zinc, or true black) and **one or two
accents used on purpose**. 4–6 named roles is plenty:

- `base` (page), `surface` (raised), `surfaceAlt` (subtle), `ink` (primary text),
  `inkMuted`, `accent`, and optionally one semantic.

Rules that do the work:
- **Derive the neutrals from the accent's hue.** A few degrees of chroma in the greys makes
  them read as chosen. Pure `#808080` greys are the default.
- **One accent, used on purpose.** A color used everywhere is used nowhere. Cap the accent at
  roughly two *visible* uses per screen. Selection, not decoration.
- **Contrast is not optional.** Body text ≥ 4.5:1, large text ≥ 3:1, on every surface and in
  every state, in both light and dark. Verify pairs; don't eyeball (see `lx-design-verify`).
- **Gradients, if used, stay in one hue family** and carry a little noise so they don't band.
  Give light a source — a horizon, a lit edge, a focused element — never a blob behind text.

## 4. Typography

Typography carries the personality. You need **one family or two** — and if two, make them
clearly distinct (a display face and a workhorse, not two similar sans).

- **Choose deliberately.** Reject the reflex faces: Inter, Roboto, Geist, Space Grotesk,
  system default. A face nobody in your category uses does more than any effect.
- **Set a real scale with contrast.** Hierarchy comes from *difference*. Three sizes that are
  nearly the same create mush. Let display be large and tight (tracking ≈ −0.02 to −0.04em at
  display sizes; leading 1.0–1.1), body comfortable (1.5–1.6), lines 45–70 characters.
- **Do not accent a single word** in a headline (one italic/bold/colored word) — a top tell.
- **Use tabular figures** (`FontFeature.tabularFigures()`) for anything that changes or aligns.
- **Respect text scaling.** Test at 130–200%. Layouts must not clip; never set absolute
  heights on text containers without an overflow plan.

In Flutter: set the family and scale once in `TextTheme`; refuse to set `fontSize:` inside a
widget (the analyzer in `lx-slop-guard` flags it). Adjust a component's text at the *component
theme* level, not by editing the global theme for one widget.

## 5. Space, shape, elevation

- **Space** — one scale, one base (4 or 8). Name the steps. Everything aligns to a step. The
  tell is a field of `16`s and `8`s chosen ad hoc; the fix is a scale you can name.
- **Shape** — a *ladder*, not a single radius. A control radius, a surface radius, a pill.
  Using one radius everywhere collapses hierarchy; a radius used with intent communicates the
  component family.
- **Elevation** — a ladder, or none. On dark and on modern light UIs, tonal surfaces plus
  hairline borders usually beat drop shadows. Reserve the strongest shadow for real layering.
  The tell: one soft shadow under every card because cards "should" have a shadow.

## 6. Motion

Motion is for one of three jobs: **show a change of state, direct attention, or reward an
interaction.** If it does none, cut it.

- **Answer the input within a frame.** Buttons press to ~0.97 and spring back; selection
  indicators glide instead of jumping; swapped content cross-fades with a few px of travel.
- **One orchestrated moment beats scattered effects.** A single page-load sequence lands;
  a fade-and-slide-up on every section is the generic default.
- **Ease deliberately.** Ease-out curves for entrances (200–700 ms), springs for anything
  draggable. Avoid linear and elastic/bounce for UI affordances.
- **Respect `MediaQuery.disableAnimationsOf(context)` / reduce-motion.** In Flutter,
  `AnimationController` reduces duration automatically when animations are disabled *unless*
  you set `AnimationBehavior.preserve`. Honor it; show final states.
- **Never gate content on scroll/entrance animation.** If every section is invisible until
  scrolled, the static capture is blank. Content must be present.

## 7. Layout and composition

- **Build structure, then decoration.** Header, primary action, the controls that change the
  main content, the main content, secondary info, feedback. Only then color and shadow.
- **One genuine asymmetry.** Prefer one irregular cell, an off-center lead, or a section that
  breaks the rhythm. Perfectly even grids read as generated.
- **Whitespace is deliberate, not empty.** Alternating density (one tight section, one
  breathing section) reads as intentional; uniform medium spacing reads as default.
- **Do not hide behind containers.** Excessive nested cards ("card-in-card") are a tell.
  A container is justified only when it separates regions that need a visible boundary.

## 8. The plan → review step (do this before you build)

Write a compact plan, then *attack it*:

1. Write the token system (palette, type, space, shape, elevation, motion) and a one-line
   layout concept. Use ASCII wireframes to compare two or three layout ideas before committing.
2. **Review the plan against the brief.** For each part, ask: "Is this what I would produce for
   *any* app in this category?" Work through a generic prompt mentally; if you arrive somewhere
   similar, that part is a default — revise it, and *say what you changed and why*.
3. Only then write code, following the revised plan.

Record what you tried (a notes file) so a later pass can do something different rather than
landing in the same default twice.

## 9. Sources

- Anthropic, `frontend-design` skill — the plan/review process and the five current AI design
  clusters (this document maps clusters 4–5 to Flutter).
- Anthropic, "Improving frontend design through Skills" — distributional convergence.
- InterfaceKit, "How to make UI not look AI-generated" — the page contract; structure before
  decoration.
- Design for AI (yaps), Tundra AI Labs, `design-antislop`, `avoid-ai-design` — tell catalogs
  and the second-order-defaults warning.
- Material 3 (m3.material.io) + Flutter adaptive docs — tokens, breakpoints, adaptive layout.
