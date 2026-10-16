# The Surface Contract

A contract is the filter for every later decision. It converts "a settings screen" into the
settings screen *for this product*. Write one per surface (a screen, a route, or a
meaningful state). Keep it short — six lines, all specific.

## Template

```
Surface:      <route or widget name>
User:         <who, concretely>
Job:          <what they came to do>
First:        <the one thing they must understand first>
Action:       <the single primary action>
Content:      <the real nouns, numbers, lengths, and edge cases>
States:       <which of loading/empty/no-results/error/success/disabled/denied apply>
Surfaces:     <android | web | both> — and what differs between them
```

## Why each line matters

- **User** — names the vocabulary and the density. A "treasury analyst" and a "first-time
  investor" want different tables.
- **Job** — decides the primary action. Without it, every button competes.
- **First** — decides hierarchy. What is the heading, what is subordinate.
- **Action** — decides the one accented thing. One primary action per surface.
- **Content** — real content exposes when the chosen component cannot handle the product.
- **States** — a generated screen is a happy path. Real surfaces have edges.
- **Surfaces** — the same job can require different layouts and inputs on Android and web.

## Two worked contracts (contrast the density)

**Expressive — onboarding for a plant-care app**

```
Surface:  first-run flow
User:     someone who just bought their first houseplant and is mildly worried
Job:      add their first plant and learn when to water it
First:    this app is calm and won't kill their plant
Action:   "Add plant"
Content:  real species names ("Monstera deliciosa"), pot sizes in cm, a watering date
States:   empty (no plants yet), denied (camera for plant ID), success (first plant added)
Surfaces: android (camera-led) vs web (drop a photo / search species) — different input, same job
```

**Utility — reconciliation table for an expense tool**

```
Surface:  /reconcile
User:     a bookkeeper closing the month
Job:      match bank lines to receipts and flag the gaps
First:    which 4 lines don't match and why
Action:   "Mark matched" (bulk)
Content:  real merchant strings, amounts, dates, a 40-char memo that truncates
States:   loading (skeleton keeps the table frame), no-results (which filter emptied it),
          error (what failed, what is safe), disabled (needs an account selected)
Surfaces: web-first (dense table, keyboard); android compresses to grouped rows + a detail sheet
```

Notice: the expressive surface earns bold type and one motion moment. The utility surface
earns density, tabular figures, and a calm palette. Same studio, different register.

## Deriving states instead of inventing copy

For each state, answer what the interface must *explain* — not what mood to set:

| State | What it must explain |
|---|---|
| Loading | what stays stable; what is still pending |
| Empty | why there is nothing; the useful next action |
| No results | which filter caused it; how to clear it |
| Error | what failed; what remains safe; how to recover |
| Success | what changed; whether anything is needed next |
| Disabled | why the action is unavailable |
| Permission denied | what this person can see or request |
| Overflow | what happens with long content or many rows |

Use the **same** frame, components, and tokens in every state. A bespoke layout per state
recreates the inconsistency you are trying to remove. In Flutter, encode these as a sealed
state type so the compiler forces you to handle each one (see `lx-flutter-tells` for the
pattern).
