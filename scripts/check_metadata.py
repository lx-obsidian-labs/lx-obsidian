#!/usr/bin/env python3
"""Validate LX Obsidian metadata: JSON, YAML configs, and SKILL frontmatter.

Run from the repository root:

    python scripts/check_metadata.py

Exits non-zero if anything fails, so it works as a CI gate.
"""

from __future__ import annotations

import json
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent

JSON_FILES = [
    ".claude-plugin/plugin.json",
    ".claude-plugin/marketplace.json",
    "packages/eslint-plugin-lx-slop/package.json",
    "packages/eslint-plugin-lx-slop/package-lock.json",
    "packages/stylelint-lx-slop/package.json",
    "packages/stylelint-lx-slop/package-lock.json",
]

YAML_FILES = [
    "lint/swiftui/.swiftlint.yml",
    "lint/compose/detekt.yml",
]

FAILURES: list[str] = []


def fail(msg: str) -> None:
    FAILURES.append(msg)


def check_json() -> None:
    for rel in JSON_FILES:
        path = ROOT / rel
        if not path.exists():
            print(f"  skip  {rel} (missing)")
            continue
        try:
            json.loads(path.read_text(encoding="utf-8"))
            print(f"  ok    {rel}")
        except json.JSONDecodeError as exc:
            fail(f"{rel}: {exc}")


def check_yaml() -> None:
    try:
        import yaml  # type: ignore
    except ImportError:
        print("  skip  PyYAML not installed")
        return
    for rel in YAML_FILES:
        path = ROOT / rel
        try:
            yaml.safe_load(path.read_text(encoding="utf-8"))
            print(f"  ok    {rel}")
        except Exception as exc:  # noqa: BLE001
            fail(f"{rel}: {exc}")


def parse_frontmatter(text: str) -> dict[str, str] | None:
    """Return the simple key: value pairs between the leading `---` fences."""
    lines = text.splitlines()
    if not lines or lines[0].strip() != "---":
        return None
    data: dict[str, str] = {}
    for line in lines[1:]:
        if line.strip() == "---":
            return data
        if not line.strip() or line.lstrip().startswith("#"):
            continue
        if ":" not in line:
            # continuation of the previous scalar
            if data:
                last = next(reversed(data))
                data[last] = (data[last] + " " + line.strip()).strip()
            continue
        key, _, value = line.partition(":")
        data[key.strip()] = value.strip().strip('"').strip("'")
    return None  # unterminated frontmatter


def check_skills() -> None:
    skills = sorted((ROOT / "skills").glob("*/SKILL.md"))
    if not skills:
        fail("no skills/*/SKILL.md found")
        return
    for skill in skills:
        rel = skill.relative_to(ROOT)
        text = skill.read_text(encoding="utf-8")
        fm = parse_frontmatter(text)
        if fm is None:
            fail(f"{rel}: missing or unterminated YAML frontmatter")
            continue
        for key in ("name", "description", "license"):
            if not fm.get(key):
                fail(f"{rel}: frontmatter missing '{key}'")
        if fm.get("name") and fm["name"] != skill.parent.name:
            fail(
                f"{rel}: frontmatter name '{fm['name']}' != directory "
                f"'{skill.parent.name}'"
            )
    print(f"  ok    {len(skills)} skills")


def main() -> int:
    print("JSON:")
    check_json()
    print("YAML:")
    check_yaml()
    print("Skills:")
    check_skills()

    if FAILURES:
        print("\nFAILED:")
        for msg in FAILURES:
            print(f"  - {msg}")
        return 1
    print("\nAll metadata valid.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
