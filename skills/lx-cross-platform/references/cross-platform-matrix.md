# Cross-platform matrix

Contents
1. Targets
2. Width breakpoints and window classes
3. Region-by-region decision table
4. Per-stack adaptation cheat sheet
5. Typography and input differences
6. Navigation and routing
7. Interaction and input
8. Media and layout
9. API reference per stack
10. Verification checklist

---

## 1. Targets

| Target | Width | Input | Conventions to honor |
|---|---|---|---|
| Phone (Android/iOS) | < 600 | touch | platform nav pattern, system back / edge-swipe, safe areas, edge-to-edge |
| Tablet / foldable | 600–1199 | touch (+ stylus) | two-pane, larger targets, rail / sidebar |
| Desktop / laptop | ≥ 840, often ≥ 1200 | pointer + keyboard | hover, focus-visible, shortcuts, window resize, menus |
| Web mobile | < 600 | touch | touch behaviors, but real URLs and text selection |
| Web desktop | ≥ 840, often ≥ 1200 | pointer + keyboard | hover, focus-visible, shortcuts, scrollbars, top nav, URLs |
| TV / visionOS (SwiftUI) | varies | focus / gaze+gesture | focus engine, large targets, no hover assumptions |

Decide by **width and modality**, not OS or device sniffing.

## 2. Width breakpoints and window classes

Material 3 window size classes (adopt across all stacks for consistency):

| Class | Width | Typical |
|---|---|---|
| compact | < 600 | phone portrait |
| medium | 600–839 | phone landscape, small tablet, narrow web |
| expanded | 840–1199 | tablet, web |
| large | ≥ 1200 | desktop web |
| extra-large | ≥ 1600 | wide desktop |

Read the class from width (`LayoutBuilder`, `MediaQuery.sizeOf`, `BoxWithConstraints`, CSS media
queries, `horizontalSizeClass`, `useWindowDimensions`). Note `MediaQuery.sizeOf` triggers fewer
rebuilds than `MediaQuery.of`.

## 3. Region-by-region decision table

Fill per screen. For each region pick one option (stay / stack / reorder / collapse / scroll /
drawer / disappear).

| Region | Typical choice | Notes |
|---|---|---|
| Global nav | bottom/tab bar (compact) → rail (medium) → persistent sidebar (expanded) | every destination needs a URL on web |
| App bar / header | mobile: title + actions. Web/desktop: brand + top links + account | web shouldn't use a back arrow as main nav |
| Primary action | inline / app-bar button; FAB only if truly the single floating action | web/desktop often a top-right button |
| Content | one column → two column → content + rail | the flagship table/list is where reflow matters most |
| Secondary panel | bottom sheet (compact) → side panel (expanded) | never a modal on web desktop |
| Form | single column, full-width fields; submit + cancel | wide: label-left, submit inline |
| Table | cards/rows on compact, real data table on expanded | avoid horizontal squeeze on web |
| Footer | mobile: often none. Web: full footer | web users expect links there |
| Back behavior | mobile: system back / edge-swipe. Web: browser back, never trap | desktop: window controls |

## 4. Per-stack adaptation cheat sheet

| Concern | Flutter | Web | React Native | SwiftUI | Compose |
|---|---|---|---|---|---|
| Read width | `LayoutBuilder`, `MediaQuery.sizeOf` | `@media`, `ResizeObserver`, `matchMedia` | `useWindowDimensions` | `horizontalSizeClass`, `GeometryReader` | `BoxWithConstraints` |
| Responsive layout | `Row`/`Wrap`, `Flex` | CSS Grid/Flexbox | `flexDirection` via width | `ViewThatFits`, `NavigationSplitView` | `WindowSizeClass`, `Row` |
| Adaptive nav | `NavigationBar`/`NavigationRail`/`NavigationDrawer` | nav component + routes | tab vs drawer by width | `TabView` / `NavigationSplitView` | `NavigationBar` / `NavigationRail` |
| Hover/focus | `FocusableActionDetector` + `MouseRegion` | CSS `:hover` / `:focus-visible` | `Pressable` state, `onHoverIn` | `.onHover`, `.hoverEffect`, focus | `InteractionSource` collect hovered/focused |
| Real URLs / deep links | `go_router` / `RouterLink` | router (Next/Vue/SvelteKit) | `expo-router` / linking | `NavigationStack` path, `onOpenURL` | Navigation + deep links |
| Reduce motion | `MediaQuery.disableAnimationsOf` | `prefers-reduced-motion` | `AccessibilityInfo` | `@Environment(\.accessibilityReduceMotion)` | `LocalAccessibilityManager` |
| Text scale | `textScaler` | `rem`, zoom | `allowFontScaling` | Dynamic Type | `fontScale` |

## 5. Typography and input differences

- **Measure:** cap the readable column (`ConstrainedBox(maxWidth: 720)` / `max-width: 65ch` /
  `frame(maxWidth:)`). Never let body text span 1600px.
- **Text scale:** honor system font scale and browser zoom. Test 130–200%; nothing clipped.
- **Pointer vs touch:** touch targets ≥ 48dp; pointer targets can be denser, never below ~32dp.
- **Cursors:** pointer targets show a click cursor; touch ignores it harmlessly.
- **Selection:** allow text selection in web/desktop content areas.

## 6. Navigation and routing

- One route model per app; on web it must yield **real URLs**; on mobile real deep links. Refresh
  and share must land on the same screen.
- Browser back must not trap; Android predictive back and iOS edge-swipe must work.
- Wide windows: replace bottom nav with a rail or persistent sidebar; don't leave a bottom bar on
  a 1200px window.
- Provide an obvious way back from any nested screen; never rely on a lone back arrow on web.

## 7. Interaction and input

| Concern | Touch (mobile/tablet) | Pointer + keyboard (web/desktop) |
|---|---|---|
| Hover | none | required feedback on interactive elements |
| Focus | visible for keyboard/switch users | required `:focus-visible` ring, logical order |
| Keyboard | Tab / Enter / Space / back | shortcuts (⌘K, Esc), full tab order |
| Text selection | long-press | drag-select, copy |
| Scrolling | fling | wheel + trackpad, visible scrollbars |
| Gestures | swipe/tap | avoid gesture-only actions; provide a visible control |
| Pointer ripple | ok on touch | a ripple on every hover feels off on web/desktop |

Any custom interactive widget must implement hover, focus, and press for the pointer case.

## 8. Media and layout

- Images: request the right size (Flutter `cacheWidth`/`cacheHeight`; CSS `srcset`/`sizes`; RN
  `resizeMode` + appropriately sized assets; SwiftUI `AsyncImage`; Compose Coil sizing).
- Keep proportions across widths (`AspectRatio`/`FittedBox`, CSS `aspect-ratio`, SwiftUI
  `.aspectRatio`).
- Avoid fixed pixel heights for content blocks; let them size to content.
- Safe areas: honor notches/insets on mobile/desktop; web needs margins, not notch insets.
- Avoid orientation lock unless the product truly cannot work otherwise (`orientation_lock`).

## 9. API reference per stack

**Flutter:** `LayoutBuilder`, `MediaQuery.sizeOf`, `NavigationBar`/`NavigationRail`/
`NavigationDrawer`, `Switch.adaptive`/`Slider.adaptive`, `FocusableActionDetector`, `MouseRegion`,
`Shortcuts`+`Intent`+`Actions`, `SelectionArea`, `ScrollConfiguration`+`Scrollbar`, `go_router`,
`PageTransitionsTheme`, `MediaQuery.disableAnimationsOf`.

**Web:** CSS Grid/Flexbox, container queries, `@media (prefers-color-scheme / reduced-motion /
hover / pointer)`, `:focus-visible`, `clamp()`/`min()`/`max()`, `rem`, `Intl` for locale, framework
router (Next `app/`, Vue Router, SvelteKit).

**React Native:** `useWindowDimensions`, `Platform.select`, `Pressable`, `Modal`, `SafeAreaView`
(context), `expo-router`/`Linking`, `AccessibilityInfo`, `Appearance`, `DynamicColorIOS`,
`allowFontScaling`.

**SwiftUI:** `horizontalSizeClass`/`verticalSizeClass`, `NavigationSplitView`, `NavigationStack`,
`TabView`, `ViewThatFits`, `.onHover`, `.hoverEffect` (visionOS), `@Environment(\.dynamicTypeSize)`,
`@Environment(\.colorScheme)`, `@Environment(\.accessibilityReduceMotion)`, `GeometryReader`,
`MenuBarExtra`.

**Compose:** `BoxWithConstraints`, `WindowSizeClass`, `NavigationBar`/`NavigationRail`,
`InteractionSource` hover/focus collection, `rememberWindowInsets`, `LocalConfiguration` font
scale, `LocalAccessibilityManager`, desktop `Window`/`MenuBar`, adaptive layouts.

## 10. Verification checklist

Run through this for every screen that ships on more than one target:

- [ ] Tested at 320 / 600 / 840 / 1200 / 1920 (or device equivalents).
- [ ] No horizontal overflow at the narrowest width.
- [ ] Keyboard-only pass: reachable, focus visible, logical order, `Esc` works.
- [ ] Hover feedback on every interactive element (pointer targets).
- [ ] Real URLs / deep links: each screen linkable and refreshable; back works (web).
- [ ] Mobile system back / edge-swipe handled; predictive back not broken.
- [ ] Touch targets ≥ 48dp on touch targets.
- [ ] Text scale at 130% and 200%: nothing clipped.
- [ ] Reduce-motion: content visible, final states shown.
- [ ] Nav adapts: no bottom bar on wide windows; no phone column centered in desktop.
- [ ] Copy, states, and empty/error layouts consistent across targets.
- [ ] `lx-slop-guard` cross-platform rules pass (`orientation_lock`, hardcoded layout, etc.).
