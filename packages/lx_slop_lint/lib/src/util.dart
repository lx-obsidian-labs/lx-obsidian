import 'package:analyzer/dart/ast/ast.dart';

/// The type name of an instance creation, without the constructor part.
/// `ColorScheme.fromSeed(...)` -> `ColorScheme`, `SizedBox(...)` -> `SizedBox`.
String baseType(InstanceCreationExpression node) {
  final src = node.constructorName.toSource();
  final dot = src.indexOf('.');
  return dot == -1 ? src : src.substring(0, dot);
}

/// The named constructor, if any. `ColorScheme.fromSeed` -> `fromSeed`.
String? ctorName(InstanceCreationExpression node) {
  final src = node.constructorName.toSource();
  final dot = src.indexOf('.');
  return dot == -1 ? null : src.substring(dot + 1);
}

/// The expression passed to a named argument, or null.
Expression? namedArg(InstanceCreationExpression node, String name) {
  for (final a in node.argumentList.arguments) {
    if (a is NamedExpression && a.name.label.name == name) {
      return a.expression;
    }
  }
  return null;
}

/// The nth positional argument, or null.
Expression? positionalArg(InstanceCreationExpression node, int index) {
  var i = 0;
  for (final a in node.argumentList.arguments) {
    if (a is NamedExpression) continue;
    if (i == index) return a;
    i++;
  }
  return null;
}

/// The label text of a named expression (`fontSize` from `fontSize: 12`).
String labelName(NamedExpression a) => a.name.label.name;

/// Whether the expression is an integer or double literal.
bool isNumeric(Expression? e) => e is IntegerLiteral || e is DoubleLiteral;

/// Whether any argument (positional or named) is a numeric literal.
bool hasNumericArg(InstanceCreationExpression node) {
  for (final a in node.argumentList.arguments) {
    final e = a is NamedExpression ? a.expression : a;
    if (e is IntegerLiteral || e is DoubleLiteral) return true;
  }
  return false;
}

/// Approximate emoji/dingbat/pictograph ranges.
bool _isEmojiRune(int r) {
  return (r >= 0x1F000 && r <= 0x1FAFF) ||
      (r >= 0x2600 && r <= 0x27BF) ||
      (r >= 0x2B00 && r <= 0x2BFF) ||
      (r >= 0x2190 && r <= 0x21FF) ||
      (r >= 0x1F1E6 && r <= 0x1F1FF) ||
      (r >= 0xFE00 && r <= 0xFE0F) || // variation selectors
      (r >= 0x1F900 && r <= 0x1F9FF) ||
      r == 0x2764 ||
      r == 0x2049;
}

/// True when the string contains at least one emoji and nothing but emoji,
/// joiners, variation selectors, or whitespace.
bool isEmojiOnly(String value) {
  final t = value.trim();
  if (t.isEmpty) return false;
  var hasEmoji = false;
  for (final r in t.runes) {
    if (r == 0x20 || r == 0x200D) continue; // space, ZWJ
    if (_isEmojiRune(r)) {
      hasEmoji = true;
      continue;
    }
    return false;
  }
  return hasEmoji;
}
