# lint/compose — detekt profile for Jetpack Compose slop

Machine side of `skills/lx-compose-tells` (CMP tell catalog). `detekt.yml` enables the
relevant **built-in** detekt rules and documents the custom `lxSlop:` rules, which use the
universal rule names from `skills/lx-obsidian/references/slop-taxonomy.md`.

## Run it

```kotlin
// build.gradle.kts (app module)
plugins { id("io.gitlab.arturbosch.detekt") version "1.23.7" }
dependencies {
  detektPlugins("io.gitlab.arturbosch.detekt:detekt-formatting:1.23.7")
  detektPlugins(project(":lint:compose:lx-slop-ruleset"))   // custom rules, see below
}
detekt { config.setFrom(files("lint/compose/detekt.yml")); buildUponDefaultConfig = true }
```
`./gradlew :app:detekt` — or `detekt --config lint/compose/detekt.yml app/src/main`. Report
findings as in `lx-slop-guard`: counts by rule, counts by file, top-5 fixes by leverage,
suppressions with reasons.

## Custom ruleset (`lx-slop-ruleset`)

A small Kotlin module registering detekt `Rule` subclasses via a `RuleSetProvider`
(`META-INF/services/io.gitlab.arturbosch.detekt.api.RuleSetProvider`). Starting point —
verify against your detekt version's API:

```kotlin
class LxSlopHardcodedColor(config: Config = Config.empty) : Rule(config) {
    override val issue = Issue("hardcoded_color", Severity.Defect,
        "Raw color literal in render path; use a colorScheme role or token.", Debt.FIVE_MINS)
    private val hex = Regex("""^0x[0-9a-fA-F]{6,8}$""")
    override fun visitCallExpression(node: KtCallExpression) {
        super.visitCallExpression(node)
        if (node.calleeExpression?.text != "Color") return
        val arg = node.valueArguments.firstOrNull()?.getArgumentExpression()?.text ?: return
        if (hex.matches(arg)) report(CompactedSourceAt(node))   // report(CodeSmell(issue, Entity.from(node), msg))
    }
}
// class LxSlopRuleSetProvider : RuleSetProvider { override val ruleSetId = "lxSlop"; … }
```

Implement the eleven `lxSlop:` rules in `detekt.yml` (hardcoded_color, framework_color,
default_theme, hardcoded_spacing, hardcoded_radius, hardcoded_font_size, hardcoded_elevation,
reflex_font, emoji_icon, linear_motion, orientation_lock). Suppress with
`// detekt-suppress LxSlopHardcodedColor`.

## Fallback scanner

No Kotlin toolchain? Extend `scripts/lx_scan.sh`'s rule table with Kotlin regexes (e.g.
`hardcoded_color|P0|Color\(\s*0x|`, `hardcoded_spacing|P0|padding\(\s*[0-9]|`,
`orientation_lock|P0|SCREEN_ORIENTATION_PORTRAIT|`, `linear_motion|P1|LinearEasing|`) and run
it over `app/src`. Same output shape as the Dart profile: `file:line  rule  severity  message`.

## Honest limitation

**This environment has no Kotlin/Android toolchain — the custom ruleset jar was not built or
tested here.** The `Rule` skeleton above is a starting point, not a verified plugin. Until
the jar compiles and passes detekt's own test harness, `detekt.yml` stands on its built-in
rules (MagicNumber, LongMethod, …) plus the scanner fallback. Rendered (`👁`) tells — layout,
copy, palette harmony, "soul" — stay human regardless: `lx-design-verify` and eyes.
