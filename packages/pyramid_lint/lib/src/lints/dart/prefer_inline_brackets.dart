import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

import '../../pyramid_lint_rule.dart';
import '../../utils/constants.dart';

class PreferInlineBrackets extends PyramidLintRule {
  PreferInlineBrackets({required super.options})
      : super(
          name: ruleName,
          problemMessage: 'Prefer inline curly and square brackets',
          correctionMessage: 'Consider putting bracket on the same line as the block or declaration',
          url: url,
          errorSeverity: ErrorSeverity.INFO,
        );

  static const ruleName = 'prefer_inline_brackets';
  static const url = '';

  factory PreferInlineBrackets.fromConfigs(CustomLintConfigs configs) {
    final json = configs.rules[ruleName]?.json ?? {};
    final options = PyramidLintRuleOptions.fromJson(
      json: json,
      paramsConverter: (_) => null,
    );

    return PreferInlineBrackets(options: options);
  }

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addBlock((node) {
      final leftBracket = node.leftBracket;
      final previousToken = leftBracket.previous;
      
      if (previousToken == null) return;

      // TODO: Find a way to handle anonymous blocks

      final lineInfo = resolver.lineInfo;
      final leftBracketLine = lineInfo.getLocation(leftBracket.offset).lineNumber;
      final previousTokenLine = lineInfo.getLocation(previousToken.offset).lineNumber;

      if (leftBracketLine - previousTokenLine > 0) {
        reporter.reportErrorForOffset(code, leftBracket.offset, 1);
      }
    });
    context.registry.addListLiteral((node) {
      final leftBracket = node.leftBracket;
      final previousToken = node.beginToken.previous;
      
      if (previousToken == null) return;

      // TODO: Find a way to handle anonymous blocks

      final lineInfo = resolver.lineInfo;
      final leftBracketLine = lineInfo.getLocation(leftBracket.offset).lineNumber;
      final previousTokenLine = lineInfo.getLocation(previousToken.offset).lineNumber;

      if (leftBracketLine - previousTokenLine > 0) {
        reporter.reportErrorForOffset(code, leftBracket.offset, 1);
      }
    });
    context.registry.addSetOrMapLiteral((node) {
      final leftBracket = node.leftBracket;
      final previousToken = node.beginToken.previous;
      
      if (previousToken == null) return;

      // TODO: Find a way to handle anonymous blocks

      final lineInfo = resolver.lineInfo;
      final leftBracketLine = lineInfo.getLocation(leftBracket.offset).lineNumber;
      final previousTokenLine = lineInfo.getLocation(previousToken.offset).lineNumber;

      if (leftBracketLine - previousTokenLine > 0) {
        reporter.reportErrorForOffset(code, leftBracket.offset, 1);
      }
    });
  }
}
