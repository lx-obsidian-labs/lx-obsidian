# Jetpack Compose tell catalog

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

## How to read this file

Each tell: **ID — title** `severity` `⚙ code-certain | 👁 rendered`. Then **Signal** (the
Kotlin/Compose that gives it away), **Reads AI** (why), **Fix** (what to do). Code-certain
tells are what the detekt ruleset in `lint/compose/` targets. This catalog is
Compose-specific; web and Flutter anti-slop lists miss most of it.

---

## A. Structure & layout

### CMP-ST-01 — The centered column screen `P0` `⚙`
**Signal** `Column(Modifier.fillMaxSize().padding(16.dp), horizontalAlignment = Alignment.CenterHorizontally, verticalArrangement = Arrangement.Center)` as the whole `Scaffold` content.
**Reads AI** Vertical centering is the lazy default when there is no content hierarchy. Every
generated screen centers its stack.
**Fix** Decide the real hierarchy from the surface contract. A left-aligned, scrolled
`Column`/`LazyColumn` with a deliberate header, or `Arrangement.SpaceBetween` for real
top/bottom zones. Center only when the content genuinely warrants it (sign-in, single CTA).

### CMP-ST-02 — The uniform grid of equal cards `P0` `👁`
**Signal** A `LazyVerticalGrid(GridCells.Fixed(2))` of identical cards: same size, same
`16.dp` padding, same tinted `Box` icon, same two-line title.
**Reads AI** Equal cells are the composition of a template; real products have one cell that
matters more.
**Fix** Introduce one asymmetry: `GridCells.Adaptive`, a lead card spanning two cells
(`SpanSizeSpan`), or a list-plus-feature. Vary what the content earns, not decoration.

### CMP-ST-03 — Template section skeleton `P1` `👁`
**Signal** The order is always: `TopAppBar` → hero/stat row → 3 feature cards → "testimonials"
→ CTA banner. Reused across app screens.
**Reads AI** It is the web landing template stamped into an `Activity`.
**Fix** Reorder and rename for the product. Drop sections that could be deleted without loss.

### CMP-ST-04 — Card-in-card nesting `P1` `👁`
**Signal** A `Card` containing a `Card`, or an `ElevatedCard` inside a decorated `Box` inside
another elevated surface.
**Reads AI** Excessive containment is the visual signature of padding the layout to look
designed.
**Fix** A surface earns its place only when it separates regions needing a visible boundary.
Flatten; use a `HorizontalDivider` or a tonal surface change instead.

### CMP-ST-05 — Dead regions `P1` `👁`
**Signal** A section whose removal changes nothing the user needs (a stats row on a settings
screen, a "features" strip on a detail screen).
**Reads AI** Generated to fill a template slot.
**Fix** Apply the filter: a region stays only if it helps the user understand the situation
or complete the outcome.

### CMP-ST-06 — No window-size adaptation `P0` `👁`
**Signal** `WindowSizeClass` never computed (`currentWindowAdaptiveInfo` /
`calculateWindowSizeClass` absent); one layout at every width; no `resource` qualifier
folders; `NavigationSuiteScaffold` unused.
**Reads AI** The same screen on a tablet and a foldable is a phone screenshot scaled up.
**Fix** Branch per region on window size (stay / stack / reorder / collapse / scroll / drawer /
disappear). Compute the window size class once at the root and pass real booleans or an enum
down.

### CMP-ST-07 — Broken proximity `P2` `👁`
**Signal** Equal `16.dp` gaps between every element; titles, metadata, and controls share one
rhythm; `Arrangement.spacedBy(16.dp)` applied to a whole screen.
**Reads AI** Generated layouts miss the gestalt law of proximity; nothing groups.
**Fix** Tighter spacing inside a group (4–8.dp), whitespace between groups (24–32.dp). The
gap carries meaning; one constant carries none.

---

## B. Color

### CMP-CO-01 — Default `MaterialTheme` / dynamic color treated as the design `P0` `⚙`
**Signal** `MaterialTheme(colorScheme = dynamicColorScheme(LocalContext.current)) { … }` as
the app shell, or `lightColorScheme(primary = Purple40, secondary = PurpleGrey40)` — the
Android Studio template values — shipped as the palette.
**Reads AI** Dynamic color is the *user's* wallpaper taste, not the product's; the template
purples are the framework's own defaults. Neither is a brand decision.
**Fix** Author a scheme from a seed in the subject's world (`lightColorScheme(primary = …,
surface = …, onSurface = …)` tuned by hand), or accept dynamic color *and* ship a branded
fallback plus real component customization. The brief picks, not the wizard.

### CMP-CO-02 — Raw color literals in composables `P0` `⚙`
**Signal** `Color(0xFF1A1A1A)` / `Color(0xFFECEFF1)` inside a `@Composable`'s body or its
modifier chain.
**Reads AI** A token system was not used; a hex was invented per widget.
**Fix** Define semantic roles once (`MaterialTheme.colorScheme.*` or a token object) and
reference them. Literals belong in exactly one file — the scheme/tokens definition.
(Ignored by the ruleset inside theme/token files.)

### CMP-CO-03 — Framework swatch colors for UI roles `P0` `⚙`
**Signal** `Color.Blue`, `Color.Gray`, `Color.Red`, `Color.Green` used for status, icons,
accents.
**Reads AI** Kotlin's named constants are the path of least resistance, and they read as
placeholder-wireframe.
**Fix** Every role resolves from `colorScheme` or tokens: `colorScheme.primary`,
`colorScheme.error`, or your own `success`/`warning` roles. `Color.Transparent` is allowed.

### CMP-CO-04 — Accent used everywhere `P0` `👁`
**Signal** `MaterialTheme.colorScheme.primary` on buttons, icons, headings, links, borders,
badges, *and* `Box` backgrounds — three-plus visible uses per screen.
**Reads AI** A color used everywhere is used nowhere; nothing stands out.
**Fix** Cap the accent at ~2 visible uses per screen: the primary action and selection. The
rest is neutral.

### CMP-CO-05 — Two-stop "trust" gradient `P0` `⚙`
**Signal** `Brush.linearGradient(listOf(Color(0xFF6200EE), Color(0xFF03DAC6)))` /
`purple → blue` as a hero background, button fill, or `ShaderMask` on text.
**Reads AI** The default decoration of generated UI — Android's own marketing gradient,
reused with no reason.
**Fix** Flatten to a surface + intentional type. If a gradient is genuinely right, keep it in
one hue family with texture so it doesn't band.

### CMP-CO-06 — Low-contrast `onSurfaceVariant` text `P0` `👁`
**Signal** Body text in `colorScheme.onSurfaceVariant` (or a grey literal) over
`surfaceVariant`/`surface` at a measured ratio below 4.5:1; helper text that fails in dark.
**Reads AI** Generated UIs routinely ship muted ink that fails AA — the most common Compose
accessibility error after missing content descriptions.
**Fix** Verify every text/background pair (≥ 4.5:1 body, ≥ 3:1 large and icons) in light
*and* dark. Prefer `onSurface` for body; `onSurfaceVariant` for genuinely secondary text at
adequate contrast.

### CMP-CO-07 — Dark mode by inversion `P1` `👁`
**Signal** `darkColorScheme()` that is the light scheme with `surface ↔ onSurface` swapped;
saturated `primary` kept at full chroma on near-black.
**Reads AI** Inverted light themes look generated; they weren't designed for dark.
**Fix** Design dark by hand: desaturate large accent areas, lift surfaces a few percent,
re-check every contrast pair in dark specifically.

### CMP-CO-08 — Neutrals unrelated to the accent `P1` `👁`
**Signal** Stock M3 grey tonal palette (or `Color(0xFFF5F5F5)`) sitting beside an accent it
was never derived from.
**Reads AI** The neutrals weren't chosen, so they read default.
**Fix** Derive neutrals from the accent's hue at low chroma; the greys then read as chosen.

---

## C. Typography

### CMP-TY-01 — Untouched `MaterialTheme.typography` `P0` `⚙`
**Signal** `MaterialTheme(colorScheme = …) { … }` with no `typography =` argument; default
Roboto (`FontFamily.Default`) at M3 default sizes.
**Reads AI** The framework's default type is the plainest possible choice.
**Fix** Choose a family deliberately, set a scale with real contrast, wire it once:
`MaterialTheme(typography = AppTypography)`. Test at 1.3× font scale.

### CMP-TY-02 — Reflex font choice `P1` `⚙`
**Signal** `FontFamily(Font(R.font.inter))`, `FontFamily.Monospace` used "to look technical",
or the same three faces every generated app reaches for (Inter, Space Grotesk, Geist).
**Reads AI** These are the overused generated faces; avoiding one now means the model reaches
for the next.
**Fix** Pick a face nobody in the category uses, paired with a plain workhorse. State the
reason.

### CMP-TY-03 — Weak hierarchy (three near-equal sizes) `P0` `👁`
**Signal** `fontSize = 24.sp`, `22.sp`, `20.sp` for title/subtitle/body in one screen's
styles.
**Reads AI** Mush. Contrast in size is what creates hierarchy.
**Fix** Make the display genuinely large and the body genuinely readable; the gap *is* the
hierarchy. Tighten tracking on display sizes (`letterSpacing = (-0.5).sp`).

### CMP-TY-04 — Hardcoded font sizes `P0` `⚙`
**Signal** `fontSize = 18.sp` inline in a `TextStyle(...)` inside a composable, repeated
per-text rather than resolved from the type scale.
**Reads AI** No type system; each size was invented at the call site.
**Fix** Resolve every style from `MaterialTheme.typography.*` (or a token scale). One place
defines the scale; the render path only references it.

### CMP-TY-05 — One-word accent in a headline `P1` `👁`
**Signal** A `BuildAnnotatedString` where one word is `ColorStyle`-colored or bolded — the
headline "One place for **everything**".
**Reads AI** Named as a top typographic tell; it appears regardless of subject.
**Fix** Let the whole line carry emphasis through size/weight/space, or make the accent word
a genuinely different element with a reason.

### CMP-TY-06 — Non-tabular figures `P2` `⚙`
**Signal** Prices, durations, or counts that change or align rendered in the default
proportional face; rows jitter as values update.
**Reads AI** Generated data UI wiggles.
**Fix** `fontFeatureSettings = "tnum"` on any figure that updates or aligns in a column.

### CMP-TY-07 — Font scaling ignored `P1` `👁`
**Signal** `fontSize` in a `TextUnit` built from `dp` (`with(LocalDensity.current) { 18.dp.toSp() }`
misused), `Modifier.height(48.dp)` on text containers, fixed-height rows that clip at the
system's 1.3–2.0× font scale.
**Reads AI** Generated layouts assume 100% font scale forever; this is an accessibility bug
and a tell.
**Fix** `sp` for all type; no absolute heights on text containers; test 130–200% font scale
(`fontScale` in the Preview parameter or `CompositionLocalProvider(LocalDensity provides …)`).

---

## D. Space, shape, elevation

### CMP-SH-01 — Magic-number spacing everywhere `P0` `⚙`
**Signal** `Modifier.padding(16.dp)`, `Spacer(Modifier.height(24.dp))`, `size(8.dp)` chosen
ad hoc down the file.
**Reads AI** No spacing system; each gap was invented at the keyboard.
**Fix** One named scale (base 4 or 8): `AppTokens.spaceMd`, or at minimum `MaterialTheme`
spacing constants. Reference by role, not by number.

### CMP-SH-02 — One radius for everything `P1` `⚙`
**Signal** `RoundedCornerShape(8.dp)` (or `12.dp`) on cards, buttons, chips, dialogs, and
badges alike — sometimes via a single `AppShapes` copied from the template.
**Reads AI** The SaaS-card kit in Kotlin: identical soft corners collapse the component
hierarchy.
**Fix** A radius ladder applied by role — small controls, surfaces, pills. M3's shape scale
is fine if you actually differentiate; a single constant is not.

### CMP-SH-03 — One elevation under every surface `P0` `⚙`
**Signal** `Card(elevation = CardDefaults.cardElevation(4.dp))` everywhere, or
`Modifier.shadow(4.dp)` repeated on rows, headers, and sheets.
**Reads AI** Identical shadow, no hierarchy — the canonical generated dashboard.
**Fix** An elevation ladder, or none: tonal surfaces + hairline borders for most separation;
shadow only for real layering (menus, FAB over content).

### CMP-SH-04 — Shadow on flat surfaces `P1` `👁`
**Signal** `Modifier.shadow(...)` / `graphicsLayer { shadowElevation = … }` on elements that
aren't raised above anything.
**Reads AI** Decoration without a role; Compose draws it as a floating grey blob.
**Fix** Elevation indicates real stacking. Flat content gets borders or tone, not shadow.

### CMP-SH-05 — Uniform padding by reflex `P1` `⚙`
**Signal** The same `16.dp` on cards, list rows, `TopAppBar` content, and dialogs.
**Reads AI** Padding applied by reflex rather than by role.
**Fix** Vary by role: tight rows (8), component padding (12), section (24), page gutters
(16–24, adaptive).

---

## E. Components & states

### CMP-CM-01 — Happy path only `P0` `👁`
**Signal** No empty, loading, no-results, error, disabled, or permission states in the
composable or its previews.
**Reads AI** Generated screens assume data is present and the network is up.
**Fix** Encode states as a sealed type so the compiler forces handling:
```kotlin
sealed interface UiState<out T> {
    data object Loading : UiState<Nothing>
    data class Empty(val reason: String) : UiState<Nothing>
    data class Data<T>(val value: T) : UiState<T>
    data class Failure(val message: String, val recover: () -> Unit) : UiState<Nothing>
}
```
Render each in the **same** frame and tokens. `when (state)` with no `else` keeps it honest.

### CMP-CM-02 — Spinner-only loading `P1` `⚙`
**Signal** `Box(Modifier.fillMaxSize(), contentAlignment = Alignment.Center) { CircularProgressIndicator() }`
as the sole loading affordance.
**Reads AI** It says nothing about what is loading.
**Fix** Skeletons that preserve the final layout (shimmer `Brush` over placeholder shapes the
size of the real content), or a progress model that shows what is pending. Spinners only for
genuinely indeterminate short waits.

### CMP-CM-03 — Identical feature cards `P1` `👁`
**Signal** 3–4 `Card`s: icon in a tinted `Box`, bold title, two lines of blurb, same weight,
same height.
**Reads AI** The most recognizable generated block in Compose, straight from the template
gallery.
**Fix** Prose, a table, or a genuinely asymmetric layout. If cards are right, make them
differ where the content differs.

### CMP-CM-04 — Icon in a tinted rounded `Box` `P1` `👁`
**Signal** `Box(Modifier.size(40.dp).background(colorScheme.primary.copy(alpha = 0.12f), RoundedCornerShape(12.dp))) { Icon(...) }`
repeated per feature/list item.
**Reads AI** Decorative containment with no role.
**Fix** Use the icon plainly (correct size, semantic `contentDescription`), or drop it.
Icons improve recognition; they don't fill boxes.

### CMP-CM-05 — Emoji as icons `P0` `⚙`
**Signal** `Text("✨")` / `Text("🚀")` / `Text("🎯")` where an `Icon` belongs, or as bullets.
**Reads AI** Emoji standing in for a real icon set reads generated — and renders differently
on every device.
**Fix** Material Icons (or one monoline set), consistent weight, with `contentDescription`.
Reserve emoji for copy where the product's voice actually uses them.

### CMP-CM-06 — Default chrome everywhere `P1` `👁`
**Signal** `Scaffold(topBar = { TopAppBar(title = { Text(title) }) })` and a
`NavigationBar` with three stock items on every route, default colors/elevation, no
`windowInsets` handling, no edge-to-edge.
**Reads AI** Default chrome that ignores the product, the platform, and the window size.
**Fix** Choose the treatment per surface: a collapsing bar where content earns it, a
`CenterAlignedTopAppBar` where symmetry means something, a `NavigationRail`/`Drawer` on wide
windows (`NavigationSuiteScaffold`), edge-to-edge with correct insets.

### CMP-CM-07 — Stock CTA pair, vanilla button `P1` `👁`
**Signal** `Button(onClick = …) { Text("Get Started") }` beside
`TextButton { Text("Learn More") }`; every button at default M3 fill, no pressed-state
design, no ripple tuned to the surface.
**Reads AI** Generic labels that could serve any product, in the generic press response.
**Fix** Name the actual action ("Publish draft", "Retry download"). One primary action per
surface; the secondary is a genuinely different path. Customize `interactionSource`/colors
only where the design earns it.

---

## F. Motion

### CMP-MO-01 — Default / linear animation specs `P1` `⚙`
**Signal** `animateDpAsState(target, label = …)` / `animateFloatAsState` with no
`animationSpec` (default tween, linear-ish), or `tween(durationMillis = 300)` chosen for
everything; `LinearEasing` explicitly.
**Reads AI** Mechanical motion reads unpolished.
**Fix** Ease-out for entrances, ease-in for exits, `spring(dampingRatio = …)` for drag and
settle. Encode specs as tokens next to the durations.

### CMP-MO-02 — `AnimatedVisibility` on every element `P1` `👁`
**Signal** Each section/card wrapped in its own `AnimatedVisibility(visible = …)` with the
same `fadeIn() + expandVertically()` spec, staggered by a constant delay.
**Reads AI** A fade-up per element is the generated entrance; it reads as decoration.
**Fix** One orchestrated load sequence for the page; after that, motion answers actions
(expand a row on tap, push a snackbar). Nothing else auto-moves.

### CMP-MO-03 — Content gated on scroll reveal `P0` `👁`
**Signal** `Modifier.alpha(0f)` until `rememberLazyListState` reaches the item, or a
`graphicsLayer { alpha = if (visible) 1f else 0f }` scroll gate on whole sections.
**Reads AI** Static captures are blank; users who don't scroll (or use TalkBack) never see
the content. Motion became a gate.
**Fix** Content present by default; animate deliberately as garnish, never as the
prerequisite for existing.

### CMP-MO-04 — Reduce-motion ignored `P1` `⚙`
**Signal** Animations running at full scale with no read of
`LocalMotionDurationScale.current` (or `ViewCompat.getAnimateDurationScale`), custom
`Animatable`s and infinite transitions with no escape.
**Reads AI** Motion that ignores the accessibility setting is both a tell and a bug.
**Fix** Honor reduce-motion: scale durations via `LocalMotionDurationScale`, or jump to
final states; keep the flow usable. Infinite loops stop.

### CMP-MO-05 — One duration for everything `P2` `⚙`
**Signal** Every `tween(durationMillis = 300)` (or 250, or 500) down the file.
**Reads AI** No motion system; the number was typed once and copied.
**Fix** A small duration scale — fast/base/slow — mapped to element size and travel distance,
defined once.

### CMP-MO-06 — Decoration motion `P2` `👁`
**Signal** `rememberInfiniteTransition` floating blobs, parallax headers with no job,
loops that run while the user reads.
**Reads AI** Motion without a job.
**Fix** Motion must show a state change, direct attention, or reward an interaction.
Otherwise cut it. At most one thing moves on its own per view.

---

## G. Copy

### CMP-CP-01 — Filler / unfalsifiable copy `P0` `⚙`
**Signal** `"Lorem ipsum"`, `"Item 1"`, `"Sample content"`, `"Get Started"`, `"10× faster"`
with no source — in `stringResource(R.string.…)` or as literals.
**Reads AI** The single strongest tell; it has nothing to do with design.
**Fix** Real nouns, numbers, dates, lengths. If a metric isn't real, label it as a
placeholder or leave it out.

### CMP-CP-02 — Category slogans `P1` `⚙`
**Signal** "Unlock", "Supercharge", "Seamless", "Elevate", "Effortless", "Next-generation",
"Leverage" in headers or empty states.
**Reads AI** Words that describe a category rather than a product.
**Fix** Replace with a claim only this product can make, ideally with a number.

### CMP-CP-03 — "It's not X, it's Y" reframe `P1` `⚙`
**Signal** "It's not a to-do list. It's a life OS." / "More than just a tracker."
**Reads AI** The UI version of a known writing tell.
**Fix** State the thing directly.

### CMP-CP-04 — Verb drift in flows `P1` `👁`
**Signal** Button says "Submit", the snackbar says "Saved", the header says "Success!".
**Reads AI** No one owned the vocabulary.
**Fix** An action keeps its name through the flow: "Publish" → "Published". Active voice.

### CMP-CP-05 — Generic error / empty copy `P1` `👁`
**Signal** `stringResource(R.string.error_generic)` → "Something went wrong." / "No data."
with a lone "Retry".
**Reads AI** Errors that apologize or stay vague.
**Fix** Say what failed, what is safe, and how to recover. Empty states are invitations to
act, in the product's voice.

### CMP-CP-06 — Stock persona testimonials `P1` `👁`
**Signal** Three five-star quotes, initial-only avatars, "Sarah Chen", "Mike Tanaka", one
persona per continent.
**Reads AI** The clearest testimonial tell.
**Fix** Real testimonials or none.

---

## H. Second-order defaults (the "tasteful" traps)

The escapes that became the new median. Legitimate for some briefs; tells when they appear
regardless of subject.

### CMP-SD-01 — Cream + terracotta `P1` `👁`
Warm cream surface (~#F4F1EA), high-contrast serif display, clay/terracotta accent
(~#D97757 — Anthropic's own interaction accent). **Fix** Only if the brief asked for warmth;
otherwise derive the neutrals from this product's subject.

### CMP-SD-02 — Acid-on-black `P1` `👁`
Near-black `surface` with a single bright acid-green or vermilion accent.
**Fix** Legitimate for some brands; a default otherwise.

### CMP-SD-03 — All-glass `P1` `👁`
`Modifier.blur(20.dp)` + translucent `colorScheme.surface.copy(alpha = .7f)` panels, or
frosted `Haze`-style surfaces everywhere.
**Fix** Glass must indicate real layering over meaningful, moving content — one place, or
none. On mid-range devices the blur costs frames for no reason.

### CMP-SD-04 — All-neubrutalism `P1` `👁`
Hard black `Border(2.dp, Color.Black)`, offset `shadow(dx = 4.dp, dy = 4.dp)`, monospace
labels, on every element.
**Fix** A style, not a system, when applied uniformly; keep it disciplined and rare.

### CMP-SD-05 — Stock Material 3 "seed" look, app-wide `P0` `👁`
The whole app ships the M3 baseline: default tonal surfaces, default component shapes,
default type — technically Material 3, culturally the New Project template.
**Fix** M3 is the substrate, not the direction. Authored palette, differentiated shapes,
chosen type. If a screenshot could ship from a fresh `Empty Activity` wizard, it isn't done.

### CMP-SD-06 — Template micro-chrome `P1` `⚙`
Tracked ALL-CAPS eyebrow above every section header; middot meta ("A · B · C"); "→" appended
to every button label; tinted near-black standing in for black; mono for small labels "to
look technical".
**Fix** Use real headings and plain labels; reserve these devices for the few places they
mean something.

---

## I. Platform honesty

### CMP-X-01 — Phone-only fixed layout `P0` `👁`
**Signal** One column at every window size; no `currentWindowAdaptiveInfo()` /
`WindowSizeClass` branch; tablet/foldable runs stretch the phone layout.
**Reads AI** A phone screenshot scaled up is not an Android app; Android's whole pitch is
adaptivity.
**Fix** Per-region adaptation on width (and height): list-detail, supporting pane,
`NavigationSuiteScaffold`. Choose per region: stay / stack / reorder / collapse / scroll /
drawer / disappear.

### CMP-X-02 — Fixed `Modifier.width(...dp)` `P0` `⚙`
**Signal** `Modifier.width(320.dp)` / `widthIn(max = 280.dp)` on primary content, causing
clipping or dead margin at the smallest and largest sizes.
**Reads AI** Hard widths ignore density, font scale, and window size at once.
**Fix** Intrinsic sizing, `fillMaxWidth()` + padding, and `widthIn` with real min/max
reasoning. Test at 320dp width and at 840dp.

### CMP-X-03 — Tiny touch targets `P0` `⚙`
**Signal** `Modifier.size(24.dp)` on a clickable icon row; `IconButton` content without
minimum-size padding on a dense toolbar; `clickable` on 32dp-tall rows.
**Reads AI** Unusable for anyone with a thumb — and it fails Material's own 48dp guidance.
**Fix** ≥ 48dp touch target (`Modifier.minimumInteractiveComponentSize()` /
`sizeIn(minWidth = 48.dp, minHeight = 48.dp)`), even when the drawn icon is 24dp.

### CMP-X-04 — Orientation lock `P0` `⚙`
**Signal** `android:screenOrientation="portrait"` in the manifest, or
`requestedOrientation = ActivityInfo.SCREEN_ORIENTATION_PORTRAIT` in code.
**Reads AI** Forcing one orientation is a tell *and* a platform violation on foldables/tablets.
**Fix** Support both orientations unless the product is truly impossible in landscape
(a camera viewfinder, maybe). Recompose for it instead.

### CMP-X-05 — IME handling absent `P1` `👁`
**Signal** `Scaffold` with `Modifier.imePadding()` missing on forms; fields scrolled under
the keyboard; the primary button hidden behind the IME.
**Reads AI** Generated forms don't test typing; users notice instantly.
**Fix** `Modifier.imePadding()` on the scrollable form (or `WindowCompat.setDecorFitsSystemWindows(window, false)`
plus correct insets), `imeAction`/`KeyboardOptions` per field, focus advance on Done.

### CMP-X-06 — TalkBack / semantics missing `P0` `👁`
**Signal** `Icon(...)` without `contentDescription` (or with `null` on meaningful icons),
`clickable` on non-text `Box`es with no role or state, list items whose whole card is
unlabeled, state changes with no `Modifier.semantics { liveRegion = … }`.
**Reads AI** A UI only eyes can use reads unfinished — because it is.
**Fix** Every meaningful icon described; every interactive element has role, state, and
action; decorative things `clearAndSetSemantics {}`; announce async results.

### CMP-X-07 — Predictive back ignored `P1` `👁`
**Signal** Custom back handling via `BackHandler` that pops with an instant cut, no
`AnimatedContent`/transition tracking `transitionState.isPredicting`; full-screen
immersive content with no back affordance.
**Reads AI** Android's system gesture, ignored — an app that doesn't know it's on Android.
**Fix** Let NavHost's transitions track predictive back; expose a visible escape for any
immersive flow.

---

## J. Code that produces generic UI

Structural smells that reliably produce a generic result even when the styling is fine.

### CMP-CD-01 — Raw visual values in composables `P0` `⚙`
**Signal** `Color(0xFF…)` and bare `dp`/`sp`/`millis` literals in the render path — colors,
sizes, radii, durations all hardcoded at the call site.
**Reads AI** Every screen invents its own values, so nothing coheres.
**Fix** A token layer the composable reads: `MaterialTheme` roles, a `CompositionLocal`
token provider, or an object. One file owns values; composables only reference.

### CMP-CD-02 — No token layer `P0` `👁`
**Signal** `MaterialTheme` with a color scheme and nothing else — no custom `typography`,
no shapes, no spacing/radius/elevation tokens, per-composable styling throughout.
**Reads AI** A theme with a seed and no opinions produces a themed template.
**Fix** A token set (`AppColors`, `AppType`, `AppShapes`, space/radius/elevation constants)
plus component defaults (`ButtonDefaults`, `CardDefaults` wired once).

### CMP-CD-03 — Boolean state soup `P1` `⚙`
**Signal** `var isLoading by remember { mutableStateOf(false) }` plus `hasError`, `isEmpty`,
`isRefreshing` — booleans that can be true together.
**Reads AI** Impossible-state bugs and missing screens are the direct result.
**Fix** A sealed `UiState` (see CMP-CM-01) or a single `StateFlow<UiState>`; the compiler
forces every branch.

### CMP-CD-04 — Duplicate composables `P1` `👁`
**Signal** `PrimaryButton`, `PrimaryButtonNew`, `LxButton` — or two `ProfileHeader`s that
drifted. Copy-paste variants with no named reason.
**Reads AI** The codebase of a machine that never revisited its own decisions.
**Fix** One canonical composable per role; a named variant (`PrimaryButton(size = …)`) when
the difference repeats and means something.

### CMP-CD-05 — Strings inline in composables `P1` `⚙`
**Signal** `Text("Sign in to continue")` with a hardcoded literal, copy scattered through
the render path, no `stringResource`.
**Reads AI** Untranslatable, unreviewable copy; RTL and locale breaks guaranteed.
**Fix** All user-facing copy via `stringResource(R.string.…)` (or your i18n layer); format
with positional args, never string concatenation.

### CMP-CD-06 — Lists without keys / not virtualized `P1` `⚙`
**Signal** `LazyColumn(items = items)` with no `key = { it.id }`; or a giant dataset in a
`Column`+`verticalScroll` (or a `LazyColumn` nested in an outer scroll with
`userScrollEnabled` chaos). State loss and jank follow.
**Reads AI** Jank reads as unfinished; generated code rarely thinks about identity.
**Fix** Stable `key`s for every lazy list; one virtualized list per scroll region; nested
scroll only with a real reason (`NestedScrollConnection`, headers via `item {}`).

### CMP-CD-07 — Reading `Configuration` without recomposition handling `P1` `⚙`
**Signal** `LocalConfiguration.current` read for layout math with no recomposition-safe
pattern, or a static `resources.displayMetrics` grabbed once in a singleton and cached —
orientation/density/font-scale changes never recompose.
**Reads AI** A layout that ignores rotation and font scale was written by someone (or
something) not testing the device.
**Fix** Read `LocalConfiguration.current` / `LocalWindowInfo.current` *inside* the composable
that needs it so recomposition happens; derive from `WindowSizeClass` instead of raw pixels.

---

## Detectors

The `⚙` subset above is implemented by a **detekt** ruleset/config in **`lint/compose/`** —
detekt is Kotlin AST based, so these rules can be real AST checks, not regex. The rules use
the universal rule names from `lx-obsidian`'s `slop-taxonomy.md`
(`hardcoded_color`, `framework_color`, `default_theme`, `hardcoded_spacing`,
`hardcoded_radius`, `hardcoded_font_size`, `hardcoded_elevation`, `reflex_font`,
`emoji_icon`, `linear_motion`, `orientation_lock`), so suppression and reporting read the
same as in every other stack: `// detekt-suppress LxSlopHardcodedColor`.

Honest status: the provided `detekt.yml` enables the relevant **built-in** detekt rules
today and **documents** the custom `lxSlop:` rules; the custom rules themselves require
building the ruleset jar — this environment has no Kotlin/Android toolchain, so the jar was
not built or tested here. See `lint/compose/README.md` for the module skeleton, the
`Rule` starting point, and the regex/scanner fallback (`scripts/lx_scan.sh`). Everything `👁`
— copy, layout tension, palette harmony, "soul" — stays human: `lx-design-verify` and eyes.
