# stylelint-lx-slop

Stylelint plugin that flags the **code-certain "AI slop" UI tells** in CSS/SCSS/PostCSS, using the
**universal rule names** from `lx-obsidian`'s `slop-taxonomy.md`.

## Rules

| Rule | Severity | What it catches |
|---|---|---|
| `lx-slop/hardcoded-color` | P0 | hex / `rgb()` / `hsl()` literals and framework palette tokens (`indigo-500`) |
| `lx-slop/framework-color` | P0 | CSS keyword colors (`red`, `blue`, `rebeccapurple`) used as UI roles |
| `lx-slop/hardcoded-spacing` | P0 | `margin`/`padding`/`gap`/sizing with raw `px` |
| `lx-slop/hardcoded-radius` | P1 | `border-radius` with raw `px` |
| `lx-slop/hardcoded-font-size` | P0 | `font-size` with raw `px`/`pt` |
| `lx-slop/hardcoded-elevation` | P1 | `box-shadow`/`text-shadow` with raw lengths |
| `lx-slop/hardcoded-duration` | P1 | `transition`/`animation` with raw `ms`/`s` |
| `lx-slop/linear-motion` | P1 | `linear` easing |

All rules ignore values that reference a token (`var(--x)`, `--`, `theme()`, `env()`).

## Use it

```js
// stylelint.config.js
export default {
  plugins: ["stylelint-lx-slop"],
  rules: {
    "lx-slop/hardcoded-color": true,
    "lx-slop/framework-color": true,
    "lx-slop/hardcoded-spacing": true,
    "lx-slop/hardcoded-radius": true,
    "lx-slop/hardcoded-font-size": true,
    "lx-slop/hardcoded-elevation": true,
    "lx-slop/hardcoded-duration": true,
    "lx-slop/linear-motion": true,
  },
};
```

## Suppress a finding

```css
/* stylelint-disable-next-line lx-slop/hardcoded-color */
.hero { color: #6d28d9; }
```

A finding is a "look here", not a verdict. Prefer introducing tokens over silencing hits.

## Test

```bash
npm install --save-dev stylelint
node test/basic.test.js
```
