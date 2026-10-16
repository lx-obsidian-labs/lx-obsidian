import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/analysis_rule/rule_context.dart';
import 'package:analyzer/analysis_rule/rule_visitor_registry.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/error/error.dart';

/// FLS-CO-02 (P0). Flags framework swatches (`Colors.blue`, …) used for UI
/// roles. `Colors.transparent` is allowed.
class FrameworkColorRule extends AnalysisRule {
  static const LintCode code = LintCode(
    'framework_color',
    'Framework color swatch used for a UI role. Use a semantic token.',
    correctionMessage:
        'Reference colorScheme or AppTokens instead of Colors.<swatch>.',
  );

  FrameworkColorRule()
      : super(
          name: 'framework_color',
          description: 'Flags framework color swatches used for UI roles.',
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

  static const _swatches = {
    'blue', 'blueGrey', 'brown', 'cyan', 'deepOrange', 'deepPurple',
    'green', 'grey', 'indigo', 'lightBlue', 'lightGreen', 'lime',
    'orange', 'pink', 'purple', 'red', 'teal', 'yellow', 'amber', 'violet',
  };

  @override
  void visitSimpleIdentifier(SimpleIdentifier node) {
    if (!context.isInLibDir) return;
    if (!_swatches.contains(node.name)) return;
    final parent = node.parent;
    if (parent != null && parent.toSource() == 'Colors.${node.name}') {
      rule.reportAtNode(node);
    }
  }
}
