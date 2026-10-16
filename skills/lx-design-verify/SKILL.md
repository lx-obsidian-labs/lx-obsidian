---
name: lx-design-verify
description: Verify Flutter UI before calling it done - run the app, capture real states at real breakpoints, audit contrast and accessibility, test text scaling and reduce-motion, and answer "does this actually not look AI-generated". Use after building or redesigning any Flutter screen, when preparing UI work for review or shipping, or when you need the pre-ship checklist. Complements lx-flutter-tells (what to look for) and lx-slop-guard (the machine pass).
license: MIT
---

# Design verification

Code review catches code. This skill catches the *result*. A screen is not done until it has
been rendered, captured in its states, and audited. The full checklist is in
**`references/verification-playbook.md`**.

## The loop

1. **Run it.** `flutter run` (device/emulator) and `flutter run -d chrome` / `web-server`.
   Never verify from source alone.
2. **Capture states, not just the happy path.** For each screen: loading, empty, populated,
   no-results, error, disabled, permission-denied, overflow (long content), and success. Use the
   surface contract's state list.
3. **Capture breakpoints.** 320 · 600 · 840 · 1200 · 1920 px (resize the browser; use the
   emulator's smallest size on Android). Both orientations.
4. **Audit a11y.** Contrast pairs, focus order, screen-reader labels, tap target sizes, text
   scale 130% and 200%, reduce-motion.
5. **Score against the catalog.** Run the `lx-flutter-tells` audit (0–20) and the
   `lx-cross-platform` checklist.
6. **Machine pass.** `dart analyze` with `lx_slop_lint`, plus the scanner if needed.
7. **The blind test.** Screenshot; cover the logo; can an outsider name the product? Is the copy
   substitutable onto a competitor? If yes, it still reads generated — go back to the 20%.

## The screenshot set (per screen)

Capture at minimum, as PNGs, in one folder:

- compact populated, medium populated, expanded populated
- dark + light for the populated state
- empty, loading, error, disabled
- one "overflow" case (very long title, 40-char value, 200 rows)
- one keyboard-focus shot (web) and one hover shot (web)

Naming: `screen__state__width__theme.png`. Difficile-to-eyeball problems (contrast, rhythm,
alignment) show up instantly this way.

## Contrast and a11y

- Body text ≥ 4.5:1, large text ≥ 3:1, on every surface, in both themes. Check the muted ink —
  it is the usual offender.
- Focus visible on every interactive element; logical tab order; `Esc` closes overlays.
- Every icon-only control has a semantic label (`Semantics`/`tooltip`).
- Touch targets ≥ 48dp.
- Text scale 130% and 200%: nothing clipped, nothing overlapping.
- Reduce-motion: content visible, final states shown, no essential animation lost.
- Color is never the only carrier of meaning (status also has a label/icon).

Flutter tools:
```dart
// Enable the accessibility/semantics checks while developing:
import 'package:flutter/rendering.dart' show debugSemanticsDisableAnimations;
SemanticsBinding.instance.ensureSemantics(); // then use the inspector a11y tab
```
Use the **Flutter Inspector** (Widget Inspector → accessibility or the "Show semantics" toggle)
and the **DevTools accessibility** tab to surface tap-target and label issues.

## The blind test (the real one)

1. Screenshot the screen.
2. Cover the logo and product name.
3. Ask: could this be another product in the same category unchanged? (copy test — the biggest
   tell)
4. Ask: what is the one thing here that could not come from a template?
5. If there isn't one, you shipped a template. Return to `lx-flutter-tells` § "What soul looks
   like" and add the 20%.

## Report

Produce a short report:
- **Score** (catalog 0–20; lower better) and the delta from last pass.
- **P0s** found, with file:line or screenshot reference.
- **Cross-platform** checklist result.
- **Analyzer** summary.
- **The three highest-leverage fixes** for next pass.
- **What changed** vs the previous attempt (so you don't reland the same default).

## Sources

The verification method combines: the screenshot/review step in Anthropic's `frontend-design`
skill; interface-craft reviews; W3C WCAG contrast and focus guidance; Flutter's accessibility
and adaptive docs; and the state-completeness practice from InterfaceKit's page contract.
