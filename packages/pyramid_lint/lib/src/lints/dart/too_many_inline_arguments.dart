import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

import '../../pyramid_lint_rule.dart';
import '../../utils/constants.dart';

class TooManyInlineArguments extends PyramidLintRule {
  TooManyInlineArguments({required super.options})
      : super(
          name: ruleName,
          problemMessage: 'When an argument list has too many arguments, avoid putting them inline.',
          correctionMessage: 'Consider putting each argument on a new line.',
          url: url,
          errorSeverity: ErrorSeverity.INFO,
        );

  static const ruleName = 'too_many_inline_arguments';
  static const url = '$dartLintDocUrl/$ruleName';

  factory TooManyInlineArguments.fromConfigs(CustomLintConfigs configs) {
    final json = configs.rules[ruleName]?.json ?? {};
    final options = PyramidLintRuleOptions.fromJson(
      json: json,
      paramsConverter: (_) => null,
    );

    return TooManyInlineArguments(options: options);
  }

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addArgumentList((node) {
      // TODO: Add support for custom amount of arguments
      if (node.arguments.length < 3) return;

      final lineInfo = resolver.lineInfo;
      final previousToken = node.arguments[0].beginToken.previous!;

      var prevLine = lineInfo.getLocation(previousToken.offset).lineNumber;

      for (final argument in node.arguments) {
        final argLine = lineInfo.getLocation(argument.offset).lineNumber;
        if (argLine - prevLine == 0) {
          reporter.reportErrorForOffset(code, argument.offset, argument.length);
        }
        prevLine = argLine;
      }
    });

    context.registry.addFormalParameterList((node) {
      if (node.parameters.length < 3) return;

      final lineInfo = resolver.lineInfo;
      final previousToken = node.parameters[0].beginToken.previous!;

      var prevLine = lineInfo.getLocation(previousToken.offset).lineNumber;

      for (final argument in node.parameters) {
        final argLine = lineInfo.getLocation(argument.offset).lineNumber;
        if (argLine - prevLine == 0) {
          reporter.reportErrorForOffset(code, argument.offset, argument.length);
        }
        prevLine = argLine;
      }
    });
  }
}
