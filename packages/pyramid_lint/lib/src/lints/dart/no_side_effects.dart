import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/token.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

import '../../pyramid_lint_rule.dart';

class NoSideEffects extends PyramidLintRule {
  NoSideEffects({required super.options})
      : super(
          name: ruleName,
          problemMessage: 'Do not instanciate class for side effects.',
          correctionMessage: 'Side effects are the bane of programming.',
          url: url,
          errorSeverity: ErrorSeverity.WARNING,
        );

  static const ruleName = 'no_side_effects';
  static const url = '';

  factory NoSideEffects.fromConfigs(CustomLintConfigs configs) {
    final json = configs.rules[ruleName]?.json ?? {};
    final options = PyramidLintRuleOptions.fromJson(
      json: json,
      paramsConverter: (_) => null,
    );

    return NoSideEffects(options: options);
  }

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addInstanceCreationExpression((node) {
      final previousToken = node.beginToken.previous;
      
      if (previousToken == null || !(_isReturnToken(previousToken) || previousToken.type == TokenType.EQ)) {
        reporter.reportErrorForNode(code, node);
      }
    });
  }

  bool _isReturnToken(Token token) {
    return token is Keyword && token.keyword == Keyword.RETURN;
  }
}
