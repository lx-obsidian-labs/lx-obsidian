import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/analysis_rule/rule_context.dart';
import 'package:analyzer/analysis_rule/rule_visitor_registry.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/error/error.dart';

import '../util.dart';

/// FLS-SH-01 / FLS-SH-03 (P1). Flags literal radii in `BorderRadius`/`Radius`.
/// Use the radius ladder (`AppTokens`) instead of one radius everywhere.
class HardcodedRadiusRule extends AnalysisRule {
  static const LintCode code = LintCode(
    'hardcoded_radius',
    'Hardcoded radius. Use the radius ladder (AppTokens) instead.',
    correctionMessage: 'Reference a radius token such as context.tokens.radiusSurface.',
  );

  HardcodedRadiusRule()
      : super(
          name: 'hardcoded_radius',
          description: 'Flags literal corner radii in BorderRadius/Radius.',
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

  @override
  void visitInstanceCreationExpression(InstanceCreationExpression node) {
    if (!context.isInLibDir) return;
    final base = baseType(node);
    if (base == 'BorderRadius' || base == 'Radius') {
      if (hasNumericArg(node)) {
        rule.reportAtNode(node);
      }
    }
  }
}
