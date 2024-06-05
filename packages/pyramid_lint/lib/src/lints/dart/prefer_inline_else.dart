import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/token.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

import '../../pyramid_lint_rule.dart';
import '../../utils/constants.dart';

class PreferInlineElse extends PyramidLintRule {
  PreferInlineElse({required super.options})
      : super(
          name: ruleName,
          problemMessage: 'Prefer inline else and elseif.',
          correctionMessage: 'Consider putting the else or elseif inline with the previous closing curly bracket.',
          url: url,
          errorSeverity: ErrorSeverity.WARNING,
        );

  static const ruleName = 'prefer_inline_else';
  static const url = '$dartLintDocUrl/$ruleName';

  factory PreferInlineElse.fromConfigs(CustomLintConfigs configs) {
    final json = configs.rules[ruleName]?.json ?? {};
    final options = PyramidLintRuleOptions.fromJson(
      json: json,
      paramsConverter: (_) => null,
    );

    return PreferInlineElse(options: options);
  }

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addIfStatement((node) {
      final elseKeyword = node.elseKeyword;
      if (elseKeyword == null || node.elseStatement is IfStatement) return;
      final previousBracket = elseKeyword.previous;
      
      if (previousBracket == null || previousBracket.type != TokenType.CLOSE_CURLY_BRACKET) return;
      final lineInfo = resolver.lineInfo;
      final previousBracketLine = lineInfo.getLocation(previousBracket.offset).lineNumber;
      final elseLine = lineInfo.getLocation(elseKeyword.offset).lineNumber;

      if (elseLine - previousBracketLine == 0) {
        reporter.reportErrorForOffset(code, elseKeyword.offset, elseKeyword.length);
      }
    });
  }
}
