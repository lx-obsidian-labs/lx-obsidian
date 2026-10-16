---
name: lx-cross-platform
description: Make one codebase feel native on every platform it targets — mobile, tablet, desktop, and web — without shipping "a phone app in a browser" or "Material on a desktop". Use when a screen must run on more than one width, input modality, or OS; when deciding navigation, controls, input, or layout per platform; or when you need the adaptation decision matrix. Covers Flutter (Android/iOS/web/desktop), Web (React/Next/Vue/Svelte), React Native/Expo (iOS/Android/web), SwiftUI (iPhone/iPad/Mac/visionOS), and Jetpack Compose (phone/tablet/foldable/desktop).
license: Proprietary
---

# Cross-platform

One codebase across many screens is efficient — and the fastest way to look generated if you let
the framework's default surface leak onto every platform. This skill is about adapting the same
product to each target on purpose, by **width and input modality first, OS and framework second**.
The full decision matrix lives in `references/cross-platform-matrix.md`.

## The one rule

**Same product, same content, same states — different presentation.** Fork layout, navigation,
and input handling per target; never fork the brand or the copy. Every deviation must be
justifiable in one sentence ("rail instead of bottom bar because the window is 1200px").

## The ladder (apply in this order)

1. **Width / window class** — responsive layout. Read width, not the OS.
   - Compact `<600` · Medium `600–839` · Expanded `840–1199` · Large `≥1200` · XL `≥1600` (dp/CSS px).
2. **Input modality** — touch, pointer, keyboard, or combinations. Determines hit targets, hover,
   focus, and shortcuts.
3. **Platform conventions** — nav pattern, back behavior, scroll physics, controls, URL semantics.
4. **Brand tokens** — the theme dresses whatever the platform convention requires.

Rendering decisions by OS flag (`Platform.isAndroid`, `navigator.userAgent === "iPhone"`) is the
top tell. `Platform.isAndroid` is wrong on web *and* on large Android screens.

## Per-target conventions

| Target | Framework | Nav pattern | Back | Input | Notes |
|---|---|---|---|---|---|
| Android phone | Flutter / Compose / RN | bottom nav / nav bar | system + predictive back | touch | Material 3, edge-to-edge, safe areas |
| Android tablet/foldable | same | rail / two-pane | system | touch (+stylus) | larger targets, list-detail |
| iOS | Flutter / SwiftUI / RN | tab bar | swipe + nav back | touch | Dynamic Island/notch insets, SF-style transitions |
| iPad / Mac (SwiftUI) | SwiftUI | sidebar / tabs | hardware/gesture | touch + pointer | SidebarAdaptable, hover, menu bar |
| Web mobile | React/Vue/Svelte/HTML | bottom/top nav | browser back | touch | real URLs, text selection |
| Web desktop | same | top nav / sidebar | browser back | pointer + keyboard | hover, focus-visible, shortcuts, scrollbars, URLs |
| React Native Web / Expo | RN | per breakpoint | platform | all | RN primitives degrade to web; test separately |
| Desktop (Compose/SwiftUI) | Compose/SwiftUI | menu + sidebar | window controls | pointer + keyboard | hover, density, window resizing |

Pick one framework pack (`lx-flutter-tells`, `lx-web-tells`, `lx-react-native-tells`,
`lx-swiftui-tells`, `lx-compose-tells`) alongside this skill — the tells are stack-specific, the
adaptation logic here is shared.

## The adaptation menu

Per region, choose exactly one and record it in the surface contract:

| Choice | Meaning |
|---|---|
| **Stay** | identical everywhere; content and simple controls |
| **Stack** | side-by-side becomes stacked (or vice versa) as width changes |
| **Reorder** | order changes to match reading/interaction priority |
| **Collapse** | a full panel becomes a summary + detail view |
| **Scroll** | overflow becomes scrollable rather than clipped |
| **Drawer** | persistent nav becomes a drawer / bottom bar |
| **Disappear** | chrome not needed on that target is removed |

## Navigation

- **One route model, real destinations.** On web and desktop this means real URLs / deep links;
  on mobile, deep links and restore-back-stack. Refresh and share must land on the same screen.
- **Adapt the shell to width:** bottom nav (compact) → rail (medium) → persistent multi-column
  sidebar (expanded/large). Never leave a bottom bar on a 1400px window.
- **Respect each back mechanism:** Android predictive back, iOS edge-swipe, browser back/forward,
  desktop window controls. Never trap the user.

## Interaction: the two hard rules

- **Touch:** ≥48dp/px targets, generous hit areas, no hover-only affordances. Everything reachable
  by tap *and* keyboard.
- **Pointer/keyboard:** visible hover, a `:focus-visible` ring, logical tab order, working
  `Esc`/shortcut keys, visible scrollbars, and text selection in content areas.

Both: respect system text scale / browser zoom, safe areas, and reduce-motion.

## Recipes

**Width-driven layout (Flutter):**
```dart
LayoutBuilder(builder: (context, c) {
  final wide = c.maxWidth >= AppBreakpoints.expanded;
  return wide ? const _TwoPane() : const _Stacked();
});
```

**Width-driven layout (CSS / web):**
```css
.grid { display: grid; grid-template-columns: 1fr; gap: var(--space-4); }
@media (min-width: 840px) { .grid { grid-template-columns: 2fr 1fr; } }
```

**Width-driven layout (SwiftUI):**
```swift
@Environment(\.horizontalSizeClass) private var size
var body: some View { size == .regular ? AnyView(TwoPane()) : AnyView(Stacked()) }
```

**Width-driven layout (Compose):**
```kotlin
BoxWithConstraints {
  if (maxWidth >= 840.dp) TwoPane() else Stacked()
}
```

**Custom control: hover + focus + press (Flutter):**
```dart
FocusableActionDetector(
  onShowHoverHighlight: (v) => setState(() => _hover = v),
  onShowFocusHighlight:  (v) => setState(() => _focus = v),
  actions: <Type, Action<Intent>>{ ActivateIntent: CallbackAction<ActivateIntent>(onInvoke: (_) { _go(); return null; }) },
  child: MouseRegion(
    cursor: _disabled ? SystemMouseCursors.basic : SystemMouseCursors.click,
    child: GestureDetector(onTap: _disabled ? null : _go, child: child),
  ),
)
```

**Custom control states elsewhere:** web has `:hover`/`:focus-visible`/`:active` natively; React
Native has `Pressable`/`Pressable`-style state callbacks; SwiftUI has `.hoverEffect` / `.onHover`;
Compose has `InteractionSource.collectIsHoveredAsState()` / `collectIsFocusedAsState()`.

## Anti-patterns (the tells)

- Branching layout on the **OS** instead of width/modality.
- Bottom nav (or a phone-width column) on a desktop-width window.
- No URLs / broken browser back on web; gesture-only actions with no visible control.
- Touch-only custom controls with no hover/focus.
- Locking orientation for convenience (`orientation_lock`).
- Assuming a mouse on mobile or touch on desktop; assuming light/dark from the platform default.
- Shipping the same default framework surface (Material/Cupertino-equivalents) on all targets.

## Verify

Run the checklist in `references/cross-platform-matrix.md`: 320 · 600 · 840 · 1200 · 1920 widths;
keyboard-only; touch; text scale 130–200%; reduce-motion; and for web — real URLs, refresh, and
back. Then run the stack's detector (`lx-slop-guard`) for the code-certain tells.
