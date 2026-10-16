## What & why

<!-- What does this change, and which tell/rule/skill does it affect? -->

## Type

- [ ] New tell
- [ ] New/updated detector rule
- [ ] Skill or docs improvement
- [ ] Fix (false positive, false negative, bug)
- [ ] Chore / CI

## Canonical rule name(s)

<!-- If a detector changed, list the universal rule name(s), e.g. hardcoded_duration -->

## Checklist

- [ ] Positive-first: the change includes the fix, not just the smell.
- [ ] Uses only canonical rule names (slop-taxonomy.md).
- [ ] Added/updated a focused test with a token-based "good" example.
- [ ] Updated the relevant SKILL tell count and package rules table.
- [ ] `dart test` / `npm test` for touched packages pass.
- [ ] `dart analyze` clean for touched Dart.
- [ ] Config YAML still parses (swiftlint / detekt).

## Test output

```
<paste the command(s) and result>
```

## Screenshots

<!-- For rendered tells, before/after at a real breakpoint. -->
