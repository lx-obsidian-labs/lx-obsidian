import { ESLint } from "eslint";
import plugin from "../lib/index.js";

const eslint = new ESLint({
  overrideConfigFile: true,
  overrideConfig: {
    languageOptions: { ecmaVersion: 2022, sourceType: "module" },
    plugins: { "lx-slop": plugin },
    rules: {
      "lx-slop/hardcoded-color": "error",
      "lx-slop/emoji-icon": "error",
      "lx-slop/hardcoded-spacing": "error",
      "lx-slop/hardcoded-font-size": "error",
      "lx-slop/hardcoded-radius": "error",
    },
  },
});

const cases = [
  { code: "const a = '#ff0000';", want: true, name: "hex string literal" },
  { code: "const a = 5;", want: false, name: "plain number" },
  { code: "const s = { color: '#abcdef' };", want: true, name: "style object hex" },
  { code: "const s = { padding: 16 };", want: true, name: "spacing number" },
  { code: "const s = { fontSize: 22 };", want: true, name: "font size number" },
  { code: "const s = { borderRadius: 12 };", want: true, name: "radius number" },
  { code: "const x = '\uD83D\uDD25';", want: true, name: "emoji-only string" },
  { code: "const x = 'Hello';", want: false, name: "normal string" },
];

async function run() {
  let failed = 0;
  for (const c of cases) {
    const results = await eslint.lintText(c.code);
    const got = results[0].messages.length > 0;
    if (got !== c.want) {
      failed++;
      console.error(`FAIL ${c.name}: want=${c.want} got=${got} ${JSON.stringify(results[0].messages)}`);
    } else {
      console.log(`ok   ${c.name}`);
    }
  }
  if (failed) {
    console.error(`${failed} failed`);
    process.exit(1);
  }
  console.log("all passed");
}

run().catch((e) => {
  console.error(e);
  process.exit(1);
});
