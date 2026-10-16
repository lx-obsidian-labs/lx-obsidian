import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/analysis_rule/rule_context.dart';
import 'package:analyzer/analysis_rule/rule_visitor_registry.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/error/error.dart';

import '../util.dart';

/// FLS-CO-01 (P0). Flags `ColorScheme.fromSeed` seeded with a reflex AI color
/// (deepPurple, indigo, blue, purple, violet). A deliberate seed is fine; these
/// are the statistical center of generated color taste.
class DefaultThemeRule extends AnalysisRule {
  static const LintCode code = LintCode(
    'default_theme',
    'Default/reflex Material seed color. Choose a seed from the subject and hand-tune it.',
    correctionMessage: 'Use a seed chosen for this product, then tune the scheme.',
  );

  DefaultThemeRule()
      : super(
          name: 'default_theme',
          description: 'Flags reflex AI seed colors passed to ColorScheme.fromSeed.',
        );

  @override
  LintCode get diagnosticCode => code;

  @override
  void registerNodeProcessors(
      RuleVisitorRegistry registry, RuleContext context) {
    final visitor = _Visitor(this, context);
    registry.addInstanceCreationExpression(this, visitor);
  }
}

class _Visitor extends SimpleAstVisitor<void> {
  final AnalysisRule rule;
  final RuleContext context;

  _Visitor(this.rule, this.context);

  static const _reflexSeeds = {
    'deepPurple', 'indigo', 'blue', 'purple', 'violet',
  };

  @override
  void visitInstanceCreationExpression(InstanceCreationExpression node) {
    if (!context.isInLibDir) return;
    if (node.constructorName.toSource() != 'ColorScheme.fromSeed') return;
    final seed = namedArg(node, 'seedColor');
    if (seed == null) return;
    final src = seed.toSource();
    if (src.startsWith('Colors.')) {
      final swatch = src.substring('Colors.'.length);
      if (_reflexSeeds.contains(swatch)) {
        rule.reportAtNode(node);
      }
    }
  }
}
