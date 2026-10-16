import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/analysis_rule/rule_context.dart';
import 'package:analyzer/analysis_rule/rule_visitor_registry.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/error/error.dart';

/// FLS-CO-03 (P0). Flags raw `Color(0x…)` / `Color.fromARGB(…)` literals in
/// widget code. Reference a colorScheme role or an AppTokens value instead.
class HardcodedColorRule extends AnalysisRule {
  static const LintCode code = LintCode(
    'hardcoded_color',
    'Hardcoded Color value. Reference a colorScheme role or AppTokens instead.',
    correctionMessage: 'Use Theme.of(context).colorScheme or a color token.',
  );

  HardcodedColorRule()
      : super(
          name: 'hardcoded_color',
          description: 'Flags hardcoded Color values in widget code.',
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

  static const _ctors = {
    'Color',
    'Color.from',
    'Color.fromARGB',
    'Color.fromRGBO',
  };

  @override
  void visitInstanceCreationExpression(InstanceCreationExpression node) {
    if (!context.isInLibDir) return;
    if (_ctors.contains(node.constructorName.toSource())) {
      rule.reportAtNode(node);
    }
  }
}
