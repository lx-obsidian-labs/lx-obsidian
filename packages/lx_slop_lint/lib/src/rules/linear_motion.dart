import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/analysis_rule/rule_context.dart';
import 'package:analyzer/analysis_rule/rule_visitor_registry.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/error/error.dart';

/// FLS-MO-02 (P1). Flags `Curves.linear` in UI animations. Ease-out for
/// entrances, ease-in for exits, springs for drag.
class LinearMotionRule extends AnalysisRule {
  static const LintCode code = LintCode(
    'linear_motion',
    'Linear animation curve. Use an ease-out/ease-in/spring token for UI motion.',
    correctionMessage: 'Reference a motion curve token (e.g. AppTokens.curveEnter).',
  );

  LinearMotionRule()
      : super(
          name: 'linear_motion',
          description: 'Flags linear animation curves in UI code.',
        );

  @override
  LintCode get diagnosticCode => code;

  @override
  void registerNodeProcessors(
      RuleVisitorRegistry registry, RuleContext context) {
    final visitor = _Visitor(this, context);
    registry.addSimpleIdentifier(this, visitor);
  }
}

class _Visitor extends SimpleAstVisitor<void> {
  final AnalysisRule rule;
  final RuleContext context;

  _Visitor(this.rule, this.context);

  @override
  void visitSimpleIdentifier(SimpleIdentifier node) {
    if (!context.isInLibDir) return;
    if (node.name != 'linear') return;
    final parent = node.parent;
    if (parent != null && parent.toSource() == 'Curves.linear') {
      rule.reportAtNode(node);
    }
  }
}
