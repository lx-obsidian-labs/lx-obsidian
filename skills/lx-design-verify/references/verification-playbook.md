# Verification playbook

The pre-ship checklist. Run every section; note failures with a screenshot reference.

Contents
1. Setup
2. Capture matrix
3. State completeness
4. Accessibility
5. Contrast pairs to check
6. Typography and rhythm
7. Cross-platform
8. Motion
9. Catalog score
10. Machine pass
11. Blind test
12. Report template

---

## 1. Setup

Launch the real target. Examples per stack:

```powershell
# Flutter
flutter pub get; dart analyze lib; flutter run -d chrome; flutter run

# Web (Next / Vite / SvelteKit)
npm install; npm run dev

# React Native / Expo
npx expo start            # press w for web, i/a for device

# SwiftUI — run the scheme in Xcode (iPhone + iPad + macOS if it ships)
# Compose — run on emulator/device; run the desktop target if it ships
```

Enable the platform's a11y tooling (Flutter Inspector, axe/Lighthouse, Accessibility Inspector,
TalkBack) for label/target checks.

## 2. Capture matrix

For each screen, produce:

| State | compact (≤599) | medium (600–839) | expanded (840–1199) | large (≥1200) |
|---|---|---|---|---|
| populated light | ☐ | ☐ | ☐ | ☐ |
| populated dark | ☐ | ☐ | ☐ | ☐ |
| empty | ☐ | ☐ | ☐ | |
| loading | ☐ | ☐ | | |
| error | ☐ | ☐ | | |
| disabled | ☐ | ☐ | | |
| no-results | ☐ | ☐ | | |
| overflow (long/‌many) | ☐ | ☐ | ☐ | ☐ |

Web/desktop extras: one keyboard-focus capture, one hover capture.

## 3. State completeness

- [ ] Every state in the surface contract exists and uses the **same** frame/components.
- [ ] Loading preserves layout (no jump); long waits show progress or a steps model.
- [ ] Empty states explain *why* and offer the useful next action.
- [ ] No-results states name the active filter and offer a clear.
- [ ] Errors say what failed, what is safe, and how to recover (with a retry).
- [ ] Disabled controls state why they are disabled.
- [ ] Permission-denied explains what can be seen/requested.
- [ ] Overflow: long titles, long values, many rows — nothing clips or breaks.

## 4. Accessibility

- [ ] Contrast: body ≥ 4.5:1; large ≥ 3:1; both themes (see §5).
- [ ] Keyboard: all interactive elements reachable, logical order, visible focus, `Esc` closes
  overlays.
- [ ] Screen reader: every icon-only control has a label; images have semantics; headings are
  marked (Flutter `Semantics`/`tooltip`, web `aria-label`/roles, RN `accessibilityLabel`,
  SwiftUI `.accessibilityLabel`, Compose `contentDescription`).
- [ ] Tap targets ≥ 48dp (Material) / ≥ 44pt (Apple).
- [ ] Text scale 130% and 200%: no clipping/overlap; layouts grow.
- [ ] Reduce-motion: content present; final states shown.
- [ ] Color not the sole carrier of meaning.
- [ ] Focus-visible ring is not removed without a replacement.

## 5. Contrast pairs to check

List every text/background pair from `DESIGN.md` and verify:

| Pair | Theme | Ratio | ≥ target? |
|---|---|---|---|
| ink / base | light | | 4.5 |
| inkMuted / base | light | | 4.5 (or 3 if large) |
| ink / surface | light | | 4.5 |
| accentInk / accent | light | | 4.5 |
| ink / base | dark | | 4.5 |
| inkMuted / surface | dark | | 4.5 |
| accent / base | dark | | 3 (non-text) |

The muted ink is the usual failure. Fix the token, not the one widget.

## 6. Typography and rhythm

- [ ] Body measure 45–70 chars (capped column on wide windows).
- [ ] Display sizes genuinely large; hierarchy visible in a thumbnail.
- [ ] Leading 1.5–1.6 body; 1.0–1.1 display with slight negative tracking.
- [ ] Tabular figures on numbers that change/align.
- [ ] No single-word accent in a heading.
- [ ] Section spacing consistent; baselines align to the scale.

## 7. Cross-platform

Run `lx-cross-platform`'s checklist in full. Minimum:
- [ ] 320/600/840/1200/1920 widths, no horizontal overflow.
- [ ] Keyboard-only pass; hover feedback; real URLs; browser back works (web/desktop).
- [ ] Mobile system back / predictive back handled (Android); edge-swipe (iOS).
- [ ] No bottom bar on wide windows; no centered phone column on desktop.
- [ ] Both orientations (unless genuinely impossible).

## 8. Motion

- [ ] Each animation shows a state change, directs attention, or rewards interaction — else cut.
- [ ] One orchestrated load moment, not a uniform fade-up on every section.
- [ ] Ease-out entrances, ease-in exits, springs for drag; no linear UI affordance.
- [ ] Reduce-motion honored.
- [ ] No content gated on scroll/entrance animation.

## 9. Catalog score

Run the matching tell-pack audit (0–20, lower better): `lx-flutter-tells`, `lx-web-tells`,
`lx-react-native-tells`, `lx-swiftui-tells`, or `lx-compose-tells`. Record the per-section
breakdown and the P0s. Compare to the previous pass; do not reland a fixed tell.

## 10. Machine pass

```powershell
# Flutter/Dart (lx_slop_lint configured)
dart analyze lib/screens/home.dart

# Web / React Native
npx eslint .

# CSS/SCSS
npx stylelint "**/*.css"

# SwiftUI / Compose
swiftlint lint --config lint/swiftui/.swiftlint.yml
detekt --config lint/compose/detekt.yml

# Fallback (any stack, no toolchain)
pwsh scripts/lx_scan.ps1 -Path lib -MinSeverity P1
```

Record counts by rule; the top 3 fixes by leverage are usually: the seed/theme, the token layer,
and the state type. See `lx-slop-guard` for detector details and caveats.

## 11. Blind test

- [ ] Screenshot; cover the logo and product name.
- [ ] Copy test: could this copy sit on a competitor's app unchanged? (If yes → +3, the biggest
  tell.)
- [ ] Name the one element that could not come from a template. If none → add the 20%.

## 12. Report template

```
Surface(s): <list>
Catalog score: <n>/20  (prev <n>)
P0 findings: <file:line or screenshot>
Cross-platform: <pass / issues>
Analyzer: <counts by rule>
Needed fixes (by leverage): 1) _  2) _  3) _
Changed since last pass: _
```
