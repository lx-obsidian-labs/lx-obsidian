import { fileURLToPath } from "node:url";
import path from "node:path";
import stylelint from "stylelint";

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const plugin = path.resolve(__dirname, "../lib/index.js");

const config = {
  plugins: [plugin],
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

const cases = [
  { code: ".a { color: #ff0000; }", want: true, name: "hex color" },
  { code: ".a { color: var(--surface); }", want: false, name: "token color" },
  { code: ".a { background: rgb(0,0,0); }", want: true, name: "rgb()" },
  { code: ".a { color: blue; }", want: true, name: "keyword color" },
  { code: ".a { padding: 16px; }", want: true, name: "px spacing" },
  { code: ".a { padding: var(--space-4); }", want: false, name: "token spacing" },
  { code: ".a { border-radius: 12px; }", want: true, name: "px radius" },
  { code: ".a { font-size: 22px; }", want: true, name: "px font size" },
  { code: ".a { box-shadow: 0 4px 8px rgba(0,0,0,.2); }", want: true, name: "shadow" },
  { code: ".a { transition: opacity 300ms linear; }", want: true, name: "duration+linear" },
  { code: ".a { color: red; }", want: true, name: "framework keyword" },
];

async function run() {
  let failed = 0;
  for (const c of cases) {
    const res = await stylelint.lint({ code: c.code, config });
    const got = res.results[0].warnings.length > 0;
    if (got !== c.want) {
      failed++;
      console.error(`FAIL ${c.name}: want warn=${c.want}, got=${got}`);
    } else {
      console.log(`ok   ${c.name}`);
    }
  }
  if (failed) {
    console.error(`${failed} case(s) failed`);
    process.exit(1);
  }
  console.log("All cases passed.");
}

run().catch((e) => {
  console.error(e);
  process.exit(1);
});
