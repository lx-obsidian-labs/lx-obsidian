---
name: lx-recon
description: Do design reconnaissance before you design — inventory the subject, gather real references and platform constraints, scan adjacent/competitive patterns, and commit to one non-template move. Use before starting any new surface, redesign, or "make this not look generated" task; when a build is about to reach for framework defaults; or when you need a DESIGN.md worth trusting. Pairs with the LX Obsidian conductor and the framework tell packs.
license: Proprietary
---

# Recon

Every generic UI is a decision that was never made. Recon is where you make the decisions that
later keep the build off the default path — **before** the first `ColorScheme.fromSeed`, the first
`rounded-lg`, the first stock `Card`. The full playbook is in
`references/recon-playbook.md`.

## Why before, not after

Defaults are a gravity well. Once a screen exists, "improve it" means fighting the layout you
already wrote. Recon happens while the surface is still a blank contract, so the deliberate choice
is the *first* choice, not a patch on the reflexive one.

## The four recons

Run all four; each is short (minutes, not days).

1. **Subject recon** — what is this actually *for*? Product, audience, job, the real content and
   its domains, the vocabulary the users use.
2. **Reference recon** — gather real, non-template references: the subject's own world (objects,
   materials, motion, typography), the platform's HIG/Material guidance, and 2–3 adjacent products
   that are known to be well-crafted. Save links and note *what specifically* to steal.
3. **Constraint recon** — the honest limits: platforms and widths, input modalities, accessibility
   bar (contrast, text scale, reduce-motion), performance budget, localization, offline.
4. **Pattern recon** — the established patterns for this kind of screen (so you can use the proven
   80% well) and the reflex patterns to *avoid* (so you don't ship the statistical center).

## The rules of recon

- **The subject is the reference.** The best palette, type, and motion come from the domain, not
  from a moodboard. A finance dashboard borrows rigor; a plant app borrows growth.
- **Cite, don't vibe.** Every direction claim links to a source, a real product, or the subject.
  "It felt right" is not recon.
- **Prefer primary sources.** Platform guidance (Apple HIG, Material, MDN, Flutter docs) over
  listicles; the subject's own materials over generic inspiration.
- **Note divergence, not just inspiration.** Recon records where platforms disagree (nav, back,
  controls) so the build doesn't flatten them later.
- **Respect IP.** Extract principles and mechanics; do not copy a competitor's brand assets, exact
  layouts, copy, or illustrations.

## Deliverables

Recon produces the raw material for two artifacts and nothing else:

- **`DESIGN.md`** — palette roles, type roles, spacing/radius/elevation ladder, motion tokens, and
  the one-sentence rationale each. See the conductor's `references/design-md-template.md`.
- **The surface contract** — per surface: who, job, first thing seen, primary action, real content,
  states. See `references/surface-contract.md` in the conductor.

If recon produced nothing that changes the build, you did not do recon — you did browsing.

## The one non-template move

Name exactly one **20% move**: the thing in this surface that could not come from a template — a
signature layout, a domain-specific visualization, a crafted micro-interaction, a type treatment.
Write it in one sentence before building. It is the thing the blind test at verify time will look
for. See `lx-design-verify`.

## Anti-patterns (recon tells)

- Starting the build, *then* looking for references to justify it.
- Moodboards with no subject link; "inspired by Dribbble" as a direction.
- Copying a competitor's exact screen, copy, or illustration.
- Recon that lists platforms but never notes where they diverge.
- A DESIGN.md with tokens but no rationale (defaults renamed, not decided).
- Producing no non-template move at all.

## How it connects

- `lx-obsidian` — the conductor that consumes recon's outputs.
- `lx-*-tells` — the tell packs you check your direction *against* (avoid the defaults).
- `lx-cross-platform` — the constraint recon's platform-divergence notes feed.
- `lx-design-verify` — the blind test that confirms the non-template move survived.
