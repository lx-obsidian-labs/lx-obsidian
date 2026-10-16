# Rule index (all detectors)

One vocabulary across every stack. Each detector implements the **same universal snake_case rule
names** from `lx-obsidian`'s `slop-taxonomy.md`, so a finding reads the same everywhere and CI
gates are written once.

| Detector | Stack | Rule-id form | Suppress |
|---|---|---|---|
| `lx_slop_lint` (Dart analyzer plugin) | Flutter/Dart | `hardcoded_color` | `// ignore: hardcoded_color` |
| `eslint-plugin-lx-slop` | JS/TS/JSX/TSX (React/Next/Vue/Svelte, React Native/Expo) | `lx-slop/hardcoded-color` | `// eslint-disable-next-line lx-slop/hardcoded-color` |
| `stylelint-lx-slop` | CSS/SCSS/PostCSS | `lx-slop/hardcoded-color` | `/* stylelint-disable-next-line lx-slop/hardcoded-color */` |
| `.swiftlint.yml` | SwiftUI | `lx_slop_hardcoded_color` | `// swiftlint:disable:next lx_slop_hardcoded_color` |
| `detekt.yml` | Jetpack Compose | `LxSlopHardcodedColor` | `@Suppress("LxSlopHardcodedColor")` |

A finding is a **"look here"**, not a verdict. Fix the root; suppress only with a reason.

---

## Categories

| Prefix | Meaning |
|---|---|
| `hardcoded_*` | raw visual values in view code |
| `framework_color`, `default_theme` | framework defaults left in place |
| `reflex_font` | a known overused display face by name |
| `linear_motion`, `hardcoded_duration` | motion-system issues |
| `emoji_icon` | emoji used as an icon |
| `orientation_lock` | adaptability / cross-platform issues |

---

## hardcoded_color `P0`
- **Tell:** B3 (raw color). **Matches:** `Color(0x…)`, `Color.fromARGB(…)` (Dart); hex/`rgb()`/
  `hsl()` literals and framework color tokens (CSS/JS); `Color(0xFF…)`/`Color(red=…)` (Compose);
  `Color(0x…)`/`.init(red:…)` (SwiftUI).
- **Fix:** reference a `colorScheme` role / CSS variable / theme token.
- **Dart:** `// ignore: hardcoded_color` · **ESLint/Stylelint:** `lx-slop/hardcoded-color` ·
  **Swift:** `lx_slop_hardcoded_color` · **Kotlin:** `LxSlopHardcodedColor`.

## framework_color `P0`
- **Tell:** B2 (swatch literal). **Matches:** `Colors.<swatch>` used as a UI role
  (`Colors.transparent` allowed); Tailwind palette literals (`bg-indigo-500`); `Color.Red`/
  `MaterialTheme.colorScheme` defaults; `Color.blue` (SwiftUI).
- **Fix:** use semantic roles.
- **Suppress:** same as above with `framework_color`.

## default_theme `P0`
- **Tell:** B1 (default theme). **Matches:** `ColorScheme.fromSeed(seedColor: Colors.deepPurple |
  indigo | blue | purple | violet)` (Dart); the stock Tailwind/Bootstrap palette as the whole
  system (Stylelint/ESLint); `dynamicColorScheme()`/default M3 seed (Compose); default
  `.accentColor`/tint (SwiftUI).
- **Fix:** a deliberate seed + hand-tuned scheme, or an authored theme.
- **Suppress:** `// ignore: default_theme`.

## hardcoded_spacing `P0`
- **Tell:** D1 (magic spacing). **Matches:** numeric literals in `EdgeInsets.*`,
  `SizedBox(height|width|dimension:)`, `Container(height|width:)` (Dart); `margin`/`padding`/`gap`
  with `px` (CSS); `padding: 16` (Compose); `.padding(16)` (SwiftUI).
- **Fix:** spacing tokens (`AppTokens` / CSS variables / `MaterialTheme.spacing`).
- **Suppress:** `// ignore: hardcoded_spacing`.

## hardcoded_radius `P1`
- **Tell:** D2 (one radius). **Matches:** `BorderRadius.circular(n)`, `Radius.circular(n)`
  (Dart); `border-radius: 8px` (CSS); `RoundedCornerShape(8.dp)` (Compose);
  `cornerRadius(8)` (SwiftUI).
- **Fix:** a radius ladder.
- **Suppress:** `// ignore: hardcoded_radius`.

## hardcoded_font_size `P0`
- **Tell:** C1 (default type). **Matches:** `fontSize:` literal in a `TextStyle` (Dart);
  `font-size: 22px` (CSS); `fontSize = 22.sp` (Compose); `.font(.system(size: 22))` (SwiftUI).
- **Fix:** resolve from `TextTheme` / type scale.
- **Suppress:** `// ignore: hardcoded_font_size`.

## hardcoded_elevation `P1`
- **Tell:** D3/D4 (shadow). **Matches:** `elevation:` literal on `Card`/`Material`/`PhysicalModel`
  and `blurRadius`/`spreadRadius` on `BoxShadow` (Dart); `box-shadow:` literals (CSS);
  `shadowElevation`/`CardDefaults.cardElevation` (Compose); `.shadow(radius:)` (SwiftUI).
- **Fix:** an elevation ladder, or borders/tonal surfaces.
- **Suppress:** `// ignore: hardcoded_elevation`.

## hardcoded_duration `P1`
- **Tell:** F5 (one duration). **Matches:** `Duration(milliseconds: n)` in animation code (Dart);
  `transition-duration`/`animation-duration` literals (CSS); `tween(durationMillis=…)` (Compose);
  `.animation(.easeInOut(duration: 0.3))` (SwiftUI).
- **Fix:** a motion-duration scale.
- **Suppress:** `// ignore: hardcoded_duration`.

## reflex_font `P1`
- **Tell:** C2 (reflex font). **Matches:** a known overused display face by name (Inter, Poppins,
  Montserrat, Lato, Roboto as the *display* face, etc.) (Dart/web/SwiftUI/Compose).
- **Fix:** a face chosen for the subject.
- **Suppress:** `// ignore: reflex_font`.

## linear_motion `P1`
- **Tell:** F2 (linear/default curve). **Matches:** `Curves.linear` (Dart); `linear` easing (CSS);
  `LinearEasing` (Compose); `.linear` (SwiftUI).
- **Fix:** ease-out / ease-in / spring tokens.
- **Suppress:** `// ignore: linear_motion`.

## emoji_icon `P0`
- **Tell:** E5 (emoji as icon). **Matches:** an emoji-only string used as an icon/bullet.
- **Fix:** an icon set, or a deliberate voice-driven use.
- **Suppress:** `// ignore: emoji_icon`.

## orientation_lock `P0`
- **Tell:** I5 (orientation lock). **Matches:** `SystemChrome.setPreferredOrientations(` (Dart);
  `orientation` in `app.json`/screen-orientation APIs (RN/Expo); `android:screenOrientation`/
  `requestedOrientation` (Compose/Android); `UISupportedInterfaceOrientations` restricting to one
  (SwiftUI).
- **Fix:** support both orientations unless truly impossible.
- **Suppress:** `// ignore: orientation_lock`.

---

## Not (yet) machine-detected — use the packs and eyes

These are `👁` tells; no reliable static check exists, and a regex version would over-trigger:
whole-theme-absence context; `uppercase-eyebrow`; `gradient-literal`; `spinner-only-loading`;
`default-appbar`; `reduce-motion-ignored`; `scroll-gated-content`; `missing-hover-focus`;
`fixed-width-layout`; `non-adaptive-nav`; `inline-strings`; `fab-on-every-screen`; and every
copy, layout, palette-harmony, and "soul" tell.

The scanner scripts add best-effort regex for some of these; all remain advisory.

---

## Detector parity & caveats

- **Dart plugin:** only reports inside `lib/`; `dart analyze <folder>` misses plugin diagnostics
  ([dart-lang/sdk#62710]); `flutter analyze` may not surface them ([flutter/flutter#187999]).
  Use `dart analyze <file>` or the IDE. Verified with `analyzer_testing`.
- **ESLint / Stylelint:** Node-based; run against JS/TS/JSX/TSX and CSS/SCSS respectively.
  Rule ids are kebab-case (`lx-slop/hardcoded-color`).
- **SwiftLint:** custom rules are regex-based (SwiftLint has no custom-AST API); heuristic.
- **detekt:** Kotlin-AST-based where the custom ruleset is built; otherwise use the built-in
  subset documented in `lint/compose/README.md`.

`scripts/lx_scan.ps1` and `scripts/lx_scan.sh` implement the rules above with `Select-String`
and `grep` for the no-detector case. They report `file:line  rule  severity  message` and honor
the stack's ignore comment. Keep rule text in sync with this file.

[dart-lang/sdk#62710]: https://github.com/dart-lang/sdk/issues/62710
[flutter/flutter#187999]: https://github.com/flutter/flutter/issues/187999
