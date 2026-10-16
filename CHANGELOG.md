# Changelog

All notable changes to LX Obsidian are documented here. The format follows
[Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and this project uses
[Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- `lx-recon` skill — research the surface before designing it (references,
  platform conventions, competitive patterns, and the one non-template move).
- Dart `hardcoded_duration` rule (completes the canonical detector set).
- Stylelint `reflex-font` and `emoji-icon` rules.
- CI workflow that runs every detector's tests, config validation, and the
  fallback scanner smoke test.
- Repo hygiene: `CONTRIBUTING`, `SECURITY`, `CODE_OF_CONDUCT`, issue and PR
  templates.

### Changed
- `lx-design-verify` generalized from Flutter-only to all five stacks.
- All detectors now speak the canonical universal rule names
  (`hardcoded_color`, `framework_color`, `default_theme`, `hardcoded_spacing`,
  `hardcoded_radius`, `hardcoded_font_size`, `hardcoded_elevation`,
  `hardcoded_duration`, `reflex_font`, `linear_motion`, `emoji_icon`,
  `orientation_lock`).
- License is now proprietary (All Rights Reserved) — © LX Obsidian.

### Fixed
- ESLint plugin: runtime `ReferenceError` in the emoji helper; removed dead code.
- Dart plugin: alignment of rule ids with the taxonomy.

## [0.1.0] - 2026-10-16

### Added
- Framework-agnostic core (`lx-obsidian`) with the universal slop taxonomy,
  positive-first workflow, adapters, `DESIGN.md` template, and surface contract.
- Five framework tell packs: `lx-flutter-tells`, `lx-web-tells`,
  `lx-react-native-tells`, `lx-swiftui-tells`, `lx-compose-tells`.
- `lx-cross-platform` adaptation ladder across all stacks.
- `lx-slop-guard` (detector runner + CI gate) and `lx-design-verify`
  (pre-ship verification).
- Per-stack detectors: Dart analyzer plugin (`packages/lx_slop_lint`), ESLint
  plugin, Stylelint plugin, SwiftLint config, detekt config.
- Dependency-free fallback scanners: `scripts/lx_scan.ps1`, `scripts/lx_scan.sh`.

[Unreleased]: https://github.com/lx-obsidian/lx-obsidian/compare/v0.1.0...HEAD
[0.1.0]: https://github.com/lx-obsidian/lx-obsidian/releases/tag/v0.1.0
