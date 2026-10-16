import stylelint from "stylelint";

const COLOR_DECLS = new Set([
  "color",
  "background",
  "background-color",
  "border",
  "border-color",
  "border-top-color",
  "border-right-color",
  "border-bottom-color",
  "border-left-color",
  "outline-color",
  "fill",
  "stroke",
  "text-decoration-color",
  "box-shadow",
]);

const SPACING_DECLS = new Set([
  "margin",
  "margin-top",
  "margin-right",
  "margin-bottom",
  "margin-left",
  "padding",
  "padding-top",
  "padding-right",
  "padding-bottom",
  "padding-left",
  "gap",
  "row-gap",
  "column-gap",
  "inset",
  "top",
  "right",
  "bottom",
  "left",
  "width",
  "height",
]);

const FRAMEWORK_COLORS = new Set([
  "indigo",
  "blue",
  "purple",
  "violet",
  "cyan",
  "teal",
  "amber",
  "pink",
  "emerald",
  "slate",
  "zinc",
  "rose",
  "sky",
  "fuchsia",
]);

const EMOJI = /[\u{1F300}-\u{1F9FF}\u{2600}-\u{27BF}\u{1F1E6}-\u{1F1FF}\u{1F600}-\u{1F64F}\u{1F680}-\u{1F6FF}\u{2700}-\u{27BF}\u{FE0F}\u{200D}]/u;

const CSS_KEYWORD_COLORS = new Set([
  "red", "blue", "green", "yellow", "orange", "purple", "pink", "brown", "black",
  "white", "gray", "grey", "lime", "cyan", "magenta", "teal", "navy", "maroon",
  "olive", "silver", "aqua", "fuchsia", "rebeccapurple",
]);

const REFLEX_FONTS = /\b(Inter|Roboto|Space\s?Grotesk|Geist|Poppins|Montserrat)\b/i;

const HEX = /#([0-9a-fA-F]{3,4}|[0-9a-fA-F]{6}|[0-9a-fA-F]{8})\b/;
const RGB_FN = /\b(rgba?|hsla?|hwb|lab|lch|oklab|oklch|color)\(/i;
const PX = /-?\d*\.?\d+(px|pt|pc|in|cm|mm|Q)\b/i;
const MS = /-?\d*\.?\d+(ms|s)\b/i;
const LENGTH = /-?\d*\.?\d+(rem|em|ex|ch|vw|vh|vmin|vmax|%)/i;

function isVarOrToken(value) {
  return /var\(|--|theme\(|env\(/.test(value);
}

function reportDecl(ruleName, decl, result, message) {
  stylelint.utils.report({
    ruleName,
    result,
    node: decl,
    word: decl.value,
    message,
  });
}

const rules = {
  "hardcoded-color": {
    message: "Hardcoded color. Use design tokens (CSS variables).",
    check(decl) {
      if (isVarOrToken(decl.value)) return false;
      if (HEX.test(decl.value) || RGB_FN.test(decl.value)) return true;
      const m = decl.value.match(/\b([a-z]+)-([0-9]{2,3})\b/i);
      return !!m && FRAMEWORK_COLORS.has(m[1].toLowerCase());
    },
    applies: (decl) => COLOR_DECLS.has(decl.prop) || HEX.test(decl.value) || RGB_FN.test(decl.value),
  },
  "framework-color": {
    message: "Framework/browser keyword color used as a UI role. Use a token.",
    check(decl) {
      if (isVarOrToken(decl.value)) return false;
      return decl.value
        .toLowerCase()
        .split(/[\s,]+/)
        .some((t) => CSS_KEYWORD_COLORS.has(t));
    },
    applies: (decl) => COLOR_DECLS.has(decl.prop),
  },
  "hardcoded-spacing": {
    message: "Hardcoded spacing. Use the spacing scale (tokens).",
    check(decl) {
      if (isVarOrToken(decl.value)) return false;
      return PX.test(decl.value) && !LENGTH.test(decl.value);
    },
    applies: (decl) => SPACING_DECLS.has(decl.prop),
  },
  "hardcoded-radius": {
    message: "Hardcoded radius. Use the radius ladder.",
    check(decl) {
      if (isVarOrToken(decl.value)) return false;
      return PX.test(decl.value);
    },
    applies: (decl) => /^border(-[a-z]+)?-radius$/.test(decl.prop),
  },
  "hardcoded-font-size": {
    message: "Hardcoded font size. Use the type scale.",
    check(decl) {
      if (isVarOrToken(decl.value)) return false;
      return PX.test(decl.value) || /-?\d*\.?\d+(pt|pc)\b/i.test(decl.value);
    },
    applies: (decl) => decl.prop === "font-size" || decl.prop === "font",
  },
  "hardcoded-elevation": {
    message: "Hardcoded shadow. Use an elevation ladder or borders.",
    check(decl) {
      if (isVarOrToken(decl.value)) return false;
      return PX.test(decl.value) && /\d/.test(decl.value);
    },
    applies: (decl) => decl.prop === "box-shadow" || decl.prop === "text-shadow",
  },
  "hardcoded-duration": {
    message: "Hardcoded duration. Use a motion scale.",
    check(decl) {
      if (isVarOrToken(decl.value)) return false;
      return MS.test(decl.value);
    },
    applies: (decl) =>
      decl.prop === "transition-duration" ||
      decl.prop === "animation-duration" ||
      decl.prop === "transition" ||
      decl.prop === "animation",
  },
  },
  "reflex-font": {
    message: "Reflex/system-default font. Use a deliberately chosen typeface.",
    check(decl) {
      if (isVarOrToken(decl.value)) return false;
      return REFLEX_FONTS.test(decl.value);
    },
    applies: (decl) => decl.prop === "font-family",
  },
  "emoji-icon": {
    message: "Emoji used as an icon. Use a real icon set.",
    check(decl) {
      if (isVarOrToken(decl.value)) return false;
      const stripped = decl.value.replace(/var\([^)]*\)/g, "");
      if (EMOJI.test(stripped)) return true;
      const count = (stripped.match(EMOJI) || []).length;
      if (count === 0) return false;
      return count >= stripped.trim().length - (stripped.match(/\s/g) || []).length;
    },
    applies: (decl) => decl.prop === "content",
  },
  "linear-motion": {
    message: "Linear/unset easing. Use an ease-out/ease-in/spring token.",
    check(decl) {
      if (isVarOrToken(decl.value)) return false;
      return /\blinear\b/.test(decl.value);
    },
    applies: (decl) => decl.prop === "transition" || decl.prop === "transition-timing-function",
  },
};

const plugins = [];

for (const [name, spec] of Object.entries(rules)) {
  const ruleName = `lx-slop/${name}`;
  const rule = (primary) => {
    return (root, result) => {
      const valid = stylelint.utils.validateOptions(result, ruleName, {
        actual: primary,
        possible: [true, false],
      });
      if (!valid || !primary) return;

      root.walkDecls((decl) => {
        if (spec.applies && !spec.applies(decl)) return;
        if (spec.check(decl)) {
          reportDecl(ruleName, decl, result, spec.message);
        }
      });
    };
  };
  rule.ruleName = ruleName;
  rule.messages = { rejected: spec.message };
  plugins.push(stylelint.createPlugin(ruleName, rule));
}

export default plugins;
