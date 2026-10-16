# eslint-plugin-lx-slop

ESLint plugin that flags the **code-certain "AI slop" UI tells** in JS/TS/JSX/TSX — React, Next.js,
Vue, Svelte, and React Native/Expo — using the **universal rule names** from `lx-obsidian`'s
`slop-taxonomy.md`.

## Rules

| Rule | Severity | What it catches |
|---|---|---|
| `lx-slop/hardcoded-color` | P0 | hex / `rgb()` color literals in strings, style objects, CSS-in-JS |
| `lx-slop/framework-color` | P0 | framework palette literals (`indigo-500`, `bg-blue-600`) |
| `lx-slop/default-theme` | P0 | the stock/reflex seed left in place |
| `lx-slop/hardcoded-spacing` | P0 | numeric `padding`/`margin`/`gap`/sizing |
| `lx-slop/hardcoded-radius` | P1 | numeric `borderRadius` |
| `lx-slop/hardcoded-font-size` | P0 | numeric `fontSize`/`lineHeight` |
| `lx-slop/hardcoded-elevation` | P1 | numeric `shadow*` / `elevation` |
| `lx-slop/hardcoded-duration` | P1 | numeric `*duration*` |
| `lx-slop/reflex-font` | P1 | Inter/Roboto/Space Grotesk/Geist/Poppins/Montserrat by name |
| `lx-slop/linear-motion` | P1 | `linear` easing |
| `lx-slop/emoji-icon` | P0 | emoji-only strings used as icons |
| `lx-slop/orientation-lock` | P0 | orientation lock (`setPreferredOrientations`, app config) |

Rules are AST-based heuristics. A finding is a "look here", not a verdict.

## Use it

```js
// eslint.config.js (flat config)
import lxSlop from "eslint-plugin-lx-slop";

export default [
  {
    plugins: { "lx-slop": lxSlop },
    rules: {
      "lx-slop/hardcoded-color": "error",
      "lx-slop/framework-color": "error",
      "lx-slop/hardcoded-spacing": "error",
      "lx-slop/hardcoded-radius": "error",
      "lx-slop/hardcoded-font-size": "error",
      "lx-slop/hardcoded-elevation": "error",
      "lx-slop/hardcoded-duration": "error",
      "lx-slop/reflex-font": "warn",
      "lx-slop/linear-motion": "warn",
      "lx-slop/emoji-icon": "error",
      "lx-slop/orientation-lock": "error",
    },
  },
];
```

Vue single-file components need `vue-eslint-parser`; Svelte needs `svelte-eslint-parser`. React
Native uses the same config.

## Suppress a finding

```js
// eslint-disable-next-line lx-slop/hardcoded-color -- brand color, intentional
const brand = "#6d28d9";
```

## Test

```bash
npm install
npm test
```
