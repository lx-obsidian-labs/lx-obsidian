# Flutter tell catalog

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
- [I. Cross-platform summary](#i-cross-platform-summary)
- [J. Code that produces generic UI](#j-code-that-produces-generic-ui)

## How to read this file

Each tell: **ID — title** `severity` `⚙ code-certain | 👁 rendered`. Then **Signal** (the Dart
that gives it away), **Reads AI** (why), **Fix** (what to do). Draw-certain tells are enforced
by `lx-slop-guard`. This catalog is Flutter-specific; web anti-slop lists miss most of it.

---

## A. Structure & layout

### FLS-ST-01 — The centered column screen `P0` `⚙`
**Signal** `Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [...]))`
as the whole `Scaffold.body`.
**Reads AI** Vertical centering is the lazy default when there is no content hierarchy. Every
generated screen centers its stack.
**Fix** Decide the real hierarchy from the surface contract. Use `SafeArea` + a padded
`Column`/`CustomScrollView` with left-aligned content, or an `Align`/`Column` with deliberate
`spaceBetween`/`start`. Center only when the content genuinely warrants it (login, single CTA).

### FLS-ST-02 — The uniform grid of equal cells `P0` `👁`
**Signal** A `GridView`/`Wrap`/`Row` of identical tiles, same size, same padding, same icon box.
**Reads AI** Equal cells are the composition of a template; real products have one cell that
matters more.
**Fix** Introduce one asymmetry: a larger lead cell, a bento with a genuinely bigger tile, or a
list-plus-feature. Use `SliverGrid` with a custom delegate to vary span.

### FLS-ST-03 — Card-in-card nesting `P1` `👁`
**Signal** A `Card` containing a `Card`, or a `Container` with `elevation`/decoration inside
another decorated container.
**Reads AI** Excessive containment is the visual signature of padding the layout to look
designed.
**Fix** A container earns its place only when it separates regions needing a visible boundary.
Flatten; use a divider or a surface tone change instead of a nested card.

### FLS-ST-04 — Template section skeleton `P1` `👁`
**Signal** The order is always: header → hero/stat row → 3 feature cards → testimonial trio →
CTA banner → footer-in-app. Reused across app screens.
**Reads AI** It is the web landing template stamped into an app.
**Fix** Reorder and rename for the product. Drop sections that could be deleted without loss.

### FLS-ST-05 — Dead regions `P1` `👁`
**Signal** A section whose removal changes nothing the user needs.
**Reads AI** Generated to fill a template slot.
**Fix** Apply the filter: a region stays only if it helps the user understand the situation or
complete the outcome.

### FLS-ST-06 — Perfect symmetry, no tension `P2` `👁`
**Signal** Everything centered, every margin equal, no intentional asymmetry.
**Reads AI** Uniform medium rhythm reads as default; deliberate alternation reads as chosen.
**Fix** Alternate density (one tight section, one breathing section) and break the grid once.

### FLS-ST-07 — Fixed layout, no adaptation at the structure level `P0` `👁`
**Signal** A single layout regardless of window width; `Row`/`Column` with `Expanded` guessing.
**Reads AI** The same screen at every size is a phone screenshot scaled.
**Fix** Branch on window size (see `lx-cross-platform`). Choose one behavior per region:
stay / stack / reorder / collapse / scroll / drawer / disappear.

### FLS-ST-08 — Hero with the default treatment `P1` `👁`
**Signal** A big number + small label + supporting stats + a gradient accent as the opening.
**Reads AI** It is explicitly the default treatment Anthropic's skill calls out.
**Fix** Open with the most characteristic thing in the subject's world — an image, an
animation, a live demo, a real headline — not the stat block, unless the stat *is* the point.

### FLS-ST-09 — Everything left-aligns but nothing groups `P2` `👁`
**Signal** Equal gaps between all elements; proximity carries no meaning.
**Reads AI** Generated layouts often miss the gestalt law of proximity.
**Fix** Group related items with tighter spacing; let whitespace separate groups.

### FLS-ST-10 — Over-`Padding` to fake polish `P1` `⚙`
**Signal** `Padding(padding: EdgeInsets.all(24))` wrapping everything uniformly.
**Reads AI** Uniform generous padding is the "make it look designed" reflex.
**Fix** Use a spacing scale with intent; vary padding by role (gutters, section, tight rows).

---

## B. Color

### FLS-CO-01 — Default Material seed `P0` `⚙`
**Signal** `ColorScheme.fromSeed(seedColor: Colors.deepPurple)` / `Colors.indigo` /
`Colors.blue`; or `ThemeData(useMaterial3: true)` with no `colorScheme`.
**Reads AI** Indigo/violet is the statistical center of AI color taste.
**Fix** Choose a seed from the subject's world, then tune the resulting scheme by hand
(`ColorScheme.fromSeed(...).copyWith(...)`). Better: hand-author the key roles in `DESIGN.md`.

### FLS-CO-02 — Framework color literals `P0` `⚙`
**Signal** `Colors.blue`, `Colors.purple`, `Colors.teal`, `Colors.amber` used for UI roles.
**Reads AI** The framework's named swatches are the path of least resistance.
**Fix** Every role resolves from `colorScheme` or `AppTokens`. No `Colors.*` in `lib/`.

### FLS-CO-03 — Raw hex in widget code `P0` `⚙`
**Signal** `Color(0xFF1A1A1A)` inside a widget build method.
**Reads AI** A token system was not used; values were invented per widget.
**Fix** Define semantic roles once; reference the token. (Ignored by `lx-slop-guard` inside
theme/token files.)

### FLS-CO-04 — Accent used everywhere `P0` `👁`
**Signal** `colorScheme.primary` on buttons, icons, headings, links, borders, badges, *and*
backgrounds.
**Reads AI** A color used everywhere is used nowhere; nothing stands out.
**Fix** Cap the accent at ~2 visible uses per screen. Everything else is neutral; the accent
marks selection or the single primary action.

### FLS-CO-05 — Two-stop "trust" gradient `P0` `⚙`
**Signal** `LinearGradient(colors: [purple, blue])` / `[indigo, pink]` / `[blue, cyan]` as a
hero/background or `ShaderMask` on text.
**Reads AI** The default decoration of generated UI.
**Fix** Flatten to a surface + intentional type. If a gradient is genuinely right, keep it in
one hue family and add a little noise so it doesn't band.

### FLS-CO-06 — Neutral greys with no relationship to the accent `P1` `👁`
**Signal** Pure `Colors.grey[300]`, `#808080`, `#EEEEEE` backgrounds.
**Reads AI** The neutrals weren't derived from anything, so they read default.
**Fix** Derive neutrals from the accent's hue at low chroma; the greys then read as chosen.

### FLS-CO-07 — Low-contrast body text `P0` `👁`
**Signal** Grey-on-grey text; muted ink below 4.5:1 on the surface.
**Reads AI** Generated UIs routinely ship low contrast (the most common a11y error on the web).
**Fix** Verify every text/background pair (≥ 4.5:1 body, ≥ 3:1 large) in both themes.

### FLS-CO-08 — Unmotivated glow / `boxShadow` halo `P1` `👁`
**Signal** Containers with a large colored `BoxShadow` with no light source.
**Reads AI** Glow without a source is the cheap-depth reflex.
**Fix** Give light a source (a lit edge, a horizon, a focused element) or remove it. At most
one strong effect per screen.

### FLS-CO-09 — `surfaceTint` ignored, so elevation does nothing useful `P2` `👁`
**Signal** M3 elevation with `surfaceTintColor: Colors.transparent` bolted on, or surfaces all
the same tone.
**Reads AI** Layering that doesn't read as layering; everything is one flat plane without
borders.
**Fix** Choose one implication model (tonal surface tint **or** hairline borders) and apply it
consistently across the elevation ladder.

### FLS-CO-10 — Dark mode by inversion `P1` `👁`
**Signal** Dark theme is the light theme with `surface`↔`base` swapped; saturated accent kept
at full chroma on black.
**Reads AI** Inverted light themes look generated; they weren't designed for dark.
**Fix** Design dark by hand: desaturate large accent areas, raise surfaces a few percent, use
`onSurface` variants, test contrast in dark specifically.

---

## C. Typography

### FLS-TY-01 — Untouched `TextTheme` `P0` `⚙`
**Signal** No `textTheme:` in `ThemeData`; default Roboto at default sizes.
**Reads AI** The framework's default type is the plainest possible choice.
**Fix** Choose a family deliberately, set a scale with real contrast, and wire it once in
`ThemeData`. Test at 130%.

### FLS-TY-02 — Reflex font choice `P1` `⚙`
**Signal** `GoogleFonts.inter()`, `GoogleFonts.roboto()`, `GoogleFonts.spaceGrotesk()`,
`GoogleFonts.geist()`.
**Reads AI** These are the overused generated faces; avoiding Inter now means the model reaches
for Space Grotesk.
**Fix** Pick a face nobody in the category uses, paired with a plain workhorse. State the
reason.

### FLS-TY-03 — One-word accent in a headline `P1` `👁`
**Signal** A heading where one word is italic/bold/colored (often via `Text.rich` /
`RichText`).
**Reads AI** Named as a top typographic tell.
**Fix** Let the whole line carry the emphasis through size/weight/space, or set the accent word
as a genuinely different element with a reason.

### FLS-TY-04 — Weak hierarchy (three near-equal sizes) `P0` `👁`
**Signal** `fontSize: 22`, `20`, `18` for title/subtitle/body.
**Reads AI** Mush. Contrast in size is what creates hierarchy.
**Fix** Make the largest type genuinely large and the body genuinely readable; the gap is the
hierarchy. Tighten tracking on display sizes.

### FLS-TY-05 — ALL-CAPS tracked eyebrow above every heading `P1` `⚙`
**Signal** `textTransform`-style uppercase + `letterSpacing: 2` on a small label repeated above
each section.
**Reads AI** Template chrome that appears regardless of subject.
**Fix** Use a real heading, normal prose, or nothing. One is a choice; above every section is a
pattern.

### FLS-TY-06 — Default line length / leading `P1` `👁`
**Signal** Body text spanning the full window width; leading at 1.2.
**Reads AI** Unconsidered measure and leading is a default tell.
**Fix** 45–70 characters per line (constrain with `ConstrainedBox`/`maxWidth`); leading 1.5–1.6.

### FLS-TY-07 — Non-tabular figures `P2` `⚙`
**Signal** Numbers that change or align rendered in a proportional face.
**Reads AI** Generated data UI jitters as values change.
**Fix** `FontFeature.tabularFigures()` on any figure that updates or aligns in a column.

### FLS-TY-08 — Text scaling ignored `P1` `👁`
**Signal** Fixed-height rows/headers that clip when the system text scale grows.
**Reads AI** Generated layouts assume 100% forever.
**Fix** No absolute heights on text containers; test 130–200%; let rows grow or use
`maxLines` + `overflow` deliberately.

---

## D. Space, shape, elevation

### FLS-SH-01 — One soft shadow + one radius under every surface `P0` `⚙`
**Signal** Repeated `Card(elevation: 4)` / `BoxShadow(color: Colors.black26, blurRadius: 8)`
and `borderRadius: BorderRadius.circular(12)` on everything.
**Reads AI** The SaaS-card kit: identical rounded cards, one shadow, no hierarchy.
**Fix** Define a radius ladder and an elevation ladder (or none). Use borders/tonal surfaces for
most separation; reserve shadow for real layering.

### FLS-SH-02 — Magic-number spacing `P0` `⚙`
**Signal** `SizedBox(height: 16)`, `EdgeInsets.all(16)`, `24`, `8` chosen ad hoc down the file.
**Reads AI** No spacing system; each gap was invented.
**Fix** One named scale (base 4 or 8). `context.tokens.spaceMd`, not `16`.

### FLS-SH-03 — One radius everywhere `P1` `⚙`
**Signal** Every `BorderRadius.circular(12)` regardless of control vs surface vs pill.
**Reads AI** Collapses component hierarchy.
**Fix** A radius ladder: control / surface / pill. Apply by role.

### FLS-SH-04 — Shadow on flat surfaces `P1` `👁`
**Signal** `elevation`/`boxShadow` on elements that aren't actually raised.
**Reads AI** Decoration without a role.
**Fix** Elevation indicates real layering (menus, sheets, FAB over content). Flat content gets
borders or tone, not shadow.

### FLS-SH-05 — Uniform `EdgeInsets.all(16)` everywhere `P1` `⚙`
**Signal** The same padding on cards, rows, headers, and sheets.
**Reads AI** Padding applied by reflex rather than by role.
**Fix** Vary by role: tight rows (8), component padding (12), section (24), page gutters
(16–24 responsive).

### FLS-SH-06 — Oversized corner radius ("squircle everywhere") `P2` `👁`
**Signal** `borderRadius: 24`+ on small controls.
**Reads AI** The "friendly AI startup" reflex.
**Fix** Match radius to element size; small controls get small radii.

### FLS-SH-07 — No vertical rhythm `P2` `👁`
**Signal** Baselines don't align to a grid; sections drift.
**Reads AI** Assembled from separate prompts.
**Fix** Align to the spacing scale; consistent section spacing tokens.

### FLS-SH-08 — Colored left/top border on cards `P1` `⚙`
**Signal** `Border(left: BorderSide(color: colorScheme.primary, width: 4))` on otherwise plain
cards, repeated.
**Reads AI** The canonical "AI dashboard tile" shape.
**Fix** Drop either the radius or the colored border; convey status another way (a dot, a label,
a tint).

---

## E. Components & states

### FLS-CM-01 — FAB for everything `P1` `👁`
**Signal** A `FloatingActionButton(child: Icon(Icons.add))` on every list/detail screen.
**Reads AI** The default way to add an action, regardless of the product.
**Fix** Use the right control for the action and platform: a primary button in the app bar, an
inline "Add" row, a full-width action on mobile, a keyboard shortcut on web. FAB only when it
is genuinely a primary, single, floating action.

### FLS-CM-02 — Happy path only `P0` `👁`
**Signal** No empty, loading, no-results, error, disabled, or permission states.
**Reads AI** Generated screens assume data is present and the network is up.
**Fix** Encode states as a sealed type so the compiler forces handling:
```dart
sealed class UiState<T> {}
class Loading<T> extends UiState<T> {}
class Empty<T> extends UiState<T> { Empty(this.reason); final String reason; }
class Data<T> extends UiState<T> { Data(this.value); final T value; }
class Failure<T> extends UiState<T> { Failure(this.message, this.recover); final String message; final VoidCallback recover; }
```
Render each with the **same** frame and tokens.

### FLS-CM-03 — Spinner-only loading `P1` `⚙`
**Signal** `Center(child: CircularProgressIndicator())` as the sole loading affordance.
**Reads AI** It says nothing about what is loading.
**Fix** Skeletons that preserve the final layout (so nothing jumps), or a progress model that
shows what is pending. Use a spinner only for genuinely indeterminate, short waits.

### FLS-CM-04 — Identical feature cards `P1` `👁`
**Signal** 3–4 cards with an icon in a rounded box, a bold title, and two lines of blurb.
**Reads AI** The most recognizable generated block.
**Fix** Use prose, a table, or an honest asymmetric layout. If cards are right, make them
genuinely different where the content is.

### FLS-CM-05 — Icon in a rounded square `P1` `👁`
**Signal** `Container(decoration: BoxDecoration(color: primary.withOpacity(.1), borderRadius: 12), child: Icon(...))`
repeated per feature.
**Reads AI** Decorative containment with no role.
**Fix** Use the icon plainly, or drop it. Icons should improve recognition, not fill a box.

### FLS-CM-06 — Emoji as icons `P0` `⚙`
**Signal** `Text('✨')` / `('🚀')` / `('🎯')` used where an icon belongs, or as bullets.
**Reads AI** Emoji standing in for a real icon set reads generated.
**Fix** Use an icon set (monoline, consistent weight) or nothing. Reserve emoji for copy where
the product's voice actually uses them.

### FLS-CM-07 — Default `AppBar` chrome everywhere `P1` `👁`
**Signal** `AppBar(title: Text(...))` with default elevation/color on every route.
**Reads AI** Default chrome that ignores the product and the platform.
**Fix** Choose the app bar treatment per surface and platform. On web, a top bar with real
navigation and a URL; on Android, edge-to-edge with correct system overlays; use a
`SliverAppBar`/`LargeAppBar` only when it serves the content.

### FLS-CM-08 — Stock CTA pair `P1` `👁`
**Signal** A primary button and a secondary button reading "Get Started" / "Learn More" (or
"Try It Now" / "Book a Demo").
**Reads AI** Generic labels that could serve any product.
**Fix** Name the actual action. One primary action per surface; the secondary is a genuinely
different path, not a filler pair.

### FLS-CM-09 — Shimmer on everything `P2` `👁`
**Signal** The same shimmer skeleton applied to every list/card.
**Reads AI** A single loading idiom regardless of what loads.
**Fix** Match the skeleton to the real content shape; use quiet placeholders for short waits.

### FLS-CM-10 — No disabled/blame explanation `P1` `👁`
**Signal** A disabled button with no reason; an error with no recovery.
**Reads AI** Generated happy paths ignore why something is unavailable.
**Fix** Disabled states say why; errors say what failed, what is safe, and how to recover.

---

## F. Motion

### FLS-MO-01 — Uniform entrance on every element `P1` `👁`
**Signal** Every section fades-and-slides-up with the same duration on load/scroll.
**Reads AI** Named as the generic default; a single orchestrated moment lands better.
**Fix** One orchestrated page-load sequence; nothing else auto-moves. Motion answers actions.

### FLS-MO-02 — Linear / default curves `P1` `⚙`
**Signal** `curve: Curves.linear` or an implicit animation with no curve; `AnimatedContainer`
with default settings.
**Reads AI** Mechanical motion reads unpolished.
**Fix** Ease-out for entrances, ease-in for exits, springs for drag. Encode curves as tokens.

### FLS-MO-03 — No reduced-motion handling `P1` `⚙`
**Signal** `AnimationController(...)` with `animationBehavior: AnimationBehavior.preserve`
that ignores `MediaQuery.disableAnimationsOf`, or custom tickers that bypass it.
**Reads AI** Motion that ignores accessibility is both a tell and a bug.
**Fix** Honor reduce-motion: show final states, keep the flow usable.

### FLS-MO-04 — Content gated on scroll reveal `P0` `👁`
**Signal** Sections at `opacity: 0` until an `ScrollTrigger`-style listener fires.
**Reads AI** The static capture is blank; also fails users who don't scroll.
**Fix** Content present by default; animate deliberately, not as a gate.

### FLS-MO-05 — Same duration for everything `P2` `⚙`
**Signal** Every animation is `Duration(milliseconds: 300)`.
**Reads AI** No motion system.
**Fix** A small duration scale (fast/base/slow) mapped to element size and distance.

### FLS-MO-06 — Motion that doesn't explain a change `P2` `👁`
**Signal** Decorative loops, floating blobs, parallax with no meaning.
**Reads AI** Motion without a job.
**Fix** Motion must show a state change, direct attention, or reward an interaction. Otherwise
cut it. At most one thing moves on its own per view.

### FLS-MO-07 — Page transitions left default `P2` `⚙`
**Signal** No `PageTransitionsTheme`; default slide on every platform.
**Reads AI** Default transitions ignore platform and brand.
**Fix** Configure transitions deliberately per platform; keep back-gestures intact.

---

## G. Copy

### FLS-CP-01 — Filler / unfalsifiable copy `P0` `⚙`
**Signal** `'Lorem ipsum'`, `'Item 1'`, `'Sample content'`, `'Get Started'`, "10× faster"
with no source.
**Reads AI** The single strongest tell; it has nothing to do with design.
**Fix** Real nouns, numbers, dates, and lengths. If a metric isn't real, label it as a
placeholder or leave it out.

### FLS-CP-02 — Category slogans `P1` `⚙`
**Signal** "Unlock", "Supercharge", "Seamless", "Elevate", "Effortless", "Next-generation",
"Leverage".
**Reads AI** Words that describe a category rather than a product.
**Fix** Replace with a claim only this product can make, ideally with a number.

### FLS-CP-03 — Choppy fragments as design device `P2` `👁`
**Signal** Headlines of 3–6 words, sentence fragments stacked.
**Reads AI** Reads generated even with custom styling.
**Fix** Fewer headlines, more specific prose.

### FLS-CP-04 — "It's not X, it's Y" reframe `P1` `⚙`
**Signal** "It's not X. It's Y." / "X, not Y." / "More than just X."
**Reads AI** The UI version of a known writing tell.
**Fix** State the thing directly.

### FLS-CP-05 — Standalone slogan fragments `P2` `👁`
**Signal** "Built differently." / "Work smarter." dropped between sections.
**Reads AI** Fake profundity.
**Fix** Cut, or replace with a specific sentence.

### FLS-CP-06 — Verb drift in flows `P1` `👁`
**Signal** Button says "Submit", toast says "Saved", heading says "Success!".
**Reads AI** No one owned the vocabulary.
**Fix** An action keeps its name through the flow: "Publish" → "Published". Active voice.

### FLS-CP-07 — Generic error/empty copy `P1` `👁`
**Signal** "Something went wrong." / "No data."
**Reads AI** Errors that apologize or stay vague.
**Fix** Say what failed, what is safe, how to recover. Empty states are invitations to act.

### FLS-CP-08 — Stock persona testimonials `P1` `👁`
**Signal** Three five-star quotes, initial-only avatars, "Sarah Chen", "Mike Tanaka", one
persona per continent.
**Reads AI** The clearest testimonial tell.
**Fix** Real testimonials or none.

---

## H. Second-order defaults (the "tasteful" traps)

The following are the escapes that became the new median. Legitimate for some briefs; tells
when they appear regardless of subject.

### FLS-SD-01 — Cream + terracotta `P1` `👁`
Warm cream background (~#F4F1EA), high-contrast serif display, terracotta/clay accent
(~#D97757 — Anthropic's own interaction accent). **Fix** Only if the brief asked for warmth;
otherwise the neutral family should be derived from this product's subject.

### FLS-SD-02 — Acid-on-black `P1` `👁`
Near-black background with a single bright acid-green or vermilion accent. **Fix** Legitimate
for some brands; a default otherwise.

### FLS-SD-03 — Broadsheet chrome `P1` `👁`
Hairline rules, zero radius everywhere, dense newspaper columns. **Fix** Justify each; zero
radius as a *rule* is as much a default as radius 12 as a rule.

### FLS-SD-04 — The SaaS-card kit (Dart edition) `P0` `👁`
Identical rounded cards, one radius, the same soft shadow — see FLS-SH-01. **Fix** Ladder, not
constant.

### FLS-SD-05 — Template micro-chrome `P1` `⚙`
Tracked ALL-CAPS eyebrow above every heading; middot meta ("A · B · C"); "WORD — fragment";
tinted near-black (#0B0B0B) standing in for black; mono for small labels; "→" appended to
buttons. **Fix** Use real headings and plain labels; reserve these devices for the few places
they mean something.

### FLS-SD-06 — All-glass `P1` `👁`
`BackdropFilter`/frosted panels everywhere. **Fix** Glass must indicate real layering over
meaningful content; one place, or none.

### FLS-SD-07 — All-neubrutalism `P1` `👁`
Hard black borders, offset shadows, mono, on every element. **Fix** A style, not a system, when
applied uniformly; keep it disciplined and rare.

### FLS-SD-08 — "M3 Expressive so it's fine" `P2` `👁`
Assuming expressive components remove the need to decide. **Fix** Components are still defaults;
the direction is still yours.

---

## I. Cross-platform summary

Full detail in `lx-cross-platform`. The quick tells:

- **FLS-X-01 Material-everywhere on web** `P0` — default `AppBar`/`NavigationBar`, no
  hover/focus, no keyboard, no URL. A phone app in a browser tab.
- **FLS-X-02 No hover state** `P0` `⚙` — custom `GestureDetector` clickables with no
  `MouseRegion`/`FocusableActionDetector`.
- **FLS-X-03 No focus-visible** `P0` — keyboard focus invisible (or removed).
- **FLS-X-04 Fixed width / no breakpoints** `P0` `⚙` — no `LayoutBuilder`/`MediaQuery.sizeOf`;
  horizontal overflow at 320px.
- **FLS-X-05 Non-adaptive navigation** `P1` — `NavigationBar` on a wide window.
- **FLS-X-06 Portrait lock** `P0` `⚙` — `SystemChrome.setPreferredOrientations`.
- **FLS-X-07 Unselectable text / hidden scrollbars on web** `P1` `⚙`.

---

## J. Code that produces generic UI

These are structural smells that reliably produce a generic result even when the styling is
fine.

### FLS-CD-01 — Raw visual values in `build` `P0` `⚙`
Colors, sizes, radii, durations hardcoded. **Fix** tokens via `ThemeExtension`.

### FLS-CD-02 — No token layer `P0` — `ThemeData` with a seed and nothing else; per-widget
styling. **Fix** an `AppTokens` extension + component themes.

### FLS-CD-03 — State handled with booleans `P1` — `bool isLoading; bool hasError;` tri-states.
**Fix** a sealed state type (see FLS-CM-02).

### FLS-CD-04 — Duplicate components `P1` `👁` — `ButtonNew`, `BetterCard`, a second
`PrimaryButton`. **Fix** one canonical component per role; extend with a named variant when the
difference repeats and means something.

### FLS-CD-05 — Conditional theming in widgets `P1` — `if (isDark) color = ...` in `build`.
**Fix** resolve from `Theme.of`; let the theme switch animate.

### FLS-CD-06 — Strings inline in widgets `P1` — copy hardcoded and untranslatable. **Fix**
centralize copy; prepare for i18n/RTL.

### FLS-CD-07 — Missing `const` / builder lists `P2` `⚙` — rebuild churn reads as jank, which
reads as unfinished. **Fix** `const` constructors, `ListView.builder`.

### FLS-CD-08 — `shrinkWrap: true` nested lists `P2` `⚙` — a common generated pattern that also
costs performance. **Fix** slivers or a single scroll view with a proper delegate.

---

## Detectors

The `⚙` subset is implemented for Dart/Flutter by **`packages/lx_slop_lint`**, an official Dart
analyzer plugin (`analysis_server_plugin`), using the **universal rule names** from
`slop-taxonomy.md`:

`hardcoded_color` (FLS-CO-03) · `framework_color` (FLS-CO-02) · `default_theme` (FLS-CO-01) ·
`hardcoded_spacing` (FLS-SH-02/05) · `hardcoded_radius` (FLS-SH-01/03) · `hardcoded_font_size`
(FLS-TY-01/04) · `hardcoded_elevation` (FLS-SH-01/04) · `orientation_lock` (FLS-X-06) ·
`linear_motion` (FLS-MO-02) · `emoji_icon` (FLS-CM-06).

Suppress an intentional hit with `// ignore: <rule_name>`. Caveats: `dart analyze <folder>` misses
plugin diagnostics ([dart-lang/sdk#62710]) and `flutter analyze` may not surface them
([flutter/flutter#187999]) — prefer `dart analyze <file>` or the IDE. A dependency-free regex
fallback lives in `scripts/lx_scan.ps1` / `scripts/lx_scan.sh`; see `lx-slop-guard` for usage and
CI.

What no detector does: copy quality, layout tension, palette harmony, "soul", and everything `👁`.
The tool narrows the search; a person decides.

[dart-lang/sdk#62710]: https://github.com/dart-lang/sdk/issues/62710
[flutter/flutter#187999]: https://github.com/flutter/flutter/issues/187999
