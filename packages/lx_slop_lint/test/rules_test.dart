// Tests for the lx_slop_lint rules using the official analyzer_testing
// framework (analyzer 10 / analysis_server_plugin).
//
// Each snippet is self-contained with local stubs so the file resolves cleanly
// and the only diagnostic produced is the rule under test. Rules are registered
// as lint rules so that only the one enabled by the harness runs.
import 'package:analyzer/src/lint/registry.dart'; // ignore: implementation_imports
import 'package:analyzer_testing/analysis_rule/analysis_rule.dart';
import 'package:lx_slop_lint/lx_slop_lint.dart';
import 'package:test_reflective_loader/test_reflective_loader.dart';

void main() {
  defineReflectiveSuite(() {
    defineReflectiveTests(HardcodedColorRuleTest);
    defineReflectiveTests(FrameworkColorRuleTest);
    defineReflectiveTests(DefaultThemeRuleTest);
    defineReflectiveTests(HardcodedSpacingRuleTest);
    defineReflectiveTests(HardcodedRadiusRuleTest);
    defineReflectiveTests(HardcodedFontSizeRuleTest);
    defineReflectiveTests(HardcodedElevationRuleTest);
    defineReflectiveTests(OrientationLockRuleTest);
    defineReflectiveTests(LinearMotionRuleTest);
    defineReflectiveTests(EmojiIconRuleTest);
    defineReflectiveTests(HardcodedDurationRuleTest);
  });
}

@reflectiveTest
class HardcodedColorRuleTest extends AnalysisRuleTest {
  @override
  String get analysisRule => 'hardcoded_color';

  @override
  void setUp() {
    Registry.ruleRegistry.registerLintRule(HardcodedColorRule());
    super.setUp();
  }

  void test_rawHex() async {
    await assertDiagnostics(
      r'''
class Color {
  const Color(int value);
}
void f() {
  final c = Color(0xFF1A1A1A);
}
''',
      [lint(65, 17)],
    );
  }

  void test_fromARGB() async {
    await assertDiagnostics(
      r'''
class Color {
  const Color.fromARGB(int a, int r, int g, int b);
}
void f() {
  final c = Color.fromARGB(255, 0, 0, 0);
}
''',
      [lint(91, 28)],
    );
  }

  void test_ok() async {
    await assertNoDiagnostics(r'''
class Color {
  const Color(int value);
}
void f(Color c) {}
''');
  }
}

@reflectiveTest
class FrameworkColorRuleTest extends AnalysisRuleTest {
  @override
  String get analysisRule => 'framework_color';

  @override
  void setUp() {
    Registry.ruleRegistry.registerLintRule(FrameworkColorRule());
    super.setUp();
  }

  void test_swatch() async {
    await assertDiagnostics(
      r'''
class Color {
  const Color(int value);
}
class Colors {
  static const Color blue = Color(0);
}
void f() {
  final c = Colors.blue;
}
''',
      [lint(127, 4)],
    );
  }

  void test_transparentAllowed() async {
    await assertNoDiagnostics(r'''
class Color {
  const Color(int value);
}
class Colors {
  static const Color transparent = Color(0);
}
void f() {
  final c = Colors.transparent;
}
''');
  }
}

@reflectiveTest
class DefaultThemeRuleTest extends AnalysisRuleTest {
  @override
  String get analysisRule => 'default_theme';

  @override
  void setUp() {
    Registry.ruleRegistry.registerLintRule(DefaultThemeRule());
    super.setUp();
  }

  void test_reflexSeed() async {
    await assertDiagnostics(
      r'''
class Color {
  const Color(int value);
}
class Colors {
  static const Color deepPurple = Color(0);
}
class ColorScheme {
  const ColorScheme.fromSeed({required Color seedColor});
}
void f() {
  final s = ColorScheme.fromSeed(seedColor: Colors.deepPurple);
}
''',
      [lint(206, 50)],
    );
  }

  void test_customSeedOk() async {
    await assertNoDiagnostics(r'''
class Color {
  const Color(int value);
}
class Colors {
  static const Color teal = Color(0);
}
class ColorScheme {
  const ColorScheme.fromSeed({required Color seedColor});
}
void f() {
  final s = ColorScheme.fromSeed(seedColor: Colors.teal);
}
''');
  }
}

@reflectiveTest
class HardcodedSpacingRuleTest extends AnalysisRuleTest {
  @override
  String get analysisRule => 'hardcoded_spacing';

  @override
  void setUp() {
    Registry.ruleRegistry.registerLintRule(HardcodedSpacingRule());
    super.setUp();
  }

  void test_sizedBox() async {
    await assertDiagnostics(
      r'''
class SizedBox {
  const SizedBox({double? height, double? width});
}
void f() {
  final s = SizedBox(height: 16);
}
''',
      [lint(93, 20)],
    );
  }

  void test_edgeInsets() async {
    await assertDiagnostics(
      r'''
class EdgeInsets {
  const EdgeInsets.all(double value);
}
void f() {
  final e = EdgeInsets.all(16);
}
''',
      [lint(82, 18)],
    );
  }
}

@reflectiveTest
class HardcodedRadiusRuleTest extends AnalysisRuleTest {
  @override
  String get analysisRule => 'hardcoded_radius';

  @override
  void setUp() {
    Registry.ruleRegistry.registerLintRule(HardcodedRadiusRule());
    super.setUp();
  }

  void test_circular() async {
    await assertDiagnostics(
      r'''
class BorderRadius {
  const BorderRadius.circular(double radius);
}
void f() {
  final r = BorderRadius.circular(12);
}
''',
      [lint(92, 25)],
    );
  }
}

@reflectiveTest
class HardcodedFontSizeRuleTest extends AnalysisRuleTest {
  @override
  String get analysisRule => 'hardcoded_font_size';

  @override
  void setUp() {
    Registry.ruleRegistry.registerLintRule(HardcodedFontSizeRule());
    super.setUp();
  }

  void test_fontSize() async {
    await assertDiagnostics(
      r'''
class TextStyle {
  const TextStyle({double? fontSize});
}
void f() {
  final s = TextStyle(fontSize: 22);
}
''',
      [lint(82, 23)],
    );
  }
}

@reflectiveTest
class HardcodedElevationRuleTest extends AnalysisRuleTest {
  @override
  String get analysisRule => 'hardcoded_elevation';

  @override
  void setUp() {
    Registry.ruleRegistry.registerLintRule(HardcodedElevationRule());
    super.setUp();
  }

  void test_cardElevation() async {
    await assertDiagnostics(
      r'''
class Card {
  const Card({double? elevation});
}
void f() {
  final c = Card(elevation: 4);
}
''',
      [lint(73, 18)],
    );
  }
}

@reflectiveTest
class OrientationLockRuleTest extends AnalysisRuleTest {
  @override
  String get analysisRule => 'orientation_lock';

  @override
  void setUp() {
    Registry.ruleRegistry.registerLintRule(OrientationLockRule());
    super.setUp();
  }

  void test_lock() async {
    await assertDiagnostics(
      r'''
class SystemChrome {
  static void setPreferredOrientations(List<Object> orientations) {}
}
void f() {
  SystemChrome.setPreferredOrientations([1]);
}
''',
      [lint(105, 42)],
    );
  }
}

@reflectiveTest
class LinearMotionRuleTest extends AnalysisRuleTest {
  @override
  String get analysisRule => 'linear_motion';

  @override
  void setUp() {
    Registry.ruleRegistry.registerLintRule(LinearMotionRule());
    super.setUp();
  }

  void test_linear() async {
    await assertDiagnostics(
      r'''
class Curves {
  static const int linear = 0;
}
void f() {
  final c = Curves.linear;
}
''',
      [lint(78, 6)],
    );
  }
}

@reflectiveTest
class EmojiIconRuleTest extends AnalysisRuleTest {
  @override
  String get analysisRule => 'emoji_icon';

  @override
  void setUp() {
    Registry.ruleRegistry.registerLintRule(EmojiIconRule());
    super.setUp();
  }

  void test_emoji() async {
    await assertDiagnostics(
      r'''
class Text {
  const Text(String data);
}
void f() {
  final t = Text('🎯');
}
''',
      [lint(65, 10)],
    );
  }

  void test_normalTextOk() async {
    await assertNoDiagnostics(r'''
class Text {
  const Text(String data);
}
void f() {
  final t = Text('Add plant');
}
''');
  }
}

@reflectiveTest
class HardcodedDurationRuleTest extends AnalysisRuleTest {
  @override
  String get analysisRule => 'hardcoded_duration';

  @override
  void setUp() {
    Registry.ruleRegistry.registerLintRule(HardcodedDurationRule());
    super.setUp();
  }

  void test_milliseconds() async {
    await assertDiagnostics(
      r'''
class Duration {
  const Duration({int? milliseconds});
}
void f() {
  final d = Duration(milliseconds: 300);
}
''',
      [lint(81, 27)],
    );
  }

  void test_tokenOk() async {
    await assertNoDiagnostics(r'''
class Duration {
  const Duration({int? milliseconds});
}
void f(int ms) {
  final d = Duration(milliseconds: ms);
}
''');
  }
}
