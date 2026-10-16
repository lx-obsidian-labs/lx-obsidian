import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/analysis_rule/rule_context.dart';
import 'package:analyzer/analysis_rule/rule_visitor_registry.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/error/error.dart';

import '../util.dart';

/// FLS-SH-02 / FLS-SH-05 (P0). Flags magic-number spacing in `SizedBox`,
/// `EdgeInsets`, and `Container`. Use the spacing scale (`AppTokens`) instead.
class HardcodedSpacingRule extends AnalysisRule {
  static const LintCode code = LintCode(
    'hardcoded_spacing',
    'Hardcoded dimension. Use the spacing scale (AppTokens) instead of a magic number.',
    correctionMessage: 'Reference a spacing token such as context.tokens.spaceMd.',
  );

  HardcodedSpacingRule()
      : super(
          name: 'hardcoded_spacing',
          description: 'Flags magic-number spacing in SizedBox/EdgeInsets/Container.',
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
    switch (baseType(node)) {
      case 'SizedBox':
      case 'Container':
        if (isNumeric(namedArg(node, 'height')) ||
            isNumeric(namedArg(node, 'width')) ||
            isNumeric(namedArg(node, 'dimension'))) {
          rule.reportAtNode(node);
        }
      case 'EdgeInsets':
        if (hasNumericArg(node)) {
          rule.reportAtNode(node);
        }
    }
  }
}
