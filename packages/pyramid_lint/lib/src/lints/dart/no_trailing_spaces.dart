import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

import '../../pyramid_lint_rule.dart';

class NoTrailingSpaces extends PyramidLintRule {
  NoTrailingSpaces({required super.options})
      : super(
          name: ruleName,
          problemMessage:
              'Trailing spaces not allowed',
          correctionMessage:
              'Remove the trailing spaces',
          url: url,
          errorSeverity: ErrorSeverity.INFO,
        );

  static const ruleName = 'no_trailing_spaces';
  static const url = '';

  factory NoTrailingSpaces.fromConfigs(CustomLintConfigs configs) {
    final json = configs.rules[ruleName]?.json ?? {};
    final options = PyramidLintRuleOptions.fromJson(
      json: json,
      paramsConverter: (_) => null,
    );

    return NoTrailingSpaces(options: options);
  }

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addCompilationUnit((node) {
      var token = node.beginToken;
      //! Infinite loop (?)
      while(token.next != null) {
        final nextToken = token.next!;
        final separationLength = nextToken.offset - token.end;

        if (separationLength > 1) {
          reporter.reportErrorForOffset(code, nextToken.offset, separationLength);
        }
        token = nextToken;
      }
    });
  }
}
