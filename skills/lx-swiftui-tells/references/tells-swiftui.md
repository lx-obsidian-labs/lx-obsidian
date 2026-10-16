# SwiftUI tell catalog

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

Each tell: **ID — title** `severity` `⚙ code-certain | 👁 rendered`. Then **Signal** (the Swift
that gives it away), **Reads AI** (why), **Fix** (what to do). Code-certain tells are caught
by the SwiftLint custom rules in `lint/swiftui/.swiftlint.yml`. This catalog is
SwiftUI-specific; web and Flutter anti-slop lists miss most of it.

---

## A. Structure & layout

### SWS-ST-01 — The centered `VStack` screen `P0` `👁`
**Signal** The whole `body` is
`VStack(spacing: 16) { … }.frame(maxWidth: .infinity, maxHeight: .infinity)` with everything
center-aligned — the empty Xcode template stamped on real content.
**Reads AI** Vertical + horizontal centering is the lazy default when there is no hierarchy
in the brief. Every generated screen centers its stack.
**Fix** Decide the real hierarchy from the surface contract. Left-align (leading-align) with
`safeAreaInset`/`LazyVStack` and a scroll view; center only when the content genuinely
warrants it (single CTA, onboarding step).

### SWS-ST-02 — The uniform `LazyVGrid` of identical cells `P0` `👁`
**Signal**
`LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())])`
of identical tiles — same size, same padding, same icon box.
**Reads AI** Equal cells are the composition of a template; real products have one cell that
matters more.
**Fix** One asymmetry: a `GridItem(.flexible(), spacing:)` lead cell spanning two columns, a
bento with a genuinely bigger tile, or list-plus-feature. Vary the column count by size
class.

### SWS-ST-03 — Card-in-`GroupBox` nesting `P1` `👁`
**Signal** A `GroupBox` (or a `RoundedRectangle`-backed card) containing another `GroupBox`;
surfaces inside surfaces.
**Reads AI** Excessive containment is the visual signature of padding the layout to look
designed.
**Fix** A container earns its place only when it separates regions needing a visible
boundary. Flatten; use a `Divider` or a surface tone change instead.

### SWS-ST-04 — Template section skeleton `P1` `👁`
**Signal** The order is always: header → hero/stat row → 3 feature cards → testimonial
trio → CTA banner, reused across app screens.
**Reads AI** It is the web landing template stamped into an app.
**Fix** Reorder and rename for the product. Drop sections that could be deleted without
loss.

### SWS-ST-05 — Dead regions `P1` `👁`
**Signal** A section whose removal changes nothing the user needs.
**Reads AI** Generated to fill a template slot.
**Fix** The filter rule: a region stays only if it helps the user understand the situation
or complete the outcome.

### SWS-ST-06 — No size-class adaptation `P0` `👁`
**Signal** `@Environment(\.horizontalSizeClass)` never read; the same `VStack` layout at
every width; iPad just gets a stretched phone.
**Reads AI** The same screen at every size is a phone screenshot scaled up.
**Fix** Branch per region on size class: stack / stay / reorder / collapse. On iPad reach
for `NavigationSplitView` and `gridItemStyles`/columns that change with width.

### SWS-ST-07 — Broken proximity `P2` `👁`
**Signal** One `spacing:` value for the whole screen; equal gaps between title, related
rows, and unrelated sections.
**Reads AI** Generated layouts miss the gestalt law of proximity.
**Fix** Group related items with tighter spacing; let whitespace separate groups. Encode
the gap ladder in tokens.

### SWS-ST-08 — Everything in one scroll view with pinned junk `P2` `👁`
**Signal** A `ScrollView` wrapping the entire screen including the primary action, or a
`safeAreaInset` used as decoration rather than a real persistent bar.
**Reads AI** Uncertain about what deserves persistence, so everything scrolls or nothing
does.
**Fix** Decide per region: scroll content, pinned bar, or sheet. The primary action is
either always reachable or a deliberate sheet affordance.

---

## B. Color

### SWS-CO-01 — Default system tint left in place `P0` `⚙`
**Signal** No `.tint(_)` anywhere (the default *is* `Color.blue`), or an explicit
`.tint(.blue)` / `.tint(.accentColor)` on buttons, links, and icons.
**Reads AI** The iOS default blue is the statistical center of SwiftUI color taste —
SwiftUI's indigo-seed moment.
**Fix** Choose a seed from the subject's world; wire an accent from the asset catalog and
set it once (`.tint(Color.accent)` at the root). Hand-tune for dark separately.

### SWS-CO-02 — Framework color literals as UI roles `P0` `⚙`
**Signal** `.foregroundStyle(.blue)`, `Color.red` for errors-as-brand, `.gray` used as the
muted ink, `Color.orange` on badges.
**Reads AI** The system palette is the path of least resistance.
**Fix** Every role resolves from an asset-catalog color or a `Color` extension token
(`Color.ink`, `Color.inkMuted`, `Color.accent`). `.secondary`/`.tertiary` semantic
hierarchies are fine — named swatches as *roles* are not.

### SWS-CO-03 — Raw component colors in view code `P0` `⚙`
**Signal** `Color(red: 0.11, green: 0.10, blue: 0.09)` or a `Color(hex:)` helper called
inside `body`. (Ignored inside token/theme files by the lint config.)
**Reads AI** A token system was not used; values were invented per view.
**Fix** Define semantic roles once in the asset catalog + `Color` extensions; reference the
token.

### SWS-CO-04 — Accent used everywhere `P0` `👁`
**Signal** The accent on buttons, icons, headings, links, borders, badges, *and*
backgrounds.
**Reads AI** A color used everywhere is used nowhere; nothing stands out.
**Fix** Cap the accent at ~2 visible uses per screen. Everything else is neutral; the
accent marks selection or the single primary action.

### SWS-CO-05 — Two-stop "trust" gradient `P0` `👁`
**Signal** `LinearGradient(colors: [.purple, .blue], startPoint: .top, endPoint: .bottom)`
as a hero/background, or a gradient `foregroundStyle` on a headline.
**Reads AI** The default decoration of generated SwiftUI.
**Fix** Flatten to a surface + intentional type. If a gradient is genuinely right, keep it
in one hue family and stop using the purple→blue pairing by reflex.

### SWS-CO-06 — Hardcoded colors instead of asset catalog (dark mode by inversion) `P1` `👁`
**Signal** `Color` literals in views with no `Color(light:dark:)` / no asset-catalog
variants; dark mode "works" because the whole screen is near-black already, or flips
crudely.
**Reads AI** Inverted or hardcoded themes look generated; dark wasn't designed.
**Fix** Asset catalog colors with light/dark variants (or `Color(uiColor:)` dynamic
providers), designed by hand: desaturate large accent areas, lift surfaces, re-check
contrast in dark.

### SWS-CO-07 — Low-contrast text `P0` `👁`
**Signal** `.foregroundStyle(.secondary)` grey-on-grey; muted ink below 4.5:1 on the
surface.
**Reads AI** Generated UIs routinely ship low contrast.
**Fix** Verify every text/background pair (≥ 4.5:1 body, ≥ 3:1 large) in both themes.
`.secondary` is only safe when the surface behind it is known.

### SWS-CO-08 — `.primary`-on-everything default chrome `P2` `👁`
**Signal** Everything text is default `.primary`/`.secondary`; no deliberate ink hierarchy
at all.
**Reads AI** Untreated system semantics read as "never decided".
**Fix** System semantic colors are a fine *starting* neutral; ink hierarchy still needs a
decision (which grays, how many steps, derived from the accent's hue).

---

## C. Typography

### SWS-TY-01 — Untouched system type `P0` `👁`
**Signal** Only `.font(.body)` / `.headline` / `.title` defaults, no `.fontWeight` beyond
system, hierarchy by default sizes alone.
**Reads AI** The framework's default type is the plainest possible choice.
**Fix** Choose a family deliberately (or a *reasoned* SF Pro treatment: weight contrast,
optical sizing, tracking), set a scale with real contrast, wire it once in a `Font`
extension / environment key.

### SWS-TY-02 — Reflex font choice `P1` `⚙`
**Signal** `.font(.custom("Inter", size:))`, "Poppins", "Space Grotesk", "SF Pro Rounded"
by reflex.
**Reads AI** The known overused generated faces; avoiding one defaults to the next.
**Fix** Pick a face nobody in the category uses, paired with a plain workhorse. State the
reason.

### SWS-TY-03 — One-word accent in a headline `P1` `👁`
**Signal** `Text("Design that ") + Text("transforms").foregroundStyle(Color.accent)` — one
word bold/colored/italic in every heading.
**Reads AI** Named as a top typographic tell.
**Fix** Let the whole line carry emphasis through size/weight/space, or set the accent as a
genuinely different element with a reason.

### SWS-TY-04 — Weak hierarchy (three near-equal sizes) `P0` `👁`
**Signal** `.system(size: 22)` / `20` / `18` for title/subtitle/body (often via
`.system(size:)` literals).
**Reads AI** Mush. Contrast in size is what creates hierarchy.
**Fix** Make the largest type genuinely large and the body genuinely readable; the gap is
the hierarchy. Tighten tracking on display sizes with `kerning:`/`tracking()`.

### SWS-TY-05 — Hardcoded `.system(size:)` `P0` `⚙`
**Signal** `.font(.system(size: 17))`, `.font(.system(size: 13, weight: .medium))` ad hoc
down the file.
**Reads AI** No type system; each size was invented, and fixed point sizes bypass Dynamic
Type.
**Fix** A token type scale (`Font.appTitle`, `Font.appBody` …) built on text styles or
scalable custom fonts; never a raw point size in a view.

### SWS-TY-06 — Dynamic Type ignored `P0` `👁`
**Signal** Fixed `.frame(height:)` on text rows; `.lineLimit(1)` everywhere; sizes that
clip at accessibility text sizes; no `@ScaledMetric`/`@Environment(\.dynamicTypeSize)`
checks.
**Reads AI** Generated layouts assume the default text size forever.
**Fix** Let rows grow; use `@ScaledMetric` for non-text sizes that must track type; test at
`.accessibility3`; reserve `.lineLimit` for genuinely truncating chrome.

### SWS-TY-07 — `.font(.custom(...))` without scaling `P1` `👁`
**Signal** `Font.custom("Brand", size: 28)` with a fixed size — the font doesn't respond to
Dynamic Type.
**Reads AI** Custom type wired like a bitmap.
**Fix** Use `Font.custom(_:size:relativeTo:)` (or the design-relative initializer) so the
font participates in Dynamic Type; provide weights that match the system's.

### SWS-TY-08 — Non-tabular figures `P2` `👁`
**Signal** Prices, timers, or stats in a proportional face that jitter as digits change.
**Reads AI** Generated data UI shimmies as values update.
**Fix** `.monospacedDigit()` on any figure that updates or aligns in a column.

### SWS-TY-09 — ALL-CAPS tracked eyebrow above every heading `P1` `👁`
**Signal** `.textCase(.uppercase)` + `.tracking(2)` on a small label repeated above each
section.
**Reads AI** Template chrome that appears regardless of subject.
**Fix** Use a real heading, normal prose, or nothing. One is a choice; above every section
is a pattern.

---

## D. Space, shape, elevation

### SWS-SH-01 — One radius + one shadow under every surface `P0` `⚙`
**Signal** `RoundedRectangle(cornerRadius: 12)` (or `.clipShape(RoundedRectangle(cornerRadius: 12))`)
plus `.shadow(radius: 4)` on every card/container.
**Reads AI** The SaaS-card kit: identical rounded cards, one soft shadow, no hierarchy.
**Fix** A radius ladder (control / surface / pill) and an elevation ladder — or no
elevation at all; use borders and tonal surfaces for most separation. Reserve shadow for
real layering (sheets, menus, floating elements).

### SWS-SH-02 — Magic-number spacing `P0` `⚙`
**Signal** `.padding(16)`, `.padding(24)`, `.spacing(8)` literals chosen ad hoc down the
file; `.padding()` (system default) mixed with random numbers.
**Reads AI** No spacing system; each gap was invented.
**Fix** One named scale (base 4 or 8) as `CGFloat` tokens (`\.spaceMd` via environment or
static extensions); reference by role, not by number.

### SWS-SH-03 — One `cornerRadius` everywhere `P1` `⚙`
**Signal** Every control, surface, image, and pill at `cornerRadius: 12` regardless of
size.
**Reads AI** Collapses component hierarchy.
**Fix** A radius ladder applied by role; small controls get small radii, pills get
`.capsule`/`.circle`.

### SWS-SH-04 — Shadow on flat surfaces `P1` `👁`
**Signal** `.shadow(color: .black.opacity(0.15), radius: 8, y: 2)` on elements that aren't
raised over anything.
**Reads AI** Decoration without a role; the cheap-depth reflex.
**Fix** Elevation indicates real layering (a menu over content, a card over a scroll
surface). Flat content gets borders or tone, not shadow.

### SWS-SH-05 — Uniform `.padding()` by reflex `P1` `⚙`
**Signal** The same padding on rows, cards, headers, and sheets; `.padding(.horizontal)`
+ `.padding(.vertical)` everywhere at identical values.
**Reads AI** Padding applied by reflex rather than by role.
**Fix** Vary by role: tight rows (8), component padding (12), section (24), page gutters
(16–24, responsive).

### SWS-SH-06 — Oversized radius on small controls `P2` `👁`
**Signal** `cornerRadius: 24`+ on chips, small buttons, thumbnails.
**Reads AI** The "friendly AI startup" squircle reflex.
**Fix** Match radius to element size; a 28pt chip does not want a 24pt radius.

### SWS-SH-07 — Colored leading border on cards `P1` `👁`
**Signal** `.overlay(RoundedRectangle(...).stroke(Color.accent, lineWidth: 4).mask(LeadingHalf))`
or a leading `Rectangle().fill(Color.accent).frame(width: 4)` on otherwise plain cards,
repeated.
**Reads AI** The canonical "AI dashboard tile" shape.
**Fix** Convey status another way — a dot, a label, a tint — or drop either the radius or
the colored border.

---

## E. Components & states

### SWS-CM-01 — Happy path only `P0` `👁`
**Signal** No loading/empty/error/no-results/disabled states; the view assumes data and
connectivity.
**Reads AI** Generated screens assume the happy path.
**Fix** Encode states as an enum the compiler forces you to handle:
```swift
enum Loadable<T> { case idle, loading, empty(String), failed(String, retry: () -> Void), ready(T) }
```
Render each with the **same** frame and tokens.

### SWS-CM-02 — Spinner-only loading `P1` `👁`
**Signal** `ProgressView()` centered in a `VStack` as the sole loading affordance.
**Reads AI** It says nothing about what is loading.
**Fix** Skeletons that preserve the final layout (so nothing jumps), or a progress model
that shows what is pending. A spinner only for genuinely indeterminate, short waits.

### SWS-CM-03 — Identical feature cards `P1` `👁`
**Signal** 3–4 cards: `Image(systemName:)` in a tinted rounded rect, bold title, two lines
of blurb — same everywhere.
**Reads AI** The most recognizable generated block in SwiftUI.
**Fix** Prose, a table, or a genuinely asymmetric layout. If cards are right, make them
differ where the content differs.

### SWS-CM-04 — SF Symbol in a tinted rounded rectangle `P1` `⚙`
**Signal**
`Image(systemName: "star.fill").foregroundStyle(.blue).padding().background(RoundedRectangle(cornerRadius: 12).fill(.blue.opacity(0.1)))`
repeated per feature.
**Reads AI** Decorative containment with no role; the SwiftUI port of the icon-box kit.
**Fix** Use the symbol plainly, or drop it. Icons should improve recognition, not fill a
box.

### SWS-CM-05 — Emoji as icons `P0` `👁`
**Signal** `Text("✨")` / `Text("🚀")` / `Text("🎯")` where an icon belongs, or as bullets.
**Reads AI** Emoji standing in for a real icon set reads generated.
**Fix** An SF Symbol set (consistent weight/family) or nothing. Reserve emoji for copy
where the product's voice actually uses them.

### SWS-CM-06 — Default `NavigationStack` / large-title chrome everywhere `P1` `👁`
**Signal** Every route wrapped in `NavigationStack { List { … } }` with the stock large
title, default toolbar, and `.navigationBarTitleDisplayMode(.large)`.
**Reads AI** Default chrome that ignores the product and the platform.
**Fix** Choose the navigation treatment per surface: `.searchable` where search is real,
compact titles on iPhone, `.navigationSplitView` on iPad/Mac, custom toolbar content only
where it earns it.

### SWS-CM-07 — Untouched `List` look everywhere `P1` `👁`
**Signal** `List`/`Form` with default insets, `.listStyle(.insetGrouped)` untouched, every
screen a settings-style list.
**Reads AI** The Xcode template's screen, multiplied.
**Fix** Lists are right for settings and inventories; content surfaces deserve composition.
If a list is right, style row insets, separators, and section headers deliberately.

### SWS-CM-08 — `TabView` for everything `P1` `👁`
**Signal** A `TabView` with 4–5 generic tabs ("Home", "Explore", "Profile", "Settings",
"More") on a product that has one job.
**Reads AI** The default app skeleton regardless of the product's actual shape.
**Fix** Tabs for genuinely parallel top-level jobs, named in the product's vocabulary. Fewer
tabs, each earning its place.

### SWS-CM-09 — Stock CTA pair `P1` `👁`
**Signal** "Get Started" / "Learn More" (or "Continue" / "Skip") as the primary/secondary
pair on onboarding or a paywall.
**Reads AI** Generic labels that could serve any product.
**Fix** Name the actual action. One primary action per surface; the secondary is a
genuinely different path, not a filler pair.

### SWS-CM-10 — Buttons with no pressed style `P1` `👁`
**Signal** `Button("Save") { … }` with no `.buttonStyle(.borderedProminent)` (or custom)
and no pressed/`isPressed` feedback — a flat tap target that looks dead.
**Reads AI** Untreated default button, and no affordance; reads unfinished.
**Fix** A deliberate button style per role with a visible pressed state (scale, opacity,
fill change) and a disabled state that says why.

### SWS-CM-11 — No disabled/blame explanation `P1` `👁`
**Signal** `.disabled(!isValid)` with no reason shown; an error view that says "Something
went wrong" with no retry.
**Reads AI** Generated happy paths ignore why something is unavailable.
**Fix** Disabled states say why; errors say what failed, what is safe, and how to recover.

---

## F. Motion

### SWS-MO-01 — `.animation(.default)` / no explicit curve `P1` `⚙`
**Signal** `.animation(.default, value:)` or implicit animation with the default ease.
**Reads AI** Mechanical, unconsidered motion.
**Fix** Explicit curves as tokens: ease-out for entrances, ease-in for exits, `.spring()`
for drag and interactive transitions.

### SWS-MO-02 — `.easeInOut` with no reason `P2` `👁`
**Signal** `.easeInOut(duration: 0.3)` sprinkled on every state change because it is the
first curve in autocomplete.
**Reads AI** A curve chosen by reflex, not by job.
**Fix** Ask what the motion is doing (showing a state change, directing attention,
rewarding an interaction), then pick the curve that does that job.

### SWS-MO-03 — Animation on every appear `P1` `👁`
**Signal** `.onAppear { withAnimation { appeared = true } }` driving a fade/slide on every
view; every section enters identically.
**Reads AI** The uniform-entrance tell; a single orchestrated moment lands better.
**Fix** One orchestrated page-load sequence; nothing else auto-moves. Motion answers
actions.

### SWS-MO-04 — Content gated on opacity/scroll reveal `P0` `👁`
**Signal** Sections with `.opacity(showed ? 1 : 0)` until a scroll offset or appear flag
fires; blank in a static screenshot.
**Reads AI** The static capture is blank; also fails users who don't scroll.
**Fix** Content present by default; animate deliberately, not as a gate.

### SWS-MO-05 — `accessibilityReduceMotion` ignored `P1` `👁`
**Signal** Animations and transitions with no
`@Environment(\.accessibilityReduceMotion)` check.
**Reads AI** Motion that ignores accessibility is both a tell and a bug.
**Fix** Honor reduce-motion: jump to final states, keep the flow usable.

### SWS-MO-06 — One duration for everything `P2` `⚙`
**Signal** Every animation `duration: 0.3` (or 0.25) regardless of distance and element.
**Reads AI** No motion system.
**Fix** A small fast/base/slow scale mapped to element size and travel distance.

### SWS-MO-07 — `.transition(.move(edge:))` with no meaning `P2` `👁`
**Signal** Sheets and pushes with default (or reflex `.move(edge: .bottom)`) transitions
applied to content that isn't arriving from anywhere meaningful.
**Reads AI** Motion without a job.
**Fix** Transitions should encode where the element came from; use the default push/sheet
mechanics unless the spatial metaphor is real.

---

## G. Copy

### SWS-CP-01 — Filler / unfalsifiable copy `P0` `👁`
**Signal** `"Lorem ipsum"`, `"Item 1"`, `"Sample"`, `"Get Started"`, "10× faster" with no
source, in `Text(...)` literals.
**Reads AI** The single strongest tell; nothing to do with SwiftUI.
**Fix** Real nouns, numbers, dates, lengths. If a metric isn't real, label it as a
placeholder or leave it out.

### SWS-CP-02 — Category slogans `P1` `👁`
**Signal** "Unlock", "Supercharge", "Seamless", "Elevate", "Effortless", "Next-generation".
**Reads AI** Words that describe a category rather than a product.
**Fix** A claim only this product can make, ideally with a number.

### SWS-CP-03 — "It's not X, it's Y" reframe `P1` `👁`
**Signal** "It's not X. It's Y." / "X, not Y." / "More than just X."
**Reads AI** The UI version of a known writing tell.
**Fix** State the thing directly.

### SWS-CP-04 — Choppy fragments as design device `P2` `👁`
**Signal** Headlines of 3–6 words stacked as separate `Text` views.
**Reads AI** Reads generated even with custom styling.
**Fix** Fewer headlines, more specific prose.

### SWS-CP-05 — Verb drift in flows `P1` `👁`
**Signal** Button says "Submit", alert says "Saved", heading says "Success!".
**Reads AI** No one owned the vocabulary.
**Fix** An action keeps its name through the flow: "Publish" → "Published". Active voice.

### SWS-CP-06 — Generic error/empty copy `P1` `👁`
**Signal** "Something went wrong." / "No data." in an `ContentUnavailableView` label.
**Reads AI** Errors that apologize or stay vague.
**Fix** Say what failed, what is safe, how to recover. Empty states invite the next action.

### SWS-CP-07 — Stock persona testimonials `P1` `👁`
**Signal** Three five-star quotes, initial-only avatars, "Sarah Chen", one persona per
continent.
**Reads AI** The clearest testimonial tell.
**Fix** Real testimonials or none.

---

## H. Second-order defaults (the "tasteful" traps)

The escapes that became the new median. Legitimate for some briefs; tells when they appear
regardless of subject.

### SWS-SD-01 — Cream + terracotta `P1` `👁`
Warm cream background (~#F4F1EA), high-contrast serif display, clay accent (~#D97757 —
Anthropic's own interaction accent). **Fix** Only if the brief asked for warmth; otherwise
derive the neutral family from this product's subject.

### SWS-SD-02 — Acid-on-black `P1` `👁`
Near-black background with a single bright acid-green or vermilion accent. **Fix**
Legitimate for some brands; a default otherwise.

### SWS-SD-03 — All-glass `.ultraThinMaterial` `P1` `👁`
`.ultraThinMaterial` / `.regularMaterial` bars, cards, and toolbars everywhere, over
content that isn't meaningful enough to blur. **Fix** Material must indicate real layering
over content worth seeing; one place, or none.

### SWS-SD-04 — Neubrutalism `P1` `👁`
Hard black borders, offset `.shadow(radius: 0, x: 4, y: 4)` blocks, mono, on every element.
**Fix** A style, not a system, when applied uniformly; keep it disciplined and rare.

### SWS-SD-05 — The untouched form/List look `P1` `👁`
Default `Form` styling as the app's entire visual identity — inset grouped rows, system
chevrons, stock headers. **Fix** Settings-shaped screens earn it; product surfaces
don't. Style deliberately or re-compose.

### SWS-SD-06 — Template micro-chrome `P1` `👁`
Tracked ALL-CAPS eyebrow above every heading; middot meta ("A · B · C"); "→" appended to
every button; mono for small labels "to look technical". **Fix** Real headings and plain
labels; reserve these devices for the few places they mean something.

---

## I. Platform honesty

Full treatment in `lx-cross-platform`. The SwiftUI-specific quick tells:

- **SWS-X-01 iPhone-only fixed layout** `P0` — no `horizontalSizeClass`, no
  `NavigationSplitView`, no column changes; a phone layout on iPad and Mac. **Fix** branch
  per region; verify on an iPad and a Mac window.
- **SWS-X-02 Fixed `.frame(width:)`** `P0` `⚙` — `.frame(width: 320)`/`width: 375` on
  containers instead of flexible layout. **Fix** flexible frames + `ViewThatFits` /
  size-class branches.
- **SWS-X-03 Tiny tap targets** `P0` — interactive elements below 44×44pt (icon-only
  `Button`s with bare `Image(systemName:)`). **Fix** minimum 44pt targets; `.contentShape`
  + padding on icon buttons.
- **SWS-X-04 Orientation assumptions** `P1` — layouts that only compose in portrait;
  `.persistentSystemOverlays`/safe-area mistakes in landscape. **Fix** support both
  orientations; test landscape on iPhone and iPad.
- **SWS-X-05 No keyboard avoidance** `P1` — text fields covered by the keyboard; no
  `scrollDismissesKeyboard`, no focus-driven scroll. **Fix** scroll containers under
  fields, `@FocusState`-driven scrolling, `.scrollDismissesKeyboard(.interactively)`.
- **SWS-X-06 macOS ignored** `P1` — no `.commands`, no `Menu`-bar extras, default window
  sizing, iOS-style modals on a Mac. **Fix** a real `CommandGroup`, keyboard shortcuts on
  buttons, Mac-native sheets and sizing.
- **SWS-X-07 VoiceOver labels missing** `P0` — icon-only buttons with no
  `.accessibilityLabel`, images without descriptions, decorative text read aloud. **Fix**
  label/adjust/hint on every interactive and informative element; order tested.

---

## J. Code that produces generic UI

Structural smells that reliably produce a generic result even when the styling is fine.

### SWS-CD-01 — Raw `Color(red:...)` in views `P0` `⚙`
Colors invented per view in the render path. **Fix** asset catalog + `Color` extensions.

### SWS-CD-02 — No token layer `P0` `👁`
No asset catalog roles, no `Font`/`CGFloat` token extensions, no environment keys — values
scattered through bodies. **Fix** one token set (`Color.ink`, `Font.appBody`,
`\.spaceMd`) consumed by everything. See `framework-adapters.md`.

### SWS-CD-03 — Boolean state soup `P1` `👁`
`@State var isLoading = false; @State var hasError = false;` — combinatorial tri-states.
**Fix** a single `Loadable<T>`/`enum` state the compiler forces you to handle (SWS-CM-01).

### SWS-CD-04 — Duplicate views `P1` `👁`
`PrimaryButton2`, `BetterCard`, a second `ProfileHeader` — copies that drifted. **Fix** one
canonical component per role; a named variant when the difference repeats and means
something.

### SWS-CD-05 — Strings inline in views `P1` `👁`
`Text("Save changes")` literals everywhere; no `Localizable.xcstrings`, no `String(local:)`.
**Fix** centralized copy via string catalog; prepares you for i18n and RTL.

### SWS-CD-06 — `.frame(height:)` instead of Dynamic Type `P1` `⚙`
Fixed heights on text-bearing rows to control layout. **Fix** intrinsic sizing + scaled
metrics; fixed frames only for genuinely fixed chrome.

### SWS-CD-07 — `ForEach` over large unvirtualized data `P1` `👁`
`ForEach(items) { Row($0) }` inside a `VStack`/`ScrollView` for hundreds of rows — no
lazy container, so the whole list builds. **Fix** `LazyVStack`/`LazyHStack`/`List` inside
scroll views; identity via stable `id:`.

### SWS-CD-08 — Conditional theming in views `P2` `👁`
`if colorScheme == .dark { … } else { … }` sprinkled through bodies. **Fix** resolve from
asset-catalog dynamic colors / environment tokens; let the theme switch for free.

---

## Detectors

The `⚙` subset of this catalog is implemented as **SwiftLint custom rules** in
`lint/swiftui/.swiftlint.yml`. Run:

```powershell
swiftlint lint --config lint/swiftui/.swiftlint.yml
```

**Honest about the limits:** SwiftLint exposes no third-party AST API, so these rules are
**regex-based** and therefore *heuristic*. They will over-trigger on legitimate code (a
design-system token file, a chart canvas, an intentionally gradient-heavy brand) and
under-trigger on sneaky spellings. That is why:

- token/theme files (`AppTheme`, `Assets`, `Design`, `Tokens`…) are in the config's
  `excluded` list;
- every rule is severity-ranked, and the gate is **regressions**, not absolute zero;
- suppress intentional hits with `// swiftlint:disable:next <rule>` and a short reason;
- everything `👁` — copy, layout tension, palette harmony, "soul" — stays human.

Rule names map to the universal rule names in `lx-obsidian`'s `slop-taxonomy.md`, so
`lx_slop_hardcoded_color` reads the same as Flutter's `hardcoded_color` and the ESLint
`lx-slop/hardcoded-color`: one vocabulary across stacks. The tool narrows the search; a
person decides.
