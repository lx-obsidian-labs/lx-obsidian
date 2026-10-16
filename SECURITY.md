# Security Policy

## Supported versions

LX Obsidian is pre-1.0; only the latest `main` is supported with fixes.

| Version | Supported |
|---|---|
| `main` | ✅ |
| `0.1.x` tags | ⚠️ best effort |

## Reporting a vulnerability

**Do not open a public issue for security problems.**

Report privately to the LX Obsidian maintainers with:

- a description of the issue and its impact,
- the affected skill, package, or config,
- a minimal reproduction (snippet, command, or repo),
- any suggested fix.

You can expect an acknowledgement within a few business days and a coordinated
disclosure timeline once a fix is available.

## Scope

In scope:

- Arbitrary code execution, path traversal, or command injection in the
  `scripts/` fallback scanners or any detector plugin.
- Supply-chain issues in the published packages under `packages/`.
- Detectors that leak file contents or environment data.

Out of scope:

- A tell that a detector does not catch (that is a feature request, not a
  vulnerability).
- Findings about code you chose to analyze with these tools.

## Handling

The tools under `packages/` and `scripts/` read source files and emit
diagnostics; they do not transmit code off your machine. Treat any change that
introduces network access, subprocess execution, or file writes as
security-sensitive and reviewable.
