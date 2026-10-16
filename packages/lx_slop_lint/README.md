# lx_slop_lint

A Dart analyzer plugin that flags the **code-certain "AI slop" UI tells** in
Flutter/Dart — the machine-detected half of the `lx-flutter-tells` catalog.

Built on the official `analysis_server_plugin` API (`custom_lint` is deprecated
and is not used). Targets **analyzer 10.x / `analysis_server_plugin` 0.3.8+**,
which is what the Dart 3.13 stable analysis server bundles.

## Rules

| Rule | Severity | Tell | What it flags |
|---|---|---|---|
| `hardcoded_color` | P0 | FLS-CO-03 | `Color(0x…)`, `Color.fromARGB(…)` |
| `framework_color` | P0 | FLS-CO-02 | `Colors.blue`, … used for UI roles |
| `default_theme` | P0 | FLS-CO-01 | reflex seed in `ColorScheme.fromSeed` |
| `hardcoded_spacing` | P0 | FLS-SH-02/05 | magic spacing in `SizedBox`/`EdgeInsets`/`Container` |
| `hardcoded_radius` | P1 | FLS-SH-01/03 | literal `BorderRadius`/`Radius` |
| `hardcoded_font_size` | P0 | FLS-TY-01/04 | literal `fontSize:` in `TextStyle` |
| `hardcoded_elevation` | P1 | FLS-SH-01/04 | literal `elevation:` / `BoxShadow` blur |
| `orientation_lock` | P0 | FLS-X-06 | `SystemChrome.setPreferredOrientations` |
| `linear_motion` | P1 | FLS-MO-02 | `Curves.linear` in UI motion |
| `emoji_icon` | P0 | FLS-CM-06 | emoji used as an icon in `Text` |

Rule names are the **universal** names from `lx-obsidian`'s `slop-taxonomy.md`,
so Dart, ESLint, Stylelint, SwiftLint, and detekt all speak the same vocabulary.
Rules only report inside `lib/`.

## Use it

`pubspec.yaml` (in the app):
```yaml
dev_dependencies:
  lx_slop_lint:
    path: ../lx-obsidian/packages/lx_slop_lint
```

`analysis_options.yaml` (in the app):
```yaml
plugins:
  lx_slop_lint:
    path: ../lx-obsidian/packages/lx_slop_lint
```
(The `path` form is required for a locally-developed plugin; the `^version` form
downloads from pub.dev and silently does nothing for an unpublished package.)

## Run it — and the one caveat that bites

The plugin is loaded by the **analysis server** (your IDE) and by the
`dart analyze` CLI. Two known SDK issues matter:

- **`dart analyze <folder>` misses plugin diagnostics.** Point it at a single
  file, or use your IDE. `dart analyze lib/main.dart` reports them;
  `dart analyze lib` prints "No issues found!" ([dart-lang/sdk#62710]).
- **`flutter analyze` may not surface them** on current Flutter stable
  ([flutter/flutter#187999]). Use `dart analyze <file>` or the IDE until fixed.

```powershell
# reports plugin diagnostics:
dart analyze lib/screens/home.dart
# does NOT (folder mode is buggy):
dart analyze lib
```

Turn a rule off in `analysis_options.yaml` if a project disagrees:
```yaml
plugins:
  lx_slop_lint:
    path: ../lx-obsidian/packages/lx_slop_lint
    diagnostics:
      hardcoded_spacing: false
```

[dart-lang/sdk#62710]: https://github.com/dart-lang/sdk/issues/62710
[flutter/flutter#187999]: https://github.com/flutter/flutter/issues/187999

## Suppress a finding

```dart
// ignore: hardcoded_color
Container(color: const Color(0xFF1A1A1A))
```

Prefer fixing the root — introduce tokens, replace the seed, add the state —
over silencing hits. Token/theme files are the usual place to legitimately
suppress color and dimension rules.

## Tests

`dart test` runs the rules with the official `analyzer_testing` framework
(`test/rules_test.dart`). Analysis is verified against **analyzer 10.2.0 /
`analysis_server_plugin` 0.3.10**; the plugin is also verified to load and fire
under the **Dart 3.13 analysis server's bundled 0.3.8 / analyzer 10.0.2**.

## How it fits

- `lx-flutter-tells` — the full catalog, including the `👁` rendered tells this
  plugin *cannot* catch (copy quality, layout tension, palette harmony, "soul").
- `lx-slop-guard` — how to run, report, and gate these in CI; also the
  dependency-free scanner fallback.
- `lx-obsidian` — the design process these rules protect.

A finding is a "look here", not a verdict. Human judgment ships the work.
