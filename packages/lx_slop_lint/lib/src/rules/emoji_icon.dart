import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/analysis_rule/rule_context.dart';
import 'package:analyzer/analysis_rule/rule_visitor_registry.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/error/error.dart';

import '../util.dart';

/// FLS-CM-06 (P0). Flags emoji used as an icon or bullet inside `Text`. Use a
/// real icon set; reserve emoji for copy where the voice calls for it.
class EmojiIconRule extends AnalysisRule {
  static const LintCode code = LintCode(
    'emoji_icon',
    'Emoji used as an icon. Use a real icon set instead.',
    correctionMessage: 'Replace the emoji with a themed Icon or drop it.',
  );

  EmojiIconRule()
      : super(
          name: 'emoji_icon',
          description: 'Flags emoji used as icons in Text widgets.',
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
    if (baseType(node) != 'Text') return;
    final first = positionalArg(node, 0);
    if (first is SimpleStringLiteral) {
      if (isEmojiOnly(first.value)) {
        rule.reportAtNode(node);
      }
    }
  }
}
