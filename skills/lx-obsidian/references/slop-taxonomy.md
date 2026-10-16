# The slop taxonomy (framework-neutral)

This is the spine. Every framework pack — `lx-flutter-tells`, `lx-web-tells`,
`lx-react-native-tells`, `lx-swiftui-tells`, `lx-compose-tells` — is an *instantiation* of this
file in one stack's idioms. The dimensions, the archetype tells, the severity language, and the
universal rule names are the same everywhere; only the signal code changes.

Why it matters: an agent that has internalized "avoid the indigo accent and Inter" gets a
*vifferent* generic when it moves to SwiftUI or Compose. The statistical center of gravity
changes with the framework. The shape of the failure does not.

## How to read a tell

Every tell in every pack has the same anatomy:

> **ID — title** `severity` `⚙ code-certain | 👁 rendered`
> **Signal** — the code that gives it away (in this stack's language)
> **Reads AI** — why a stranger reads it as machine-made
> **Fix** — the decision to make instead

- `⚙` **code-certain** — a machine finds it with no model call. The stack's detector flags it.
- `👁` **rendered / inferred** — needs the running app or a judgment call. Screenshot and look.
- **P0** a stranger notices in one glance · **P1** a designer notices · **P2** polish.

Tell IDs are `<PACK>-<DIM>-<nn>`: `FLS-CO-01` (Flutter → Color → #1), `WEB-TY-03`,
`SWS-SH-02`, `CMP-CM-04`. The `<DIM>` codes are shared across all packs:

| Code | Dimension | Code | Dimension |
|---|---|---|---|
| `ST` | Structure & layout | `MO` | Motion |
| `CO` | Color | `CP` | Copy |
| `TY` | Typography | `SD` | Second-order defaults |
| `SH` | Space, shape, elevation | `X` | Platform honesty |
| `CM` | Components & states | `CD` | Code that produces generic UI |

The pack prefixes: `FLS` Flutter · `WEB` Web (React/Next, Vue/Svelte, HTML/CSS) ·
`RNX` React Native · `SWS` SwiftUI · `CMP` Compose. `SD` and `CD` and `CP` are often *identical*
in spirit across stacks — that is the point; the taste failure is the same failure.

## Calibration (shared, read before flagging anything)

- **One instance is a choice; a pattern is a tell.** One gradient can be intentional. Every card
  having one is not.
- **Context redeems a tell.** Cream + terracotta is a tell *when it appears regardless of
  subject*; if the brief asked for it, it is a choice. The brief's words win.
- **A match is "look here", not "this is wrong".** The catalog is advisory; human judgment ships.
- **Three or more recognizable tells on one screen** → people assume a machine made it.
- **The strongest tell is not visual.** Copy that could sit on a competitor's app unchanged is the
  single biggest giveaway, and no repaint fixes it.

---

## A. Structure & layout (`ST`)

The composition, independent of styling.

- **A1 · Centered-by-default screen.** A whole surface is a centered stack because there is no
  hierarchy in the brief. *Good:* a real reading order and alignment derived from the contract.
- **A2 · Uniform grid of equal cells.** Identical tiles — same size, padding, icon box. *Good:*
  one asymmetry (a larger lead, a genuinely bigger tile).
- **A3 · Template section skeleton.** header → hero/stat row → 3 cards → testimonial trio → CTA
  banner, stamped regardless of product. *Good:* sections ordered and named for this product.
- **A4 · Dead regions.** A section whose removal changes nothing the user needs. *Good:* the
  filter rule — a region stays only if it helps the user understand or act.
- **A5 · Card-in-card nesting.** Excess containment used to look designed. *Good:* flatten; a
  container earns its border/division.
- **A6 · No adaptation at the structure level.** One layout at every window size. *Good:* branch
  per region (stay / stack / reorder / collapse / scroll / drawer / disappear).
- **A7 · Broken proximity.** Equal gaps everywhere, so grouping carries no meaning. *Good:* tighter
  spacing inside a group, whitespace between groups.

## B. Color (`CO`)

- **B1 · Framework default theme left in place.** The seed/accent the framework ships
  (`ColorScheme.fromSeed(deepPurple)`, Tailwind `indigo-600`, SwiftUI default `.blue`, M3 dynamic
  default). *Good:* a seed or palette from the subject's world, tuned by hand.
- **B2 · Framework color literals.** Named swatches for UI roles (`Colors.blue`, `red-500`,
  `Color.blue`, `Color.Red`). *Good:* every role resolves from a semantic token.
- **B3 · Raw hex/number in view code.** A literal color invented per widget. *Good:* one palette,
  referenced.
- **B4 · Accent used everywhere.** The brand color on buttons, icons, headings, borders, badges
  *and* backgrounds. *Good:* ≤ 2 visible accent uses per screen; the accent marks selection or the
  one primary action.
- **B5 · Two-stop "trust" gradient.** purple→blue / indigo→pink as a hero or text fill. *Good:*
  flatten to a surface + type, or keep one hue family with texture.
- **B6 · Neutrals unrelated to the palette.** Default greys with no hue relationship. *Good:*
  derive neutrals from the accent's hue at low chroma.
- **B7 · Low-contrast text.** Muted ink below WCAG AA on its surface. *Good:* verify every pair,
  both themes.
- **B8 · Unmotivated glow/elevation.** Shadow or glow with no light source or layering. *Good:*
  elevation means real stacking; one strong effect at most.
- **B9 · Dark mode by inversion.** Light theme with surfaces swapped; saturated accent on black.
  *Good:* design dark by hand — desaturate large areas, lift surfaces, re-check contrast.

## C. Typography (`TY`)

- **C1 · Untouched default type.** The framework's default face and scale, unmodified. *Good:*
  choose the family, set real scale contrast once.
- **C2 · Reflex "tasteful" font.** Inter / Roboto / Geist / Space Grotesk — the known generated
  faces; avoiding one defaults to the next. *Good:* a face nobody in the category uses, plus a
  plain workhorse, with a stated reason.
- **C3 · Weak hierarchy.** Three near-equal sizes for title/subtitle/body. *Good:* a genuinely
  large display and a readable body; the gap is the hierarchy.
- **C4 · Template type chrome.** ALL-CAPS tracked eyebrow above every heading; one accent word in
  a headline; mono for small labels "to look technical". *Good:* real headings and plain labels,
  used only where the device means something.
- **C5 · Unconsidered measure/leading.** Full-width body text; leading at the tight default.
  *Good:* 45–70 characters per line; leading 1.5–1.6.
- **C6 · Non-tabular figures.** Numbers that change or align in a proportional face. *Good:*
  tabular figures wherever values update or align.

## D. Space, shape, elevation (`SH`)

- **D1 · Magic-number spacing.** Ad-hoc `16`/`24`/`8` down the file. *Good:* one named scale (base
  4 or 8), referenced by role.
- **D2 · One radius everywhere.** Every surface the same corner radius. *Good:* a radius ladder
  (control / surface / pill) applied by role.
- **D3 · One soft shadow under everything.** The SaaS-card kit. *Good:* an elevation ladder, or no
  elevation (tonal + hairline borders).
- **D4 · Shadow on flat surfaces.** Elevation where nothing is raised. *Good:* flat content gets
  borders or tone.
- **D5 · Uniform padding by reflex.** The same padding on rows, cards, headers, sheets. *Good:*
  vary by role.
- **D6 · Oversized radius on small controls.** The "friendly AI startup" squircle. *Good:* radius
  matches element size.
- **D7 · No vertical rhythm.** Baselines and section gaps drift. *Good:* align to the scale.

## E. Components & states (`CM`)

- **E1 · Happy path only.** No loading / empty / no-results / error / disabled / denied states.
  *Good:* states are a first-class union/type, rendered in one frame.
- **E2 · Spinner-only loading.** A lone spinner that says nothing about what loads. *Good:*
  skeletons that preserve the final layout.
- **E3 · Identical feature cards.** Icon-in-a-rounded-box + bold title + two lines. *Good:* prose,
  a table, or genuinely differentiated cards.
- **E4 · Decorative containment.** An icon in a tinted rounded square, repeated. *Good:* the icon
  plainly, or drop it.
- **E5 · Emoji as icons.** Emoji standing in for an icon set. *Good:* a monoline icon set, or
  emoji only where the voice uses them.
- **E6 · Default chrome everywhere.** The stock bar/sheet/scaffold on every route. *Good:* a
  treatment chosen per surface and platform.
- **E7 · Stock CTA pair.** "Get Started" / "Learn More". *Good:* name the actual action; one
  primary per surface.

## F. Motion (`MO`)

- **F1 · Uniform entrance on everything.** Every element fades/slides identically. *Good:* one
  orchestrated load; nothing else auto-moves.
- **F2 · Linear / default curves.** Mechanical motion. *Good:* ease-out in, ease-in out, springs
  for drag; curves as tokens.
- **F3 · Content gated on scroll reveal.** Sections invisible until a listener fires. *Good:*
  content present by default; motion is not a gate.
- **F4 · No reduced-motion handling.** Motion ignores the accessibility setting. *Good:* honor
  reduce-motion; show final states.
- **F5 · One duration for everything.** No motion scale. *Good:* a small fast/base/slow scale.
- **F6 · Decoration motion.** Loops, blobs, parallax with no job. *Good:* motion shows a change,
  directs attention, or rewards an interaction.

## G. Copy (`CP`)

- **G1 · Filler / unfalsifiable copy.** "Lorem ipsum", "Item 1", "Get Started", "10× faster" with
  no source. *Good:* real nouns, numbers, dates.
- **G2 · Category slogans.** "Unlock", "Supercharge", "Seamless", "Elevate". *Good:* a claim only
  this product can make.
- **G3 · "It's not X, it's Y".** The reframe construction. *Good:* state the thing directly.
- **G4 · Runt fragments as device.** Stacked 3–6 word fragments. *Good:* fewer headlines, more
  prose.
- **G5 · Verb drift.** "Submit" → "Saved" → "Success!". *Good:* an action keeps its name through
  the flow; active voice.
- **G6 · Generic error/empty copy.** "Something went wrong." / "No data." *Good:* say what failed,
  what is safe, how to recover; empty states invite action.
- **G7 · Stock testimonials.** Three 5-star quotes, persona avatars, initial-only names. *Good:*
  real testimonials or none.

## H. Second-order defaults (the "tasteful" traps) (`SD`)

The escapes that became the new median. Legitimate for some briefs; tells when they appear
regardless of subject.

- **H1 · Cream + terracotta.** Warm neutral + high-contrast serif + clay accent.
- **H2 · Acid-on-black.** Near-black + one acid accent.
- **H3 · Broadsheet chrome.** Hairlines, zero radius everywhere, dense columns.
- **H4 · The SaaS-card kit.** Identical rounded cards, one shadow — see D2/D3.
- **H5 · Template micro-chrome.** Tracked eyebrow, middot meta, "→" on buttons, mono labels,
  tinted-near-black "for taste".
- **H6 · All-glass.** Frosted panels everywhere.
- **H7 · All-neubrutalism.** Hard borders, offset shadows, mono, uniformly.
- *Good:* each is a **choice** justified by the brief, applied where it means something, not a
  system-wide constant.

## I. Platform honesty (`X`)

Full treatment in `lx-cross-platform`. The universal archetypes:

- **I1 · Foreign platform.** A mobile-shaped layout parked in a browser tab, or desktop chrome on
  a phone. *Good:* the surface behaves like its host.
- **I2 · Missing pointer/keyboard states.** No hover/focus-visible/keyboard path on anything
  interactive. *Good:* every action reachable by pointer **and** keyboard; focus always visible.
- **I3 · No adaptive width.** One fixed width; overflow at the smallest size. *Good:* breakpoints
  and a per-region adaptation choice.
- **I4 · Navigation that ignores the host.** No URLs/back on web; a rail on a phone. *Good:* the
  host's navigation model, with the product's look.
- **I5 · Orientation lock.** Forcing one orientation. *Good:* support both unless truly impossible.
- **I6 · Host chrome ignored.** Hidden scrollbars, unselectable text, trapped back on web. *Good:*
  the browser's contract is intact.

## J. Code that produces generic UI (`CD`)

Structural smells that produce a generic result even when the styling is fine.

- **J1 · Raw visual values in view code.** Colors/sizes/radii/durations hardcoded in the render
  path. *Good:* a token layer the view reads.
- **J2 · No token layer.** A theme with a seed/palette and nothing else. *Good:* a token set +
  component themes.
- **J3 · Boolean state soup.** `isLoading; hasError;` tri-states. *Good:* a union/sealed state
  type that the compiler forces you to handle.
- **J4 · Duplicate components.** `ButtonNew`, `BetterCard`, a second primary button. *Good:* one
  canonical component per role; a named variant when the difference repeats and means something.
- **J5 · Strings inline in views.** Untranslatable copy scattered in the render path. *Good:*
  centralize copy; prepare for i18n/RTL.
- **J6 · Conditional theming in views.** `if (isDark) …` in the render path. *Good:* resolve from
  the theme; let it switch.
- **J7 · List/scroll anti-patterns.** Unvirtualized long lists, `shrinkWrap`-style nesting. *Good:*
  virtualized lists and proper scroll containers.

---

## The universal rule names (detectors)

Every stack's detector implements the **same snake_case rule names** for the `⚙` subset. This is
the reinforcement: one vocabulary across Dart, ESLint, Stylelint, SwiftLint, and detekt. A finding
in any stack reads the same, and CI gates are written the same way.

| Universal rule | Dimension · archetype | What it matches (conceptually) |
|---|---|---|
| `hardcoded_color` | B3 · raw color in view | a literal color in render code |
| `framework_color` | B2 · swatch literal | a named framework color used as a UI role |
| `default_theme` | B1 · default theme | the framework's stock seed/palette left in place |
| `hardcoded_spacing` | D1 · magic spacing | a numeric spacing literal in layout |
| `hardcoded_radius` | D2 · one radius | a numeric corner-radius literal |
| `hardcoded_font_size` | C1 · default type | a numeric font-size literal |
| `hardcoded_elevation` | D3/D4 · shadow | a numeric elevation/shadow literal |
| `hardcoded_duration` | F5 · one duration | a numeric animation-duration literal |
| `reflex_font` | C2 · reflex font | a known overused display face by name |
| `linear_motion` | F2 · linear/default curve | a linear or unset easing |
| `emoji_icon` | E5 · emoji as icon | an emoji-only string used as an icon |
| `orientation_lock` | I5 · orientation lock | code that forces one orientation |

Rule names are identical across stacks so suppression, baselines, and reporting are portable:
`// ignore: hardcoded_color` (Dart/JS) · `/* stylelint-disable-next-line lx-slop/hardcoded-color */`
(CSS) · `// swiftlint:disable:next lx_slop_hardcoded_color` (Swift) · `// detekt-suppress
LxSlopHardcodedColor` (Kotlin).

What no detector does: copy quality, layout tension, palette harmony, "soul", and everything
`👁`. The tool narrows the search; a person decides.
