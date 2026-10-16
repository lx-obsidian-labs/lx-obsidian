# Web tell catalog

Contents
- [How to read this file](#how-to-read-this-file)
- [A. Structure & layout](#a-structure--layout)
- [B. Color](#b-color)
- [C. Typography](#c-typography)
- [D. Space, shape, elevation](#d-space-shape-elevation)
- [E. Components & states](#e-components--states)
- [F. Motion](#f-motion)
- [G. Copy](#g-copy)
- [H. Second-order defaults (the "tasteful" traps)](#h-second-order-defaults-the-tasteful-traps)
- [I. Platform honesty](#i-platform-honesty)
- [J. Code that produces generic UI](#j-code-that-produces-generic-ui)
- [Detectors](#detectors)

## How to read this file

Each tell: **ID — title** `severity` `⚙ code-certain | 👁 rendered`. Then **Signal** (the
JSX/CSS/Tailwind that gives it away), **Reads AI** (why), **Fix** (what to do). Code-certain
tells are enforced by `lx-slop-guard` (ESLint for JS/TS/JSX/TSX/Vue/Svelte, Stylelint for
CSS/SCSS). This catalog is web-specific; Flutter/mobile anti-slop lists miss most of it, and
most published web anti-slop lists stop at "avoid indigo and Inter".

---

## A. Structure & layout

### WEB-ST-01 — The centered hero `P0` `👁`
**Signal** `<section className="min-h-[80vh] flex flex-col items-center justify-center text-center px-4">`
wrapping a headline, a subhead, and two buttons — as the entire first viewport.
**Reads AI** Vertical + horizontal centering with equal margins is what you do when the brief
carried no hierarchy. Every generated landing page opens this way.
**Fix** Align the hero to the real hierarchy: left-aligned on a constrained measure, with the
most characteristic thing in the subject's world (a product shot, a live demo, real
headline) as the anchor. Center only for genuinely single-CTA surfaces (login, waitlist).

### WEB-ST-02 — The canonical 3-card feature grid `P0` `👁`
**Signal** `<div className="grid md:grid-cols-3 gap-6">` of identical cards: icon in a tinted
box, `font-semibold` title, two lines of blurb, equal height, equal padding.
**Reads AI** The single most recognizable generated block on the web — equal cells are the
composition of a template; real products have one feature that matters more.
**Fix** Lead with one feature at real size and demote the rest, or use prose/a table. If
cards are right, let the content set the sizes — one genuinely bigger tile.

### WEB-ST-03 — Landing-page template skeleton `P1` `👁`
**Signal** The order is always: nav → centered hero → logo strip → 3 feature cards →
bento/stat row → testimonial trio → pricing trio → CTA banner → footer. Reused across
sites.
**Reads AI** It is the ship-fast Vercel/React template stamped regardless of product.
**Fix** Reorder and rename sections for the product. Drop every section that could be
deleted without loss (see WEB-ST-04).

### WEB-ST-04 — Dead sections `P1` `👁`
**Signal** "Trusted by teams worldwide" with invented logo SVGs; a blog-teaser row on a tool
that has no blog; a stats band (`99.9% uptime · 10k users · 150 countries`) with no source.
**Reads AI** Generated to occupy a template slot, not to serve the user's job.
**Fix** Apply the filter: a region stays only if it helps the user understand the situation
or complete the outcome.

### WEB-ST-05 — No responsive structure `P0` `👁`
**Signal** One flex/grid composition that never changes shape: `grid-cols-3` at every width,
fixed internal widths inside a `max-w-7xl mx-auto` shell, no `sm:`/`md:` decisions about
what stacks or collapses.
**Reads AI** A desktop screenshot scaled down is not a responsive site.
**Fix** Choose one behavior per region — stay / stack / reorder / collapse / scroll / hide —
and verify at 320·600·840·1200·1920 (see also WEB-X-01).

### WEB-ST-06 — Broken proximity `P2` `👁`
**Signal** `gap-6` or `space-y-4` applied uniformly down a whole page, so a label sits as far
from its value as from the next section's heading.
**Reads AI** Equal gaps carry no meaning; the gestalt law of proximity is ignored.
**Fix** Tighten spacing inside groups (8–12), open between groups (48–96); group with
whitespace, not boxes.

---

## B. Color

### WEB-CO-01 — Tailwind indigo/violet default accent `P0` `⚙`
**Signal** `bg-indigo-600 hover:bg-indigo-500`, `text-violet-600`, `bg-blue-600` as the
primary action; `@apply bg-indigo-600` in a component layer; `theme.extend.colors.primary`
mapped to `indigo`.
**Reads AI** Indigo/violet is the statistical center of AI color taste on the web — the
default primary of generated Tailwind, and the framework-color archetype (B2).
**Fix** Seed from the subject's world, then map it into the theme so components use
`bg-primary`. Never ship the palette's stock name as the brand.

### WEB-CO-02 — Raw hex / rgb in JSX or className `P0` `⚙`
**Signal** `<button style={{ backgroundColor: '#4f46e5' }}>` or
`className="text-[#1b1a17] bg-[#fbfaf7] border-[#e7e5df]"`.
**Reads AI** No token layer was used; a color was invented per element (B3).
**Fix** Semantic tokens on `:root` / in `tailwind.config` (`bg-surface`, `text-ink`,
`bg-accent`), consumed by name. Literals allowed only inside token/theme files.

### WEB-CO-03 — The purple→pink gradient wash `P0` `⚙`
**Signal** `bg-gradient-to-r from-purple-500 to-pink-500` (or `from-indigo-500 via-violet-500
to-pink-500`) on hero backgrounds, buttons, badges, and one `bg-clip-text text-transparent`
headline word.
**Reads AI** The default decoration of generated UI — the web twin of the Dart
purple/blue `LinearGradient`.
**Fix** Flatten to a surface + intentional type. If a gradient is genuinely right, keep it
in one hue family, one place, and add a little noise/texture so it doesn't band.

### WEB-CO-04 — Accent used everywhere `P0` `👁`
**Signal** The accent on buttons, links, headings, icons, borders, badges, section
backgrounds, *and* the logo — counted on one screen.
**Reads AI** A color used everywhere is used nowhere; nothing stands out (B4).
**Fix** Cap the accent at ~2 visible uses per screen: the one primary action and selection
state. Everything else is neutral.

### WEB-CO-05 — Low-contrast grey text `P0` `👁`
**Signal** `text-gray-400` body on white; `text-muted-foreground` below 4.5:1; placeholder
text indistinguishable from real content; `text-white/60` on a mid-tone image.
**Reads AI** The most common accessibility error on the web, and it reads unfinished (B7).
**Fix** Verify every text/background pair at ≥ 4.5:1 body, ≥ 3:1 large — in both themes.
Tokenize `ink` and `inkMuted` as a pair and test them together.

### WEB-CO-06 — Pure `#000` / `#fff` surfaces `P1` `👁`
**Signal** `bg-white text-black` pages; full-contrast `bg-black` sections; `#ffffff` cards on
`#f5f5f5`; `border-gray-200` as the only structure.
**Reads AI** Untuned neutrals read default; real palettes sit a few degrees off pure.
**Fix** Warm or cool the base by a few percent; derive neutrals from the accent's hue at low
chroma so the greys read as chosen.

### WEB-CO-07 — Dark mode by inversion `P1` `👁`
**Signal** `.dark` only swaps `background`/`color` tokens; `bg-primary` keeps full chroma on
near-black; `#000` body with `#fff` text; shadows unchanged.
**Reads AI** Inverted light themes look generated; they weren't designed for dark (B9).
**Fix** Design dark by hand: lift surfaces off pure black, desaturate large accent areas,
re-check contrast, swap shadows for hairline borders or subtle glows.

---

## C. Typography

### WEB-TY-01 — Inter by default `P0` `⚙`
**Signal** `font-family: Inter, ...` in CSS, `--font-sans: Inter` in `globals.css`,
`next/font` loading Inter with no stated reason, `@import` of Inter in a Vite app.
**Reads AI** The statistical center of generated web type — "the AI font" (C1/C2).
**Fix** A face nobody in the category uses, paired with a plain workhorse, with the reason
written down. Map it once in the Tailwind theme / `:root`.

### WEB-TY-02 — The Space Grotesk / Geist reflex `P1` `⚙`
**Signal** `'Space Grotesk'` / Geist / Geist Mono / Satoshi appearing right after Inter was
banned — same slot, same sizes, same treatment.
**Reads AI** Avoiding the first default just moves the model to the second; these are the
new known generated faces.
**Fix** Pick from the subject's world (a trade journal's serif, an instrument panel's
silkscreen face), not from the "tasteful startup font" list.

### WEB-TY-03 — Gradient one-word headline `P1` `👁`
**Signal** `<h1>Ship <span className="bg-gradient-to-r from-purple-500 to-pink-500
bg-clip-text text-transparent">faster</span>.</h1>`
**Reads AI** The named typographic tell — emphasis as a gradient decal on one aspirational
word (C4).
**Fix** Let size/weight/spacing carry the line. If one word gets emphasis, make it a real
decision (a different weight, a different family, with a reason) — not a paint job.

### WEB-TY-04 — Weak hierarchy `P0` `👁`
**Signal** `text-2xl`, `text-xl`, `text-lg` for title/subtitle/body — three near-equal
steps; a hero headline at `text-4xl` that barely exceeds the nav.
**Reads AI** Mush. Contrast in size *is* hierarchy (C3).
**Fix** Make display genuinely large (`text-5xl`+ with tight tracking) and body genuinely
readable (`text-base`, leading 1.5–1.6); the gap does the work.

### WEB-TY-05 — ALL-CAPS tracked kicker above every heading `P1` `⚙`
**Signal** `<span className="text-xs uppercase tracking-widest text-accent">Features</span>`
repeated above each section heading.
**Reads AI** Template chrome that appears regardless of subject (C4).
**Fix** A real heading, normal prose, or nothing. One is a choice; above every section is a
pattern.

### WEB-TY-06 — Unconsidered measure and leading `P1` `👁`
**Signal** Body `<p>` spanning the container's full 1280px; `leading-tight` on paragraphs;
`text-[15px] leading-[1.2]` in a prose block.
**Reads AI** Unconsidered measure and leading is a default tell; nobody chose the line
length (C5).
**Fix** 45–70 characters per line (`max-w-prose` / `max-w-[65ch]`); leading 1.5–1.6 for
body, tight only for display.

### WEB-TY-07 — Non-tabular figures `P2` `⚙`
**Signal** Prices, counts, and table numbers in the proportional face; `tabular-nums` never
used; columns jitter as values update; a live timer that reflows.
**Reads AI** Data UI that shimmies reads unfinished (C6).
**Fix** `font-variant-numeric: tabular-nums` (Tailwind `tabular-nums`) on anything that
updates in place or aligns in a column.

---

## D. Space, shape, elevation

### WEB-SH-01 — `p-4` / `rounded-lg` / `shadow-md` on everything `P0` `⚙`
**Signal** The Tailwind SaaS-card kit:
`className="rounded-lg shadow-md p-4 border"` on cards, panels, list items, navs, modals —
one radius, one shadow, one padding.
**Reads AI** The SaaS-card kit in Tailwind: identical rounded shadowed boxes with no
hierarchy (D2/D3/D5 collapsed into one reflex).
**Fix** A radius ladder (control / surface / pill), an elevation ladder *or* hairline
borders + tonal surfaces, and padding by role. Reserve shadow for real layering.

### WEB-SH-02 — Magic px arbitrary values `P0` `⚙`
**Signal** `p-[17px]`, `mt-[26px]`, `gap-[13px]`, `w-[732px]` scattered down a component
file.
**Reads AI** No spacing system; every gap was invented at the keyboard (D1).
**Fix** One named scale (base 4 or 8) in the theme — `p-md`, `gap-2`. Arbitrary values only
for genuinely one-off media dimensions.

### WEB-SH-03 — One radius everywhere `P1` `⚙`
**Signal** `rounded-lg` (or `rounded-xl`) on buttons, inputs, cards, menus, avatars, and
badges alike — the `--radius: 0.5rem` shadcn default applied to the whole product.
**Reads AI** Collapses component hierarchy; a pill and a panel shouldn't share a corner
(D2).
**Fix** A ladder by role: control / surface / pill / avatar. Small controls get small radii.

### WEB-SH-04 — Shadow on flat surfaces `P1` `👁`
**Signal** `shadow-sm` on section backgrounds, inline cards, and elements not raised over
anything; a gradient border standing in for elevation.
**Reads AI** Decoration without a light source or a layering role (D4).
**Fix** Flat content gets borders or tonal separation; shadow only for things genuinely
stacked (menus, popovers, sticky bars, dialogs).

### WEB-SH-05 — Uniform gap `P1` `⚙`
**Signal** `gap-6` on every grid, `space-y-4` down every section — the same rhythm from nav
to footer, no denser or calmer regions.
**Reads AI** Padding applied by reflex rather than by role; no vertical rhythm (D5/D7).
**Fix** A section rhythm (e.g. 96 between sections, 48 within, 16–24 inside components) and
deliberate density contrast between regions.

### WEB-SH-06 — Hardcoded shadow arbitrary `P1` `⚙`
**Signal** `shadow-[0_4px_20px_rgba(0,0,0,0.08)]` repeated with per-component numbers, or
inline `boxShadow` styles tuned in isolation.
**Reads AI** An elevation ladder doesn't exist; each shadow was invented alone.
**Fix** 2–3 named elevation tokens (`shadow-subtle`, `shadow-medium`, `shadow-floating`)
in the theme; reference them by name.

---

## E. Components & states

### WEB-CM-01 — Happy path only `P0` `👁`
**Signal** No loading, empty, no-results, error, disabled, or offline states in the tree;
data is assumed present and the fetch is assumed to have succeeded.
**Reads AI** Generated screens only render the state where everything worked.
**Fix** Model state as a discriminated union so TS forces every branch, rendered in the
same frame with the same tokens:
```tsx
type Loadable<T> =
  | { status: 'loading' }
  | { status: 'empty'; reason: string }
  | { status: 'ready'; data: T }
  | { status: 'error'; message: string; retry: () => void };
```

### WEB-CM-02 — Centered spinner as the whole loading state `P1` `⚙`
**Signal** `<div className="flex h-64 items-center justify-center"><Loader2
className="animate-spin" /></div>` as the sole loading affordance.
**Reads AI** It says nothing about what is loading, and the layout jumps when data lands.
**Fix** Skeletons that preserve the final layout, or a progress model that names what's
pending. Spinners only for genuinely indeterminate, short waits.

### WEB-CM-03 — Identical feature cards `P1` `👁`
**Signal** 3–4 `<Card>`s, each: icon in a tinted box, `font-semibold` title, two lines of
blurb, forced equal height.
**Reads AI** The most recognizable generated block on the web (E3; pairs with WEB-ST-02).
**Fix** Prose, a table, or a genuinely asymmetric layout. If cards are right, make them
differently sized where the content is.

### WEB-CM-04 — Icon in a rounded box `P1` `👁`
**Signal** `<div className="rounded-lg bg-primary/10 p-3"><Icon className="h-5 w-5
text-primary" /></div>` repeated per feature or list item.
**Reads AI** Decorative containment with no role — icons filling boxes (E4).
**Fix** Use the icon plainly next to the label, or drop it. Icons should improve
recognition, not occupy a slot.

### WEB-CM-05 — Emoji as icons `P0` `⚙`
**Signal** `<span>🚀</span>` as the logo mark, `<li>✨ Feature</li>` bullets, an emoji as the
sole content of a button.
**Reads AI** Emoji standing in for an icon set reads generated (E5).
**Fix** A monoline icon set (Lucide, heroicons, your own) at consistent weight — or
nothing. Reserve emoji for copy where the product's voice genuinely uses them.

### WEB-CM-06 — Untouched shadcn/Radix defaults `P0` `👁`
**Signal** Stock shadcn `Button`/`Card`/`Dialog`/`Badge`/`Avatar` at default sizes with the
default zinc neutrals, default `--primary: indigo`, and default `--radius` — straight from
`npx shadcn@latest init`, no theme edits.
**Reads AI** "Why does this look like untouched shadcn?" — because it is. It's the median of
current AI-built React UI: a fresh scaffold wearing a logo.
**Fix** Re-map `--primary`, `--radius`, `--font-sans`, and the neutral *before* writing
features; then change what the components do (labels, density, states, composition), not
just what they look like. If the product could ship the defaults unchanged, it reads as a
template.

### WEB-CM-07 — Stock CTA pair `P1` `👁`
**Signal** `<Button>Get Started</Button><Button variant="outline">Learn More</Button>` in
the hero and again in the footer.
**Reads AI** Generic labels and a filler pair that could serve any product (E7).
**Fix** Name the actual action ("Create your first invoice"). One primary per surface; the
secondary is a genuinely different path, not a required pair.

### WEB-CM-08 — Hero badge pill `P1` `👁`
**Signal** `<Badge className="rounded-full border px-3 py-1 text-xs">✨ Now with
AI</Badge>` floating above the hero headline, linked to nothing.
**Reads AI** The generated-hero fingerprint — an announcement slot filled with a
non-announcement.
**Fix** Ship it only with real news (a launch, a version, a new limit) and a link to it;
otherwise delete the pill and start with the headline.

---

## F. Motion

### WEB-MO-01 — Scroll-triggered fade-up on everything `P0` `👁`
**Signal** framer-motion `initial={{ opacity: 0, y: 24 }} whileInView={{ opacity: 1, y: 0 }}`
on every section, card, and list item; an `IntersectionObserver` + `.reveal` class applied
page-wide.
**Reads AI** Named as a top generic default; a page where nothing is still reads nervous and
template-made.
**Fix** One orchestrated sequence for the first viewport; after that, motion answers actions
only.

### WEB-MO-02 — Linear / default timing functions `P1` `⚙`
**Signal** `transition-all duration-300` with no `ease-*`; CSS `transition: all .3s`;
`animation-timing-function: linear`; GSAP/framer defaults never tuned.
**Reads AI** Mechanical motion reads unpolished (F2).
**Fix** Ease-out for entrances, ease-in for exits, springs for drag. Encode curves as
tokens (`--ease-out`, `--ease-spring`).

### WEB-MO-03 — Content gated at `opacity-0` until intersection `P0` `👁`
**Signal** `<section className="opacity-0 translate-y-4 transition-opacity duration-700
data-[shown]:opacity-100">` — sections blank in a static screenshot, in print, or with JS
half-loaded; text unfindable via Ctrl+F until scrolled.
**Reads AI** Decoration gating information; the static capture is empty and the failure
modes are silent (F3).
**Fix** Content present by default; animate as garnish, never as a gate. If a reveal is
genuinely wanted, gate it behind `scripting: enabled` and keep above-the-fold essentials
visible.

### WEB-MO-04 — `prefers-reduced-motion` ignored `P1` `⚙`
**Signal** No `@media (prefers-reduced-motion: reduce)` rule anywhere;
`useReducedMotion()` unused; infinite CSS animations that keep looping.
**Reads AI** Motion that ignores the accessibility setting is both a tell and a bug (F4).
**Fix** A global reduce-motion rule that zeroes durations/transitions, plus component-level
honors for the few animations that carry meaning — show final states, keep the flow usable.

### WEB-MO-05 — One duration for everything `P2` `⚙`
**Signal** `duration-300` (or 200/150) on every transition in the app; a shared
`transition: 0.3s` in the stylesheet.
**Reads AI** No motion scale; a menu and a page entrance move at the same speed (F5).
**Fix** A small scale — fast ~120 / base ~240 / slow ~400 — mapped to element size and
distance; name the tokens.

### WEB-MO-06 — Decoration motion `P2` `👁`
**Signal** Infinite `animate-pulse` blobs, floating gradient orbs, parallax hero layers, a
spinner still looping after the data arrived.
**Reads AI** Motion without a job; the "premium feel" reflex (F6).
**Fix** Motion shows a state change, directs attention, or rewards an interaction. At most
one thing moves on its own per view.

---

## G. Copy

### WEB-CP-01 — Filler / unfalsifiable copy `P0` `⚙`
**Signal** "Lorem ipsum", "Acme Inc", "Item 1", "Get Started", "10× faster" with no source,
"Join 10,000+ teams", `example.com` domains in the UI.
**Reads AI** The single strongest tell, and it has nothing to do with design (G1).
**Fix** Real nouns, numbers, dates, and lengths. If a metric isn't real, mark it as a
placeholder in the content model or leave it out.

### WEB-CP-02 — Category slogans `P1` `⚙`
**Signal** "Supercharge your workflow", "Unlock your potential", "Seamless integration",
"Elevate your team", "Effortless scheduling", "Next-generation analytics".
**Reads AI** Words that describe a category rather than a product (G2).
**Fix** Replace with a claim only this product can make, ideally with a number.

### WEB-CP-03 — "It's not X, it's Y" `P1` `⚙`
**Signal** `<h2>It's not a todo list. It's a life OS.</h2>` / "More than just a CRM." /
"Linear, but for teams that ship."
**Reads AI** The reframe construction — the UI version of a known writing tell (G3).
**Fix** State the thing directly.

### WEB-CP-04 — Stock testimonials `P1` `👁`
**Signal** Three five-star quotes; `<Avatar>` with initials; "Sarah Chen — CEO, Acme Corp",
"Mike Tanaka — CTO, Globex" — one persona per continent, invented logos.
**Reads AI** The clearest testimonial tell (G7).
**Fix** Real testimonials with real attribution, or none — replace the section with usage
data or a case note.

### WEB-CP-05 — Verb drift in flows `P1` `👁`
**Signal** Button says "Submit", `toast('Saved!')`, heading says "Success!". Or one signup
flow: "Sign up" → "Create account" → "Get started".
**Reads AI** No one owned the vocabulary (G5).
**Fix** An action keeps its name through the flow: "Publish" → "Published". Active voice,
second person.

### WEB-CP-06 — Generic error/empty copy `P1` `👁`
**Signal** `toast.error('Something went wrong')`; `<EmptyState>No data</EmptyState>`;
"Please try again later."; a 404 that says only "404".
**Reads AI** Errors that apologize or stay vague; empty states that dead-end (G6).
**Fix** Say what failed, what is safe, and how to recover. Empty states are invitations to
act ("Create your first project").

### WEB-CP-07 — Placeholder people in demo data `P1` `⚙`
**Signal** "John Doe", "Jane Smith", `jane@example.com`, "123 Main Street", lorem-length
bios in seed scripts that ship to the production UI.
**Reads AI** Demo personas leaking into the real interface — web's version of filler copy.
**Fix** Real-shaped, internally consistent data through the content model; scrub
`example.com` and the John Does before shipping.

---

## H. Second-order defaults (the "tasteful" traps)

The following are the escapes that became the new median. Legitimate for some briefs; tells
when they appear regardless of subject.

### WEB-SD-01 — The untouched shadcn / Vercel template look `P0` `👁`
Zinc neutrals, default indigo `--primary`, `rounded-lg`, Inter (or Geist if Next.js),
centered hero, default component density — a fresh `create-next-app` + shadcn scaffold with
a logo on it. **Fix** Re-map color, radius, font, and density from the brief before writing
features. The template is a wireframe, not a direction. (See WEB-CM-06 for the component
half.)

### WEB-SD-02 — Cream + terracotta `P1` `👁`
Warm cream background (~#F4F1EA), high-contrast serif display, terracotta/clay accent
(~#D97757 — Anthropic's own interaction accent). **Fix** Only if the brief asked for warmth;
otherwise the neutral family should be derived from this product's subject.

### WEB-SD-03 — Acid-on-black `P1` `👁`
Near-black background with a single bright acid-green or vermilion accent, often with glow
borders and a mono label. **Fix** Legitimate for some brands; a default otherwise.

### WEB-SD-04 — Broadsheet chrome `P1` `👁`
Hairline rules, zero radius everywhere, dense newspaper columns, pure black-on-white.
**Fix** Justify each; zero radius as a *rule* is as much a default as radius 12 as a rule.

### WEB-SD-05 — All-glass / glassmorphism `P1` `👁`
`backdrop-blur-md bg-white/10 border border-white/20` on nav, cards, modals, and buttons —
frosted everything over a gradient or a blurred photo. **Fix** Glass must indicate real
layering over meaningful content; one place, or none.

### WEB-SD-06 — All-neubrutalism `P1` `👁`
`border-2 border-black shadow-[4px_4px_0_#000]` on every element, mono type, hard
high-chroma palette. **Fix** A style applied uniformly is a system, not a choice; keep it
disciplined and rare, or it's just another default.

### WEB-SD-07 — Template micro-chrome `P1` `⚙`
Tracked ALL-CAPS eyebrow above every heading; middot meta ("React · TypeScript · Edge");
"WORD — fragment" section headers; `font-mono` for small labels "to look technical"; "→"
appended to every button; tinted near-black `#0B0B0B` standing in for black. **Fix** Real
headings and plain labels; reserve these devices for the few places they mean something.

### The web second-order ladder (note)
After being told to avoid indigo and Inter, a code model reaches for, in order: **Space
Grotesk** (or Geist), **cream + terracotta**, the **untouched shadcn default** palette, a
**bento grid** as the "not-a-3-card-grid" move, and **acid-on-black**. Each escape is now
its own median — the bento reflex is especially common, since swapping `grid-cols-3` for a
bento feels like a decision while remaining template behavior (see WEB-ST-02). The only
stable move is deriving color, type, and density from the subject, and stating the reason.

---

## I. Platform honesty

Full detail on the cross-platform matrix in `lx-cross-platform`. The web archetypes:

### WEB-X-01 — Fixed desktop width / no breakpoints `P0` `⚙`
**Signal** `w-[1200px]` / `min-w-[1024px]` on the shell; a file with no `sm:`/`md:`/`lg:`
variants or `@media` rules; `overflow-x` on `<body>` from a phone.
**Reads AI** A desktop screenshot parked in a browser tab (I3).
**Fix** Fluid container (`max-w-* mx-auto px-*`), a breakpoint decision per region, verify
320·600·840·1200·1920.

### WEB-X-02 — Tiny tap targets `P0` `👁`
**Signal** `h-6 px-2` buttons, `p-1` icon buttons, `text-xs` nav links with `gap-1`, 12px
checkbox labels — desktop-pointer thinking.
**Reads AI** Unusable on touch; the layout was designed for a mouse at 1440px (I2).
**Fix** ≥ 44×44px interactive targets (inline text links may be smaller with spacing);
`p-2`+ hit areas around icon buttons; test on a real device.

### WEB-X-03 — Horizontal scroll at 320px `P0` `👁`
**Signal** A fixed-width table, an `<img>` without `max-w-full`, `whitespace-nowrap` on long
text, a `w-screen` hero with padding, an unbreakable flex row.
**Reads AI** Nobody opened devtools at a small width before shipping.
**Fix** `overflow-x-auto` on wide data, `max-w-full h-auto` on media, wrapping text; test
320 before calling it done.

### WEB-X-04 — Hover-only affordances, no focus-visible `P0` `⚙`
**Signal** `hover:opacity-80` / `hover:underline` with no `focus-visible:` variant;
`outline-none` on inputs and buttons; row actions ("Delete") that exist only on hover.
**Reads AI** Keyboard and touch users are locked out — a tell and a WCAG failure (I2).
**Fix** `focus-visible:ring-2 ring-offset-2` (or a real `:focus-visible` outline) on every
interactive element; never hide an action that exists only on hover.

### WEB-X-05 — Click handlers on non-interactive elements `P0` `⚙`
**Signal** `<div onClick={open} className="cursor-pointer">` with no `role`, `tabIndex`, or
key handler; `<span onClick>` chips; a "clickable card" wrapping a real link and fighting it.
**Reads AI** Semantics ignored: keyboard unreachable, screen readers announce nothing (I2).
**Fix** `<button type="button">` for actions, `<a>` for navigation. Custom controls get
`role`, `tabIndex={0}`, and Enter/Space handling — or use Radix/Svelte-A11y primitives that
already do it.

### WEB-X-06 — Browser contract broken: hidden scrollbars, unselectable text `P1` `⚙`
**Signal** `scrollbar-width: none` / `::-webkit-scrollbar { display: none }` on scrollers
with no custom indicator shipped; `user-select: none` on body/content; `overscroll-behavior`
traps; `history.pushState` games that break the back button.
**Reads AI** The page fights the host instead of living in it (I6).
**Fix** Hide scrollbars only when you ship a visible custom scrollbar; keep text selectable;
keep native scrolling and history intact.

---

## J. Code that produces generic UI

Structural smells that reliably produce a generic result even when the styling is fine.

### WEB-CD-01 — Raw visual values in the render path `P0` `⚙`
**Signal** `style={{ color: '#4f46e5', padding: 17, borderRadius: 8 }}`; hex/`rgb()` in
`className` arbitraries inside feature components.
**Reads AI** The render path invents the design per element (J1).
**Fix** A token layer the view reads (CSS custom properties / theme names); literals only
in token/theme files.

### WEB-CD-02 — No token layer `P0` `👁`
**Signal** Tailwind at stock config; `globals.css` with no `:root` custom properties; every
color a palette name, every size an arbitrary; a tokens JSON that nothing imports.
**Reads AI** A theme with a seed and nothing else — nothing can shift as a system (J2).
**Fix** One token set (`--surface`, `--ink`, `--accent`, space/radius/motion scales) wired
into `tailwind.config` `theme.extend`; components consume roles, never palettes.

### WEB-CD-03 — Arbitrary Tailwind values as a system `P0` `⚙`
**Signal** `text-[15px] tracking-[0.02em] leading-[1.7] p-[22px] rounded-[10px]
shadow-[0_2px_12px_rgba(0,0,0,.06)]` dominating a file — the JIT escape hatch used as the
design system.
**Reads AI** The scale exists but was bypassed everywhere; each value was tuned alone
(J1/C1/D1 in one habit).
**Fix** Extend the theme so each value has a name (`text-body`, `p-card`,
`rounded-surface`); arbitraries for genuine one-offs only, with a comment saying why.

### WEB-CD-04 — Boolean state soup `P1` `👁`
**Signal** `const [isLoading, setIsLoading] = useState(false); const [error, setError] =
useState(null); const [isEmpty, setIsEmpty] = useState(false);` — independent flags that can
contradict (`isLoading && error`).
**Reads AI** Impossible states are representable; components branch on ad-hoc combinations
(J3).
**Fix** A discriminated union (see WEB-CM-01) so TypeScript forces every branch.

### WEB-CD-05 — Duplicate components `P1` `👁`
**Signal** `ButtonNew.tsx`, `BetterCard.tsx`, a second `PrimaryButton`, three modals with
different names and overlapping props.
**Reads AI** Nobody owns the component layer; the design forks silently (J4).
**Fix** One canonical component per role; a named variant when the difference repeats and
means something.

### WEB-CD-06 — Strings inline in components `P1` `👁`
**Signal** `<h1>Welcome back</h1>`, `toast('Saved successfully')`, validation messages
hardcoded in JSX — no content layer, no i18n path, no RTL plan.
**Reads AI** Copy can't be reviewed, translated, or tested; it drifts per component (J5).
**Fix** Centralize copy (content module / i18n catalog / CMS); prepare for i18n and RTL
before the strings multiply.

### WEB-CD-07 — Theme handled by sprinkles, `prefers-color-scheme` ignored `P1` `👁`
**Signal** `dark:` variants pasted per component with no dark token set; hardcoded hex that
only works in light; a toggle that flips one class while stylesheets never see it; no
`color-scheme` meta.
**Reads AI** Dark mode bolted on; conditional theming in the view path (J6/B9).
**Fix** Define both schemes in the token layer (`:root` + `.dark` custom properties);
components reference `--ink` etc. and never branch on the theme. Set `color-scheme` and
honor the OS default.

---

## Detectors

The `⚙` subset is implemented for the web by two packages, both using the **universal rule
names** from `slop-taxonomy.md`:

- **`packages/eslint-plugin-lx-slop`** — JS/TS/JSX/TSX, so it covers React, Next.js, Vue
  SFCs (via `vue-eslint-parser`), and Svelte (via `svelte-eslint-parser`).
- **`packages/stylelint-lx-slop`** — CSS/SCSS, catching raw colors, spacing, radii, and
  font sizes in stylesheets.

Rule names are the same snake_case vocabulary as every other pack: `hardcoded_color`,
`framework_color`, `default_theme`, `hardcoded_spacing`, `hardcoded_radius`,
`hardcoded_font_size`, `hardcoded_elevation`, `hardcoded_duration`, `reflex_font`,
`linear_motion`, `emoji_icon`. Suppression and baselines are portable:
`// eslint-disable-next-line lx-slop/hardcoded-color` (JS) ·
`/* stylelint-disable-next-line lx-slop/hardcoded-color */` (CSS).

What no detector does: copy quality, layout tension, palette harmony, "soul", and everything
`👁`. The tool narrows the search; a person decides. See `lx-slop-guard` for detector usage
and `lx-design-verify` for the rendered pass.
