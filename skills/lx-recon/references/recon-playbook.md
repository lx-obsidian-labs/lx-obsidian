# Recon playbook

Run the four recons in order. Keep notes in a scratch file; the output feeds `DESIGN.md` and the
surface contract, and nothing else. Time-box the whole thing — if it takes longer than building the
first pass, you're stalling.

Contents
1. Subject recon
2. Reference recon
3. Constraint recon
4. Pattern recon
5. Search queries that work
6. Offline / no-network fallback
7. The non-template move
8. Recon → DESIGN.md
9. Recon checklist

---

## 1. Subject recon

Answer in one line each:

- **Product:** what is it, in plain words?
- **Audience:** who uses it, and how expert are they?
- **Job:** what does the user hire this screen to do?
- **Register:** expressive/branded, or utility/dense? (Sets the whole tone.)
- **Real content:** the actual domains, entities, units, and vocabulary — not lorem ipsum.
- **Physical world:** what objects, materials, processes, or rituals does the subject come from?
- **Emotional target:** what should the user *feel* the first 3 seconds?

The physical world line is the seed of your palette, type, and motion. Write it down before any
color.

## 2. Reference recon

Gather three tiers, each with 2–4 entries and a note on **what specifically to borrow**:

| Tier | Look for | Source |
|---|---|---|
| **Subject world** | materials, type, color, motion from the domain | the product's industry, its own assets, museum/archive material |
| **Platform** | the convention you must respect | Apple HIG, Material 3, MDN, Flutter adaptive docs |
| **Adjacent craft** | 2–3 well-made products in or near the category | real shipped apps, not concept shots |

For each, record: link, what it does well, and the one mechanic worth adapting (not copying).

Reject as references: Dribbble-style mockups with no constraints, AI-generated "design inspiration",
anything you cannot link to a real product or primary source.

## 3. Constraint recon

| Dimension | Record |
|---|---|
| Platforms / widths | which targets ship; 320 · 600 · 840 · 1200 · 1920 |
| Input modality | touch, pointer, keyboard, stylus, combos |
| Accessibility bar | contrast targets, text scale 130/200%, reduce-motion, screen reader, target size |
| Performance | budget (frame time, bundle size, image weight), low-end device support |
| Data states | volume, latency, offline, permissions, first-run vs returning |
| Localization | languages, RTL, text expansion, number/date formats |
| Legal/IP | what may not be copied; brand constraints; licensing of any asset |

Platform-divergence notes here are what stop the build from flattening Android + iOS + web into one
generic surface later.

## 3a. Platform divergence to capture

Note the disagreements you will need to resolve — these become `lx-cross-platform` decisions:

- Navigation: bottom bar vs rail vs sidebar per width.
- Back: Android predictive back, iOS edge-swipe, browser back, window controls.
- Controls: native switches/pickers vs custom; haptics; hover vs press.
- Type scale and default typefaces per OS; Dynamic Type / text scaling behavior.
- Default surfaces (Material elevation vs flat iOS; web focus rings; desktop density).

## 3.5 Pattern recon

For the specific screen type (settings, feed, dashboard, checkout, editor, onboarding…):

- **Proven 80%:** the conventional structure users already understand. List it; you will use it.
- **Reflex center:** what the framework/AI reaches for by default here. List it; you will avoid it.
  Pull these from the matching `lx-*-tells` pack.

## 5. Search queries that work

Prefer primary sources. Useful shapes:

- `<platform> human interface guidelines <component>`
- `material 3 <component> specifications`
- `"<subject domain>" <material|typography|color>`
- `<adjacent product> <screen> design breakdown`
- `wcag contrast <role>` / `text scaling <platform>` / `reduce motion <platform>`
- `<stack> adaptive layout breakpoints` (Flutter/Compose/SwiftUI/RN)

Avoid: "best UI design 2026", "top 10 dashboard designs", anything without a named source.

## 6. Offline / no-network fallback

When you cannot browse, recon from what's already on disk:

- Read the repo: existing tokens/theme, brand assets, icon sets, copy, and the product's README.
- Read the platform docs you already depend on (SDK type scales, Material tokens in dependencies).
- Interview the artifacts: what does the product *say*, in its own words, about itself?
- Use your own knowledge of the platform guidance, but mark it as unverified in the notes.
- Never substitute "I'll just use the framework default" for recon — that's the thing you're
  avoiding.

## 7. The non-template move

Write one sentence:

> The thing on this surface that could not come from a template is ____.

It must be subject-specific, buildable in this stack, accessible, and not a gimmick. If you can't
name one, look again at the subject's physical world (recon 1) — the move is usually hiding there.

## 8. Recon → DESIGN.md

Map findings to the conductor's `DESIGN.md` template:

| Recon finding | DESIGN.md field |
|---|---|
| Subject physical world + references | palette roles + rationale |
| Subject vocabulary / domain | type roles + treatment |
| Reference mechanics | motion tokens + signature move |
| Constraint recon | spacing/radius/elevation ladder, breakpoints, a11y targets |
| Pattern recon | the proven 80% + the avoided reflex list |

Each token gets a one-sentence rationale. A token without a rationale is a renamed default.

## 9. Recon checklist

- [ ] Subject, audience, job, register, content, physical world, emotional target — all written.
- [ ] ≥2 references per tier, each with a "what to borrow" note.
- [ ] Platforms, widths, modalities, a11y bar, performance budget recorded.
- [ ] Platform-divergence notes captured (nav/back/input/contrast).
- [ ] Proven-80% patterns and reflex-to-avoid patterns listed.
- [ ] One non-template move named in one sentence.
- [ ] Recon maps cleanly onto DESIGN.md fields, each with a rationale.
- [ ] Nothing copied that we don't have the rights to use.
