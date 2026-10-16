const HEX = /^#[0-9a-fA-F]{3,8}$/;
const HEX_IN_TEXT = /#[0-9a-fA-F]{3,8}\b/;
const FRAMEWORK_SWATCH = /\b(indigo|blue|purple|violet|cyan|teal|amber|pink|emerald|slate|zinc|rose|sky|fuchsia)-[0-9]{2,3}\b/;
const REFLEX_FONT = /\b(Inter|Roboto|Space Grotesk|Geist|Poppins|Montserrat)\b/i;

function isEmoji(codePoint) {
  if (!Number.isFinite(codePoint)) return false;
  const cp = Number(codePoint);
  return (
    (cp >= 0x1f000 && cp <= 0x1faff) ||
    (cp >= 0x2600 && cp <= 0x27bf) ||
    (cp >= 0x2b00 && cp <= 0x2bff) ||
    (cp >= 0x2190 && cp <= 0x21ff) ||
    (cp >= 0x1f1e6 && cp <= 0x1f1ff) ||
    (cp >= 0xfe00 && cp <= 0xfe0f) ||
    (cp >= 0x1f600 && cp <= 0x1f64f) ||
    (cp >= 0x1f680 && cp <= 0x1f6ff) ||
    (cp >= 0x2700 && cp <= 0x27bf) ||
    cp === 0x2764 ||
    cp === 0x2049
  );
}

function isEmojiOnly(str) {
  const text = String(str).replace(/\$\{[^}]*\}/g, "").trim();
  if (!text) return false;
  let has = false;
  for (const ch of text) {
    const cp = ch.codePointAt(0) || 0;
    if (cp === 0x20 || cp === 0x200d) continue;
    if (isEmoji(cp)) {
      has = true;
      continue;
    }
    return false;
  }
  return has;
}

function stringValue(node) {
  return typeof node.value === "string" ? node.value : null;
}

function propName(node) {
  const p = node.parent;
  if (!node || !p) return "";
  if (p.type === "Property" && node === p.value) {
    return propertyName(p.key);
  }
  if (p.type === "Property" && p.shorthand) {
    return propertyName(p.key);
  }
  return "";
}

function propertyName(key) {
  if (!key) return "";
  if (key.type === "Identifier") return key.name;
  if (key.type === "Literal") return String(key.value);
  return "";
}

function makeRule(meta, checkLiteral, checkTemplate) {
  return {
    meta: { type: "problem", schema: [], messages: meta.messages },
    create(context) {
      return {
        Literal(node) {
          const v = typeof node.value === "string" ? node.value : node.value;
          if (checkLiteral(node, v, context)) return;
        },
        TemplateElement(node) {
          if (checkTemplate) checkTemplate(node, node.value.raw, context);
        },
      };
    },
  };
}

function report(context, node, messageId) {
  context.report({ node, messageId });
}

export default {
  meta: {
    name: "lx-slop",
    version: "0.1.0",
    docs: { description: "Flags code-certain AI slop UI tells (universal rules)." },
  },
  rules: {
    "hardcoded-color": makeRule(
      { messages: { bad: "Hardcoded color. Use design tokens (CSS variables/theme)." } },
      (node, v, ctx) => {
        const s = String(v ?? "");
        if (typeof v === "string" && HEX.test(s)) {
          report(ctx, node, "bad");
          return true;
        }
        return false;
      },
      (node, raw, ctx) => {
        if (HEX_IN_TEXT.test(raw)) report(ctx, node, "bad");
      }
    ),

    "framework-color": makeRule(
      { messages: { bad: "Framework default color used as a UI role (indigo/blue/purple/…)." } },
      (node, v, ctx) => {
        const s = String(v ?? "");
        if (typeof v === "string" && FRAMEWORK_SWATCH.test(s)) {
          report(ctx, node, "bad");
          return true;
        }
        return false;
      },
      (node, raw, ctx) => {
        if (FRAMEWORK_SWATCH.test(raw)) report(ctx, node, "bad");
      }
    ),

    "default-theme": makeRule(
      { messages: { bad: "Default/reflex theme seed left in place. Choose a deliberate seed." } },
      (node, v, ctx) => {
        const s = String(v ?? "");
        if (typeof v === "string" && /\b(deepPurple|deep-purple|indigo|blue|purple|violet)\b/.test(s) && /seed/i.test(propertyName(node.parent?.key) || "")) {
          report(ctx, node, "bad");
          return true;
        }
        return false;
      },
      null
    ),

    "hardcoded-spacing": makeRule(
      { messages: { bad: "Hardcoded spacing. Use the spacing scale." } },
      (node, v, ctx) => {
        if (typeof v !== "number" || !Number.isFinite(v) || v === 0) return false;
        const p = (propertyName(node.parent?.key) || "").toLowerCase();
        if (/(^|_)(margin|padding|gap|inset|top|right|bottom|left|width|height)/.test(p) || p.endsWith("gap")) {
          report(ctx, node, "bad");
          return true;
        }
        return false;
      },
      null
    ),

    "hardcoded-radius": makeRule(
      { messages: { bad: "Hardcoded radius. Use the radius ladder." } },
      (node, v, ctx) => {
        if (typeof v !== "number" || !Number.isFinite(v) || v === 0) return false;
        const p = (propertyName(node.parent?.key) || "").toLowerCase();
        if (p.includes("radius") || p.includes("borderradius")) {
          report(ctx, node, "bad");
          return true;
        }
        return false;
      },
      null
    ),

    "hardcoded-font-size": makeRule(
      { messages: { bad: "Hardcoded font size. Use the type scale." } },
      (node, v, ctx) => {
        if (typeof v !== "number" || !Number.isFinite(v) || v === 0) return false;
        const p = (propertyName(node.parent?.key) || "").toLowerCase();
        if (p === "fontsize" || p === "font-size" || p === "size" || p === "lineheight") {
          report(ctx, node, "bad");
          return true;
        }
        return false;
      },
      null
    ),

    "hardcoded-elevation": makeRule(
      { messages: { bad: "Hardcoded elevation/shadow. Use an elevation ladder or borders." } },
      (node, v, ctx) => {
        if (typeof v !== "number") return false;
        const p = (propertyName(node.parent?.key) || "").toLowerCase();
        if (p.includes("shadow") || p === "elevation") {
          report(ctx, node, "bad");
          return true;
        }
        return false;
      },
      null
    ),

    "hardcoded-duration": makeRule(
      { messages: { bad: "Hardcoded duration. Use a motion scale." } },
      (node, v, ctx) => {
        if (typeof v !== "number" || !Number.isFinite(v) || v <= 0) return false;
        const p = (propertyName(node.parent?.key) || "").toLowerCase();
        if (p.includes("duration")) {
          report(ctx, node, "bad");
          return true;
        }
        return false;
      },
      null
    ),

    "reflex-font": makeRule(
      { messages: { bad: "Reflex font (Inter/Roboto/Space Grotesk/Geist/Poppins/Montserrat)." } },
      (node, v, ctx) => {
        if (typeof v === "string" && REFLEX_FONT.test(v)) {
          report(ctx, node, "bad");
          return true;
        }
        return false;
      },
      (node, raw, ctx) => {
        if (REFLEX_FONT.test(raw)) report(ctx, node, "bad");
      }
    ),

    "linear-motion": makeRule(
      { messages: { bad: "Linear animation curve. Use an ease-out/ease-in/spring token." } },
      (node, v, ctx) => {
        if (typeof v === "string" && /\blinear\b/.test(v)) {
          report(ctx, node, "bad");
          return true;
        }
        return false;
      },
      (node, raw, ctx) => {
        if (/\blinear\b/.test(raw)) report(ctx, node, "bad");
      }
    ),

    "emoji-icon": makeRule(
      { messages: { bad: "Emoji used as an icon. Use a real icon set." } },
      (node, v, ctx) => {
        if (typeof v !== "string") return false;
        let has = false;
        for (const ch of v) {
          const cp = ch.codePointAt(0) || 0;
          if (cp === 0x20 || cp === 0x200d) continue;
          if (isEmoji(cp)) {
            has = true;
            continue;
          }
          return false;
        }
        if (has) {
          report(ctx, node, "bad");
          return true;
        }
        return false;
      },
      (node, raw, ctx) => {
        const stripped = raw.replace(/\$\{[^}]*\}/g, "").trim();
        if (stripped && [...stripped].every((ch) => {
          const cp = ch.codePointAt(0) || 0;
          return cp === 0x20 || cp === 0x200d || isEmoji(cp);
        }) && [...stripped].some((ch) => isEmoji(ch.codePointAt(0) || 0))) {
          report(ctx, node, "bad");
        }
      }
    ),

    "orientation-lock": makeRule(
      { messages: { bad: "Orientation lock detected. Support both orientations." } },
      (node, v, ctx) => {
        if (typeof v !== "string") return false;
        const p = node.parent;
        if (/\b(portrait|landscape|default)\b/i.test(v) &&
            (p?.callee?.name === "setPreferredOrientations" ||
             /orientation/i.test(v) && p?.type === "Property")) {
          report(ctx, node, "bad");
          return true;
        }
        return false;
      },
      null
    ),
  },
};
