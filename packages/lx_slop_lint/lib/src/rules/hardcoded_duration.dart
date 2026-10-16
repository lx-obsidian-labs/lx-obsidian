import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/analysis_rule/rule_context.dart';
import 'package:analyzer/analysis_rule/rule_visitor_registry.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/error/error.dart';

import '../util.dart';

/// FLS-MO-03 (P1). Flags magic-number durations (`Duration(milliseconds: 300)`)
/// in UI code. Use a motion token so timing is consistent and tunable.
class HardcodedDurationRule extends AnalysisRule {
  static const LintCode code = LintCode(
    'hardcoded_duration',
    'Hardcoded duration. Use a motion token instead of a magic number.',
    correctionMessage: 'Reference a duration token (e.g. AppTokens.motionFast).',
  );

  HardcodedDurationRule()
      : super(
          name: 'hardcoded_duration',
          description: 'Flags magic-number Duration(...) literals in UI code.',
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

  static const _units = {'days', 'hours', 'minutes', 'seconds', 'milliseconds', 'microseconds'};

  @override
  void visitInstanceCreationExpression(InstanceCreationExpression node) {
    if (!context.isInLibDir) return;
    if (baseType(node) != 'Duration') return;
    for (final unit in _units) {
      if (isNumeric(namedArg(node, unit))) {
        rule.reportAtNode(node);
        return;
      }
    }
  }
}
