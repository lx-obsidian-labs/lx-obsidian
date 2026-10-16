import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/analysis_rule/rule_context.dart';
import 'package:analyzer/analysis_rule/rule_visitor_registry.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/error/error.dart';

/// FLS-X-06 (P0). Flags `SystemChrome.setPreferredOrientations`. Locking
/// portrait breaks tablets and web; support both orientations.
class OrientationLockRule extends AnalysisRule {
  static const LintCode code = LintCode(
    'orientation_lock',
    'Orientation lock detected. Support both orientations for phones, tablets, and web.',
    correctionMessage: 'Remove the orientation lock, or scope it to one device class.',
  );

  OrientationLockRule()
      : super(
          name: 'orientation_lock',
          description: 'Flags SystemChrome.setPreferredOrientations orientation locks.',
        );

  @override
  LintCode get diagnosticCode => code;

  @override
  void registerNodeProcessors(
      RuleVisitorRegistry registry, RuleContext context) {
    final visitor = _Visitor(this, context);
    registry.addMethodInvocation(this, visitor);
  }
}

class _Visitor extends SimpleAstVisitor<void> {
  final AnalysisRule rule;
  final RuleContext context;

  _Visitor(this.rule, this.context);

  @override
  void visitMethodInvocation(MethodInvocation node) {
    if (!context.isInLibDir) return;
    if (node.methodName.name == 'setPreferredOrientations' &&
        node.target?.toSource() == 'SystemChrome') {
      rule.reportAtNode(node);
    }
  }
}
