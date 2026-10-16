# React Native tell catalog

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

Each tell: **ID — title** `severity` `⚙ code-certain | 👁 rendered`. Then **Signal** (the RN/TSX
that gives it away), **Reads AI** (why), **Fix** (what to do). Code-certain tells are enforced
by `lx-slop-guard`'s ESLint plugin (`packages/eslint-plugin-lx-slop`). This catalog is
React Native–specific — Expo and React Native Web included — and web and Flutter anti-slop
lists miss most of it.

---

## A. Structure & layout

### RNX-ST-01 — The centered `flex: 1` screen `P0` `⚙`
**Signal** A screen whose root is `<View style={{ flex: 1, justifyContent: 'center', alignItems: 'center' }}>`,
or a `StyleSheet` entry with that triple, wrapping the whole route:
```tsx
export default function Home() {
  return (
    <View style={s.screen}>
      <Text style={s.title}>Welcome back</Text>
      <Pressable onPress={go} style={s.cta}><Text style={s.ctaLabel}>Continue</Text></Pressable>
    </View>
  );
}
const s = StyleSheet.create({
  screen: { flex: 1, justifyContent: 'center', alignItems: 'center', padding: 24, gap: 16 },
});
```
**Reads AI** Vertical centering is the lazy default when there is no hierarchy in the brief.
Every generated screen centers its stack, so a real product's left-aligned reading order
instantly reads chosen.
**Fix** Derive alignment from the surface contract: a `SafeAreaView` with left-aligned content
on a spacing grid; anchor secondary content to `spaceBetween`/`flex-end`. Center only what
genuinely warrants it — a login, a permission prompt, a true empty state.

### RNX-ST-02 — The uniform `.map` grid/list of identical cards `P0` `👁`
**Signal** `{items.map((item) => <Card key={item.id} … />)}` (or a `FlatList` with
`numColumns` whose cells are clones) producing N equal tiles: same width, same padding, same
icon box, same title weight, same two-line blurb.
```tsx
<View style={s.grid}>
  {features.map((f) => (
    <View key={f.id} style={s.card}>
      <View style={s.iconBox}><Text style={s.icon}>{f.emoji}</Text></View>
      <Text style={s.cardTitle}>{f.title}</Text>
      <Text style={s.cardBody}>{f.blurb}</Text>
    </View>
  ))}
</View>
```
**Reads AI** Equal cells are the composition of a template; real products have one item that
matters more than the others.
**Fix** One asymmetry: a lead cell that breaks the column count, a genuinely bigger first
tile, list-plus-feature, or a table when the data is tabular. Make the important item look
important.

### RNX-ST-03 — Template section skeleton `P1` `👁`
**Signal** The order is always: header → hero/stat row → 3 feature cards → testimonial trio →
CTA banner, reused across routes of the app.
**Reads AI** It is the web landing template stamped into an app navigator.
**Fix** Reorder and rename sections for this product. Drop every section that could be
deleted without the user missing it.

### RNX-ST-04 — View-in-View nesting `P1` `👁`
**Signal** `<View style={s.card}><View style={s.inner}><View style={s.row}>…` — a wrapper
`View` with its own style object per conceptual row; cards inside cards; a container around
every text pair.
**Reads AI** Excess containment is the visual signature of padding a layout until it looks
designed — and it costs native view allocations on every render.
**Fix** A container earns its border only where regions need a visible boundary. Flatten with
`gap`, a divider, or a surface-tone change; keep at most two levels of nesting per screen.

### RNX-ST-05 — No structural adaptation: `Platform.OS` for layout, fixed widths `P0` `⚙`
**Signal** Layout keyed to the OS or to fixed pixels, with no window measurement anywhere in
the file:
```tsx
const pad = Platform.OS === 'ios' ? 24 : 16;
const showSideRail = Platform.OS !== 'web';
// StyleSheet
container: { width: 375, alignSelf: 'center' },   // or maxWidth: 420 everywhere
```
**Reads AI** The same screen at every size is a phone screenshot, and OS-keyed branches are a
guess where width is the fact. It reads as a design that was never held at any other size.
**Fix** `const { width } = useWindowDimensions(); const wide = width >= 840;` — branch on
window class, then pick one behavior per region (stay / stack / reorder / collapse / scroll /
drawer / disappear). Reserve `Platform.OS` for genuinely platform-specific behavior: haptics,
permission prompts, back-gesture conflict, a platform nav model.

### RNX-ST-06 — Missing safe-area handling by route `P0` `⚙`
**Signal** A screen root is a plain `View` with `flex: 1` under `headerShown: false`, a
full-screen modal, or an edge-to-edge Android activity — no `SafeAreaView` and no
`useSafeAreaInsets` anywhere in the file. Content lands under the notch, Dynamic Island, or
the home indicator; a CTA sits behind the home bar.
**Reads AI** Generated screens don't know the device has geometry; the app looks unfinished
the moment it runs on real hardware instead of a bare simulator.
**Fix** Handle insets per surface with `react-native-safe-area-context`: `SafeAreaView` (with
`edges` set) or `useSafeAreaInsets()` in each navigator screen — top inset for headerless
screens, bottom for tab bars and primary actions, left/right only in landscape or under
cutouts. Edge-to-edge on Android means insets are your job, not the framework's.

### RNX-ST-07 — Broken proximity `P2` `👁`
**Signal** One flat `gap: 16` (or equal `marginTop` on everything) across an entire scroll —
a heading sits as far from its own body copy as from the next section; list rows, labels, and
section titles all share one distance.
**Reads AI** Generated layouts miss the gestalt law of proximity: grouping must come from
space, and equal spacing means no grouping.
**Fix** Tight spacing inside a group (4–8), larger between groups (24–32). Whitespace, not an
extra card, should carry the hierarchy.

---

## B. Color

### RNX-CO-01 — Raw hex in `StyleSheet`, no token layer `P0` `⚙`
**Signal** Literal colors in `StyleSheet.create` or inline `style`:
```ts
const styles = StyleSheet.create({
  screen: { flex: 1, backgroundColor: '#0B0B12' },
  card: { backgroundColor: '#1C1C28', borderColor: '#2A2A38' },
  title: { color: '#FFFFFF' },        // '#fff' / '#000' as the surface/ink pair
  muted: { color: '#8B8B93' },
});
```
**Reads AI** No token system was used, so every color was invented at the component — and
`#fff`/`#000` in particular is the un-designed default surface/ink pair, the absence of a
palette rather than a palette.
**Fix** One typed token object consumed through context — `tokens.color.surface / ink /
accent / <semantic>` resolved in the view, never a literal (ignored inside the token file
itself). Two authored palettes (light/dark), one import.

### RNX-CO-02 — Accent used everywhere `P0` `👁`
**Signal** The accent (`tokens.color.accent`, or one raw brand hex) on tab icons, headings,
links, badges, borders, button fills, *and* a 10% wash behind cards — 5+ visible uses per
screen.
**Reads AI** A color used everywhere is used nowhere; with the accent on everything, nothing
stands out and the screen has no focal point.
**Fix** Cap the accent at ~2 visible uses per screen: selection and the single primary action.
Everything else is neutral; inactive/quiet affordances use ink or inkMuted.

### RNX-CO-03 — Two-stop `expo-linear-gradient` purple→pink `P0` `⚙`
**Signal** `<LinearGradient colors={['#7C3AED', '#EC4899']} style={s.hero}>` as a hero,
header, or button background (also indigo→blue, blue→cyan) — usually under white text and
sometimes with a blurred orb over it.
**Reads AI** The default decoration of generated UI: the gradient stands in for a design
decision that was never made.
**Fix** Flatten to a surface plus intentional type. If a gradient is genuinely right, keep it
in one hue family, anchor it to something in the subject's world, and don't put a paragraph on
top of it.

### RNX-CO-04 — Low-contrast text `P0` `👁`
**Signal** `color: '#8B8B93'` on `#FFFFFF` (~3.1:1), `#6B7280` on `#F9FAFB`, muted labels on
tinted card backgrounds, placeholders treated as body text.
**Reads AI** Generated UIs routinely ship low contrast — the most common accessibility error —
and it reads as untested rather than subtle.
**Fix** ≥4.5:1 for body, ≥3:1 for large text and icons-as-controls, verified on the *rendered*
surface in both themes. If a muted tone fails, darken/lighten the token, not the one string.

### RNX-CO-05 — Dark mode by inversion, hardcoded `P1` `⚙`
**Signal** Component-level ternaries on a local boolean — `const bg = dark ? '#000' : '#fff'`,
`useState(false)` toggles that swap hex values in JSX — or a single hardcoded palette that
never consults `useColorScheme()`.
**Reads AI** Inverted light themes look generated: full-chroma accents on pure black, pure
black surfaces, no design done for dark — because none was.
**Fix** `const scheme = useColorScheme();` resolved once in the token provider, with two
palettes authored by hand: dark desaturates large accent areas, lifts surfaces off black,
re-checks contrast on dark specifically. Components read tokens; they never branch on theme.

---

## C. Typography

### RNX-TY-01 — Untouched system font `P0` `⚙`
**Signal** No `fontFamily` in the whole file; `<Text style={{ fontWeight: '700' }}>` doing all
the work. SF Pro (iOS) / Roboto (Android) exactly as they ship, default sizes, hierarchy by
weight alone.
**Reads AI** The platform's default face is the plainest possible choice, and on RN it also
means iOS and Android render *different* type with no decision behind either.
**Fix** Choose a family deliberately and wire it once (loaded via `expo-font`, exposed as
token roles: `display / title / body / label`). Set a scale with real contrast. If the
system font is the honest choice, make that a stated decision — then own the scale and
tracking.

### RNX-TY-02 — Reflex Google font `P1` `⚙`
**Signal** `@expo-google-fonts/inter`, `SpaceGrotesk_700Bold`, `DM_Sans_700Bold`,
`Poppins_600SemiBold` as the display face — especially Inter over the whole app.
**Reads AI** These are the overused generated faces; avoiding Inter now means the model
reaches for Space Grotesk, and the swap doesn't change the taste.
**Fix** A face nobody in this category uses, paired with a plain workhorse for UI text.
State the reason in one line.

### RNX-TY-03 — Weak hierarchy (three near-equal sizes) `P0` `👁`
**Signal** `fontSize: 24 / 22 / 20` for title/subtitle/body, or `20 / 18 / 16` — steps small
enough that no size wins.
**Reads AI** Mush. Contrast in size is what creates hierarchy; near-equal sizes mean the
layout never decided what matters.
**Fix** Make the largest type genuinely large (32+) and body genuinely readable (15–17); the
gap *is* the hierarchy. Tighten tracking at display sizes, loosen leading.

### RNX-TY-04 — Hardcoded `fontSize` numbers `P0` `⚙`
**Signal** Numeric font sizes scattered through `StyleSheet` and inline styles:
`fontSize: 15`, `fontSize: 12`, `fontSize: 13` — chosen ad hoc down the file, no scale.
**Reads AI** No type scale exists, so each size was invented where it sits; the page can't be
tuned without editing forty literals.
**Fix** A named type scale in tokens (`bodySm/bodyMd/title/display` = family + size + lineHeight
+ weight), referenced by role. Sizes change in one file.

### RNX-TY-05 — One-word accent in a headline `P1` `👁`
**Signal** A heading where one word is colored/bolded via a nested `<Text>`:
`<Text>Welcome to <Text style={{ color: accent }}>Lumina</Text></Text>` — repeated as a device
across screens.
**Reads AI** The signature typographic decoration of generated landing copy.
**Fix** Let the whole line carry emphasis through size, weight, and space — or make the accent
word a genuinely different element (a logo, a value the product renders) with a reason.

### RNX-TY-06 — Non-tabular figures `P2` `⚙`
**Signal** Prices, scores, timestamps, or any column of numbers rendered in the default
proportional face with no `fontVariant`.
**Reads AI** Generated data UI jitters as values change; columns don't align, so the numbers
look provisional.
**Fix** `fontVariant: ['tabular-nums']` on every figure that updates or aligns in a column.
One token role (`numeric`) so it isn't re-declared per component.

### RNX-TY-07 — Dynamic Type ignored `P1` `⚙`
**Signal** `allowFontScaling={false}` on `<Text>`, `maxFontSizeMultiplier={1}` bolted on, or
fixed-height rows (`height: 44` with a single-line `Text`) that clip when the system text
scale grows.
**Reads AI** Generated layouts assume 100% forever; the app looks broken to anyone who has
turned text up — the tell that nobody used it.
**Fix** Never set fixed heights on text containers; let rows grow. Test at 130–200% text
size on both platforms; use `maxLines` + `numberOfLines` with `ellipsizeMode` deliberately,
never as a layout crutch.

---

## D. Space, shape, elevation

### RNX-SH-01 — Magic-number spacing `P0` `⚙`
**Signal** `padding: 17`, `marginTop: 12`, `gap: 10`, `marginBottom: 6` chosen ad hoc down the
file; the same gap appearing as `8`, `10`, and `12` in one screen.
**Reads AI** No spacing system; every gap was invented where it sits, so the rhythm drifts.
**Fix** One named scale in tokens (base 4 or 8: `space.xs/sm/md/lg/xl`), referenced by role —
row gap, card padding, section gap, page gutter. `gap` on containers beats per-child margins.

### RNX-SH-02 — One radius everywhere `P0` `⚙`
**Signal** `borderRadius: 12` on cards, buttons, inputs, chips, avatars, and image masks —
every corner in the app the same size.
**Reads AI** One radius collapses component hierarchy: controls, surfaces, and pills all read
as the same object, which is the SaaS-card kit's frame.
**Fix** A radius ladder by role: control (8), surface (12–16), pill (`borderRadius: 999`).
Small controls get radii matched to their size.

### RNX-SH-03 — One shadow kit under every surface `P0` `⚙`
**Signal** The same block copied into style after style —
```ts
card: {
  shadowColor: '#000', shadowOpacity: 0.12, shadowRadius: 12,
  shadowOffset: { width: 0, height: 4 }, elevation: 4,
},
listItem: { /* identical five properties */ },
tile:    { /* identical five properties */ },
```
iOS shadow props and Android `elevation` duplicated by reflex, at one intensity everywhere.
**Reads AI** The SaaS-card kit: identical rounded cards, one shadow, no layering hierarchy —
and duplicated props mean the shadow was never tuned per platform.
**Fix** An elevation ladder in tokens (or no elevation at all: hairline borders + tonal
surfaces). Shadow only where something is genuinely stacked (sheets, menus, a FAB over
content); each level tuned for iOS blur *and* Android elevation, or use `boxShadow` on
web/native with one declaration.

### RNX-SH-04 — Shadow on flat surfaces `P1` `👁`
**Signal** `elevation`/`shadow*` on elements that aren't raised: flat list rows, section
dividers, chips in a static grid, a card that is the base surface.
**Reads AI** Decoration without a role — depth implied where there is none reads as applied
rather than composed.
**Fix** Flat content gets borders or tone. Reserve shadow for real layering, and keep at most
one strong depth effect per screen.

### RNX-SH-05 — Uniform padding by reflex `P1` `⚙`
**Signal** `padding: 16` on cards, rows, headers, modals, and tab-bar items alike; or one
`paddingHorizontal: 24` wrapping every screen regardless of density.
**Reads AI** Padding applied by reflex rather than by role, so dense content is airless and
spacious content is cramped in the same app.
**Fix** Vary by role: tight rows (8–12), component padding (12–16), sections (24), page
gutters (16–24, responsive with `useWindowDimensions`).

---

## E. Components & states

### RNX-CM-01 — Happy path only `P0` `👁`
**Signal** No loading/empty/no-results/error/disabled states in the file; data renders or the
screen is blank — often literally `{items.length > 0 && <List … />}` with nothing else
defined.
**Reads AI** Generated screens assume data is present and the network is up; the first time
either is false, the product looks abandoned.
**Fix** Encode the states as a discriminated union so TypeScript forces handling:
```ts
type FeedState =
  | { status: 'loading' }
  | { status: 'empty'; reason: string }
  | { status: 'error'; message: string; retry: () => void }
  | { status: 'ready'; items: Item[] };
```
Render each with the **same** frame and tokens — never a bare centered spinner replacing the
layout.

### RNX-CM-02 — Centered `ActivityIndicator` as the whole loading state `P1` `⚙`
**Signal** `<View style={{ flex: 1, justifyContent: 'center', alignItems: 'center' }}><ActivityIndicator size="large" /></View>`
as the sole loading affordance, often while the final layout will appear beneath it and shift.
**Reads AI** A spinner says nothing about what is loading or how long it will take; it is the
placeholder of last resort.
**Fix** Skeletons that preserve the final layout so nothing jumps, or inline progress for the
thing actually pending (a button-level spinner with its label intact). Reserve the centered
spinner for genuinely indeterminate, sub-second waits.

### RNX-CM-03 — Identical feature cards `P1` `👁`
**Signal** 3–4 cards in a row/grid: icon in a rounded box, bold title, two lines of blurb —
the same component, the same rhythm, N times.
**Reads AI** The most recognizable generated block in any stack; RN ships it via `.map`, so it
repeats perfectly.
**Fix** Prose, a table, or an honest asymmetric layout. If cards are right, make them
genuinely different where the content is — one lead card, varying depth, real data in the
tiles instead of blurbs.

### RNX-CM-04 — Icon in a rounded `View` `P1` `👁`
**Signal** `<View style={s.iconBox}><Text style={s.icon}>{…}</Text></View>` where `iconBox` is
`{ width: 44, height: 44, borderRadius: 12, backgroundColor: accent + '1A', alignItems:
'center', justifyContent: 'center' }` — repeated per feature, card, and list row.
**Reads AI** Decorative containment with no role: the box exists to make the layout look
designed, not to help recognition.
**Fix** Use the icon plainly (correct optical size, one monoline set), or drop it. If a
container is needed, tie it to a state — a selected target, a status — not to every icon.

### RNX-CM-05 — Emoji as icons `P0` `⚙`
**Signal** `<Text style={s.icon}>✨</Text>` / `🚀` / `🎯` / `⚡` where an icon belongs — in
cards, tab labels, list bullets, status rows.
**Reads AI** Emoji standing in for a real icon set reads generated (and renders inconsistently
across platforms — the iOS/Android emoji gap makes it obvious on device).
**Fix** One icon set at consistent weight and optical size (or inline SVG). Reserve emoji for
copy where the product's voice actually uses them.

### RNX-CM-06 — Default React Navigation header `P1` `👁`
**Signal** `<Stack.Screen name="Profile" component={ProfileScreen} options={{ title: 'Profile' }} />`
with everything else default — the stock bar's system-font title, hairline shadow, default
back chevron, and default padding on every route.
**Reads AI** Default chrome that ignores both the product and the platform: the app's brand
stops at the content and the nav is framework-owned.
**Fix** Choose the header treatment per surface: `headerShown: false` with an in-content
header, a transparent/blurred bar over a hero, a large title where iOS conventions fit, a
custom back affordance in the product's own words. Set tint, hairline, title size, and
back-button display mode deliberately — or hide the bar and own the top region.

### RNX-CM-07 — Bottom-tab-bar-for-everything `P1` `👁`
**Signal** `createBottomTabNavigator()` wrapping every feature — including nested detail
stacks, settings flows, and one-off tools — with 4–6 tabs and emoji/SF-symbol icons.
**Reads AI** Tabs are the default navigator, not the correct one; a tab bar that persists
through deep flows says the navigation model was never designed.
**Fix** Tabs only for the 3–5 top-level jobs, stacks inside them. Detail screens, modal-ish
flows, and focused tasks leave the tab bar behind. On wide layouts, a rail or drawer (see
`lx-cross-platform`).

### RNX-CM-08 — Stock CTA pair `P1` `👁`
**Signal** Two buttons side by side reading "Get Started" / "Learn More" (or "Try It Now" /
"Book a Demo"), primary filled accent + secondary outlined, at the bottom of every screen.
**Reads AI** Generic labels that could serve any product, arranged in the default pair.
**Fix** Name the actual action ("Publish draft", "Reserve 14:30"). One primary action per
surface; the secondary is a genuinely different path, not a filler twin.

### RNX-CM-09 — `Pressable` with no pressed/hover/focus state `P0` `⚙`
**Signal** `onPress` with a static `style` object — no `({ pressed }) =>` style function, no
hover handlers, no focus styling, no `accessibilityRole`/`accessibilityState`:
```tsx
<Pressable onPress={handleNext} style={s.button}>
  <Text style={s.label}>Next</Text>
</Pressable>
```
**Reads AI** A control that gives no feedback reads dead on every platform: no press dim on
touch, no hover or focus ring on RN Web, invisible to screen readers.
**Fix**
```tsx
<Pressable
  onPress={handleNext}
  disabled={busy}
  accessibilityRole="button"
  accessibilityState={{ disabled: busy, busy }}
  onHoverIn={() => setHover(true)} onHoverOut={() => setHover(false)}
  onFocus={() => setFocused(true)} onBlur={() => setFocused(false)}
  style={({ pressed }) => [
    s.button, hover && s.hover, focused && s.focus, pressed && s.pressed,
    busy && s.busy,
  ]}
>
```
Pressed, hover, focus-visible, and disabled are four states of one control — not optional.

---

## F. Motion

### RNX-MO-01 — Linear / framework-default curves `P1` `⚙`
**Signal** `Animated.timing(op, { toValue: 1, duration: 300, useNativeDriver: true })` with
`easing: Easing.linear` (or nothing tuned), or Reanimated `withTiming(1, { duration: 300 })`
and `withSpring(v)` with default configs everywhere.
**Reads AI** Mechanical, one-size motion reads unpolished; the defaults are chosen for
predictability, not for feel.
**Fix** Ease-out for entrances, ease-in for exits, springs for drags and dismissals. Encode
curves as tokens (`tokens.motion.easeOut`, `tokens.spring.snappy`) so feel is a decision, not
a per-call guess.

### RNX-MO-02 — `LayoutAnimation` on every mount `P1` `⚙`
**Signal** `LayoutAnimation.configureNext(LayoutAnimation.Presets.easeInEaseOut)` inside
`useEffect(() => {…}, [])` — or in every `setState` and every press handler — so views spring
into place on initial render and on every list update.
**Reads AI** Motion that fires when nothing reflowed in response to the user isn't
choreography; it's the framework's default playing over content the user didn't touch.
**Fix** One orchestrated entrance per surface (a single sequence, or Reanimated `entering`
views on the *first* render only). `LayoutAnimation` where layout genuinely reflows from an
action: expand/collapse, reorder, a revealed row.

### RNX-MO-03 — Content gated on scroll reveal `P0` `👁`
**Signal** A section bound to `Animated.event` scroll position with
```tsx
const opacity = scrollY.interpolate({
  inputRange: [0, 240], outputRange: [0, 1], extrapolate: 'clamp',
});
<Animated.View style={{ opacity, transform: [{ translateY }] }}>
```
**Reads AI** The static capture is blank; content is hidden behind an interaction the app
never asked for — users who don't scroll, or who land mid-page, never see it.
**Fix** Content present by default; motion reveals, never gates. If an entrance is right,
fire it from visibility/state, and make reduce-motion show the final state immediately.

### RNX-MO-04 — Reduce-motion never consulted `P1` `⚙`
**Signal** No `AccessibilityInfo.isReduceMotionEnabled()` call anywhere; Reanimated's
`useReduceMotion()` never read; custom `Animated.sequence`/loop playing regardless.
**Reads AI** Motion that ignores an accessibility setting is both a tell and a bug — it reads
as an app nobody could use, tested by no one.
**Fix** Query once (`useReduceMotion()` from Reanimated, or `AccessibilityInfo` + a
subscription) and branch: final states immediately, no decorative loops, transitions become
instant swaps. The flow stays fully usable.

### RNX-MO-05 — One duration everywhere `P2` `⚙`
**Signal** Every `duration: 300` in the app — entrances, presses, modals, list updates,
`withTiming` calls — or a single `PRESets.easeInEaseOut` reused for all of it.
**Reads AI** No motion system: distance, size, and importance don't change how long something
takes, which reads as one animation asset applied everywhere.
**Fix** A small duration scale in tokens (fast/base/slow ≈ 120/240/400ms) mapped to element
size and travel distance; springs for direct manipulation.

---

## G. Copy

### RNX-CP-01 — Filler / unfalsifiable copy `P0` `⚙`
**Signal** `'Lorem ipsum dolor sit'`, `'Item 1'`, `'Sample content'`, `'Get Started'`,
"10× faster" with no source, in `<Text>` children and data fixtures.
**Reads AI** The single strongest tell, and it has nothing to do with design — it means no one
wrote the product's words.
**Fix** Real nouns, numbers, dates, and lengths. If a metric isn't real, label it as a
placeholder or leave it out.

### RNX-CP-02 — Category slogans `P1` `⚙`
**Signal** "Unlock", "Supercharge", "Seamless", "Elevate", "Effortless", "Next-generation",
"Leverage" in headings and empty states.
**Reads AI** Words that describe a category rather than a product — a competitor could ship
the same string unchanged.
**Fix** A claim only this product can make, ideally with a number from its own domain.

### RNX-CP-03 — "It's not X, it's Y" reframe `P1` `⚙`
**Signal** "It's not a to-do list. It's a commitment." / "X, not Y." / "More than just a
tracker." in a hero or onboarding slide.
**Reads AI** The UI version of a known writing tell; the construction is doing the argument's
work.
**Fix** State the thing directly.

### RNX-CP-04 — Verb drift through a flow `P1` `👁`
**Signal** Button says "Submit", the toast says "Saved!", the screen says "Success!", the
history row says "Recorded". `<Button title="Submit" />` → `Alert.alert('Saved!')`.
**Reads AI** No one owned the vocabulary across the flow.
**Fix** An action keeps its name end to end: "Publish" → "Published" → the row reads
"Published 14:32". Active voice, one verb per job.

### RNX-CP-05 — Generic error/empty copy `P1` `👁`
**Signal** `Alert.alert('Error', 'Something went wrong.')`, `<Text>No data</Text>`,
`<Text>Nothing here yet</Text>` with no next step.
**Reads AI** Errors that apologize or stay vague, empty states that end the conversation.
**Fix** Say what failed, what is safe, and how to recover ("Couldn't refresh — your saved
drafts are still on this phone. Retry"). Empty states are invitations to act.

---

## H. Second-order defaults (the "tasteful" traps)

The escapes that became the new median. Legitimate for some briefs; tells when they appear
regardless of subject.

### RNX-SD-01 — Cream + terracotta `P1` `👁`
Warm cream background (~`#F4F1EA`), high-contrast serif display (often via `expo-font`), clay
accent (~`#D97757`). **Fix** Only if the brief asked for warmth; otherwise derive the neutral
family from this product's subject.

### RNX-SD-02 — Acid-on-black `P1` `👁`
Near-black background (`#050505`) with a single acid-green or vermilion accent, everything
else grey. **Fix** Legitimate for some brands; a default otherwise.

### RNX-SD-03 — All-glass (`expo-blur` everywhere) `P1` `👁`
`<BlurView intensity={40} tint="dark">` on the header, every card, the tab bar, and floating
over content that isn't meaningful behind it. **Fix** Glass must indicate real layering over
content worth seeing through — one place, or none. Flat surfaces get tone and borders.

### RNX-SD-04 — All-neubrutalism `P1` `👁`
`borderWidth: 3, borderColor: '#000'` with offset shadows (`shadowOffset: { width: 4,
height: 4 }`, `elevation: 6`) and mono labels on every element. **Fix** A style, not a system,
when applied uniformly; keep it disciplined and rare.

### RNX-SD-05 — Untouched Expo starter `P0` `👁`
The default `create-expo-app` template still running: `app/(tabs)/index.tsx` with the logo
header, a "Open up App.tsx…" `ThemedText` line, the `StepIcon` counter, `ParallaxScrollView`,
two default tabs ("Tab One" / "Tab Two"), `constants/Colors.ts` with a `tintColor` nobody
chose. **Fix** Delete every template screen, string, and color before design starts; the
starter is scaffolding, not a baseline to restyle around.

### RNX-SD-06 — Template micro-chrome `P1` `⚙`
Tracked ALL-CAPS eyebrows above every heading (`textTransform: 'uppercase'` +
`letterSpacing: 2`), middot meta ("A · B · C"), "WORD — fragment" titles, `→` appended to
buttons, mono for small labels "to look technical". **Fix** Real headings and plain labels;
reserve these devices for the few places they mean something.

---

## I. Platform honesty

Full treatment in `lx-cross-platform` (window classes, the per-region adaptation menu, the
interaction rules). Layout branched on `Platform.OS` instead of width is **RNX-ST-05** — on
RN Web it is also this. The quick tells:

- **RNX-X-01 — No web surface on RN Web** `P0` `⚙` — `Pressable`/`TouchableHighlight` with
  only `onPress`; no hover feedback, no visible focus, no keyboard path, no `cursor: pointer`,
  no text selection on custom text. A phone app in a browser tab. **Fix** hover + focus-visible
  + pressed as one state machine (see RNX-CM-09), real targets, semantic roles.
- **RNX-X-02 — Bottom tabs on a wide web window** `P1` `👁` — `createBottomTabNavigator()`
  parked at the bottom of a 1400px browser window with a phone-width column centered above it.
  **Fix** At ≥840px a rail or persistent nav with real URLs (Expo Router), content using the
  width it has.
- **RNX-X-03 — No responsive width / breakpoints** `P0` `👁` — one fixed layout at 320, 768,
  and 1200; horizontal overflow or a phone column in the middle of a desktop page. **Fix**
  `useWindowDimensions` + breakpoints, one adaptation choice per region.
- **RNX-X-04 — Touch targets under 44pt** `P0` `👁` — icon buttons and tab items at
  `width: 24, height: 24` / `32×32` with no padding or `hitSlop`; cramped rows of tappable
  text. **Fix** ≥44×44 minimum (48 preferred) — grow with padding/`hitSlop`, keep visual size
  small if needed; every action reachable by touch **and** keyboard.
- **RNX-X-05 — Portrait lock** `P0` `⚙` — `"orientation": "portrait"` in `app.json`, or
  `ScreenOrientation.lockAsync(ScreenOrientation.OrientationLock.PORTRAIT_UP)`. **Fix** support
  both orientations unless the product truly can't; adapt the layout instead.
- **RNX-X-06 — Keyboard handling absent** `P0` `👁` — no `KeyboardAvoidingView`/`KeyboardAwareScrollView`,
  inputs buried under the software keyboard, `keyboardShouldPersistTaps: 'never'` swallowing
  taps, a submit button unreachable while typing. **Fix** per-platform avoidance
  (`behavior: 'padding'` iOS / `adjustResize` Android), scroll the focused input into view,
  and keep the primary action visible with the keyboard up.

---

## J. Code that produces generic UI

Structural smells that reliably produce a generic result even when the styling is fine.

### RNX-CD-01 — Raw visual values in `StyleSheet.create` `P0` `⚙`
**Signal** Spacing, radius, and type literals chosen per style block: `padding: 17`,
`marginTop: 12`, `borderRadius: 12`, `fontSize: 15`, `elevation: 4`, `width: 44` — plus
inline `style={{ gap: 10, paddingHorizontal: 24 }}` in JSX.
**Reads AI** The view is the design system, so nothing can be tuned centrally — and every
screen is free to invent its own values, which is exactly what generated code does.
**Fix** Tokens in one file (`space`, `radius`, `type`, `elevation`, `motion`), consumed by
role. `StyleSheet.create` files may *reference* tokens; literals live only in the token file.

### RNX-CD-02 — No theme: nothing consumes a token layer `P0` `👁`
**Signal** No `theme.ts` / `ThemeProvider` in the project; colors and sizes resolved ad hoc in
components; if a theme file exists, components still hand-build their own values.
**Reads AI** Per-screen invention is the root cause behind most of this catalog's color, type,
and shape tells — fix the root and a dozen findings disappear.
**Fix** One typed token object exposed via context (`useTheme()`), authored per the neutral
roles in `lx-obsidian` (`base · surface · ink · inkMuted · accent · <semantic>` plus scales),
with light/dark palettes resolved once at the provider.

### RNX-CD-03 — Unvirtualized `ScrollView` + `.map` `P0` `⚙`
**Signal**
```tsx
<ScrollView>
  {items.map((item) => <Row key={item.id} item={item} />)}
</ScrollView>
```
— every row mounted at once, regardless of list length.
**Reads AI** It is the canonical React-without-React-Native mistake: web thinking that shows
up on device as jank, memory spikes, and slow first paint — the app feels unfinished.
**Fix** `FlatList`/`SectionList` (or FlashList) with real props — `keyExtractor`,
`initialNumToRender`, `getItemLayout` where heights are fixed, `ListEmptyComponent` for
RNX-CM-01. Reserve `ScrollView` for genuinely bounded content.

### RNX-CD-04 — Boolean state soup `P1` `👁`
**Signal** `const [loading, setLoading] = useState(false); const [error, setError] = useState(null); const [empty, setEmpty] = useState(false);`
— tri-states that can contradict each other (loading *and* error), with rendering scattered
across `if` branches.
**Reads AI** The compiler can't force the states to be handled, so some aren't — and the
missing ones are always the ones the user hits.
**Fix** One discriminated union with a `status` discriminant (see RNX-CM-01); render from a
single switch so every state is exhaustive-checked by TypeScript.

### RNX-CD-05 — Strings inline in JSX `P1` `⚙`
**Signal** Copy hardcoded at the render site: `<Text>Settings</Text>`,
`<Button title="Retry" />`, `Alert.alert('Delete', 'Are you sure?')` — repeated per screen,
untranslatable, unreviewable.
**Reads AI** Unowned copy scattered through the render path; it can't be localized, audited,
or tuned without touching components.
**Fix** Centralize copy (a dictionary/i18n module), including button and error strings —
prepared for RTL and translation from day one.

### RNX-CD-06 — Duplicate components `P1` `👁`
**Signal** `ButtonNew`, `BetterCard`, a second `PrimaryButton`, two `Header` implementations
in different folders; the same card restyled per screen instead of reused.
**Reads AI** The same role solved repeatedly is the mark of generation without a system —
variants drift, and the app can't hold a consistent look.
**Fix** One canonical component per role; when a difference repeats and *means* something,
make it a named variant (`<Button variant="quiet">`), not a copy.

### RNX-CD-07 — `Dimensions.get('window')` without subscribing `P1` `⚙`
**Signal** `const { width } = Dimensions.get('window');` at module scope or in a component —
measured once, never updated on rotation, split-screen, fold, or a resize on web.
**Reads AI** Layout frozen at the first frame's geometry; the app misrenders the moment the
window changes, which reads as untested.
**Fix** `useWindowDimensions()` (subscribes and re-renders), or `Dimensions.addEventListener`
with cleanup when you need raw values outside React. See RNX-ST-05.

---

## Detectors

The `⚙` subset of this catalog is implemented by **`packages/eslint-plugin-lx-slop`** — an
ESLint AST plugin over JS/TS/JSX/TSX, which covers React Native, Expo, and React Native Web
alike (a `.tsx` screen is a `.tsx` screen, native or web). It implements the **universal rule
names** from `slop-taxonomy.md` so findings read the same as in every other stack:

| Rule | Catches |
|---|---|
| `hardcoded_color` | raw hex in `StyleSheet` / inline styles (RNX-CO-01, RNX-CD-01) |
| `hardcoded_spacing` | magic numeric spacing (RNX-SH-01, RNX-CD-01) |
| `hardcoded_radius` | one-radius literals (RNX-SH-02) |
| `hardcoded_font_size` | numeric `fontSize` (RNX-TY-04) |
| `hardcoded_elevation` | shadow-kit literals (RNX-SH-03) |
| `hardcoded_duration` | one-duration animations (RNX-MO-05) |
| `reflex_font` | known overused faces by name (RNX-TY-02) |
| `linear_motion` | linear/unset easing (RNX-MO-01) |
| `emoji_icon` | emoji used as icons (RNX-CM-05) |
| `orientation_lock` | portrait lock in `app.json` / screen-orientation APIs (RNX-X-05) |

What no detector does: copy quality, layout tension, palette harmony, whether the design has
*soul*, and everything `👁`. The tool narrows the search; a person decides.
