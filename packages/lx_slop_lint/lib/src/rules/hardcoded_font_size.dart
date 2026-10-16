import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/analysis_rule/rule_context.dart';
import 'package:analyzer/analysis_rule/rule_visitor_registry.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/error/error.dart';

import '../util.dart';

/// FLS-TY-01 / FLS-TY-04 (P0). Flags literal `fontSize:` inside a `TextStyle`.
/// Type comes from the TextTheme / type scale, not from magic numbers.
class HardcodedFontSizeRule extends AnalysisRule {
  static const LintCode code = LintCode(
    'hardcoded_font_size',
    'Hardcoded fontSize. Use the type scale from the TextTheme instead.',
    correctionMessage: 'Reference a TextTheme style or a type token.',
  );

  HardcodedFontSizeRule()
      : super(
          name: 'hardcoded_font_size',
          description: 'Flags literal fontSize values in TextStyle.',
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
    if (baseType(node) == 'TextStyle') {
      if (isNumeric(namedArg(node, 'fontSize'))) {
        rule.reportAtNode(node);
      }
    }
  }
}
