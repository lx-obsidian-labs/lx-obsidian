import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/analysis_rule/rule_context.dart';
import 'package:analyzer/analysis_rule/rule_visitor_registry.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/error/error.dart';

import '../util.dart';

/// FLS-SH-01 / FLS-SH-04 (P1). Flags literal `elevation:` on Card/Material and
/// literal blur on BoxShadow. Use an elevation ladder, or borders/tonal
/// surfaces.
class HardcodedElevationRule extends AnalysisRule {
  static const LintCode code = LintCode(
    'hardcoded_elevation',
    'Hardcoded elevation/shadow. Use an elevation ladder or borders/tonal surfaces.',
    correctionMessage: 'Reference an elevation token, or remove the shadow.',
  );

  HardcodedElevationRule()
      : super(
          name: 'hardcoded_elevation',
          description: 'Flags literal elevation and BoxShadow blur values.',
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

  static const _elevated = {'Card', 'Material', 'PhysicalModel'};

  @override
  void visitInstanceCreationExpression(InstanceCreationExpression node) {
    if (!context.isInLibDir) return;
    final base = baseType(node);
    if (_elevated.contains(base)) {
      if (isNumeric(namedArg(node, 'elevation'))) {
        rule.reportAtNode(node);
      }
    } else if (base == 'BoxShadow') {
      if (isNumeric(namedArg(node, 'blurRadius')) ||
          isNumeric(namedArg(node, 'spreadRadius'))) {
        rule.reportAtNode(node);
      }
    }
  }
}
