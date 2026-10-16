# DESIGN.md template

Write this file at the project root and re-read it every session. It is the contract that stops
session two from drifting from session one. It follows the open `DESIGN.md` format (palette / type
/ layout / principles) with a tokens section added. It is **stack-neutral**: the same contract
drives a Flutter theme, a CSS custom-property sheet, a React Native theme object, a SwiftUI asset
catalog, or a Compose `MaterialTheme`.

Keep it under a page. If a value is not here, it does not belong in a view.

---

```markdown
# <Product> — design contract

stack: <flutter | web | react-native | swiftui | compose>
register: <expressive | utility>

## Direction (one line)
<The single idea. "X, but as if it were a printed receipt." If you can't finish "this is the one
that…", it's generic.>

## Surfaces
| Surface | User | Job | Primary action | <platform A vs B> |
|---|---|---|---|---|
| <route> | | | | |

## Palette (named roles → value)
- base        #______   page background
- surface     #______   raised (cards, sheets)
- surfaceAlt  #______   subtle (wells, zebra rows)
- ink         #______   primary text
- inkMuted    #______   secondary text
- accent      #______   the one accented thing (selection/primary action)
- accentInk   #______   text/icon on accent
- <semantic>  #______   e.g. danger
> neutrals derived from: <hue/approach>. Accent visible uses per screen: ≤ 2.
> dark theme: <how it differs — not an inversion>.

## Type
- display: <Family> — headings, hero
- body:    <Family> — UI text and content
- scale:   display / title / body / label (+ sizes, weight, tracking)
- figures: tabular for all numbers that change or align

## Space (base 4 or 8)
- xs _  sm _  md _  lg _  xl _  gutter _

## Shape (a ladder, not one radius)
- control _  surface _  pill _

## Elevation
- <ladder, or "none — tonal surfaces + hairline borders">

## Motion tokens
- fast _ms / base _ms / slow _ms
- curves: enter <ease-out> · exit <ease-in> · drag <spring>
- reduced-motion: show final state

## Layout
- concept: <one-sentence prose + optional ASCII wireframe>
- alignment: <left | center | justified>
- breakpoints: compact <600 · medium 600–839 · expanded 840–1199 · large ≥1200

## Principles (what makes this one unique)
- <3–5 lines. The reason each bold move exists.>
```

---

## Emitting the tokens in each stack

The contract above is the source of truth. Mirror it in the stack's mechanism so no view ever
sees a raw value. The same roles map to each:

### Flutter — one `AppTokens` `ThemeExtension`

```dart
@immutable
class AppTokens extends ThemeExtension<AppTokens> {
  const AppTokens({
    required this.spaceXs, required this.spaceSm, required this.spaceMd,
    required this.spaceLg, required this.spaceXl,
    required this.radiusControl, required this.radiusSurface, required this.radiusPill,
    required this.motionFast, required this.motionBase, required this.motionSlow,
    required this.curveEnter, required this.curveExit,
  });

  final double spaceXs, spaceSm, spaceMd, spaceLg, spaceXl;
  final BorderRadius radiusControl, radiusSurface, radiusPill;
  final Duration motionFast, motionBase, motionSlow;
  final Curve curveEnter, curveExit;

  @override
  AppTokens copyWith({ /* ... */ }) => /* ... */ this;

  @override
  AppTokens lerp(AppTokens? other, double t) {
    if (other == null) return this;
    return AppTokens(spaceXs: lerpDouble(spaceXs, other.spaceXs, t)! /* ... lerp every field */);
  }
}

// register in both themes, then:
extension AppTokensX on BuildContext {
  AppTokens get tokens => Theme.of(this).extension<AppTokens>()!;
  ColorScheme get colors => Theme.of(this).colorScheme;
  TextTheme get text => Theme.of(this).textTheme;
}
```
Read `context.tokens.spaceMd` / `context.colors.primary` — never `16` or `Color(0xFF…)`.

### Web / CSS — custom properties

```css
:root {
  --base: #fbfaf7; --surface: #ffffff; --ink: #1b1a17; --ink-muted: #6b6459;
  --accent: #b4472f; --accent-ink: #fff8f4;
  --space-sm: .5rem; --space-md: 1rem; --space-lg: 2rem;
  --radius-control: 6px; --radius-surface: 14px; --radius-pill: 999px;
  --dur-fast: 120ms; --dur-base: 240ms; --ease-enter: cubic-bezier(.2,.7,.2,1);
}
```
Tailwind: map the same names into `theme.extend` (`colors.surface`, `spacing.md`,
`borderRadius.surface`, `transitionDuration.base`) so the utilities exist. **Never** write
`bg-indigo-600`, `p-[16px]`, or a hex in JSX/CSS-in-JS.

### React Native — one typed token object

```ts
export const tokens = {
  color: { base:'#fbfaf7', surface:'#ffffff', ink:'#1b1a17', inkMuted:'#6b6459', accent:'#b4472f' },
  space: { sm: 8, md: 16, lg: 32 },
  radius:{ control: 6, surface: 14, pill: 999 },
  motion:{ fast: 120, base: 240 },
} as const;
```
Read `tokens.color.surface`; never a hex in a `StyleSheet`.

### SwiftUI — asset catalog + extensions

```swift
// Colors in Assets.xcassets (light/dark variants), spacing/radius as constants.
extension Color { static let base = Color("Base"); static let surface = Color("Surface")
                  static let ink = Color("Ink"); static let accent = Color("Accent") }
extension CGFloat { static let spaceSm: CGFloat = 8; static let spaceMd: CGFloat = 16
                    static let radiusSurface: CGFloat = 14 }
```
Read `.foregroundStyle(.ink)`, `.padding(.spaceMd)`; never `Color(red:…)` or `Color.blue` inline.

### Jetpack Compose — `MaterialTheme` extension

```kotlin
@Immutable data class AppSpacing(val sm: Dp = 8.dp, val md: Dp = 16.dp, val lg: Dp = 32.dp)
val LocalSpacing = staticCompositionLocalOf { AppSpacing() }
// extend MaterialTheme.colorScheme with the authored palette; read MaterialTheme.colorScheme.surface,
// LocalSpacing.current.md; never Color(0xFF…) or 16.dp inline.
```

All five are enforced by their stack's detector (`lx-slop-guard`).
