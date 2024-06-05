import 'package:analyzer/dart/ast/token.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

import '../../pyramid_lint_rule.dart';

class NewlineBetweenClassMembers extends PyramidLintRule {
  NewlineBetweenClassMembers({required super.options})
      : super(
          name: ruleName,
          problemMessage:
              'Expected blank line between class members',
          correctionMessage:
              'Add a blank line',
          url: url,
          errorSeverity: ErrorSeverity.WARNING,
        );

  static const ruleName = 'newline_between_class_members';
  static const url = '';

  factory NewlineBetweenClassMembers.fromConfigs(CustomLintConfigs configs) {
    final json = configs.rules[ruleName]?.json ?? {};
    final options = PyramidLintRuleOptions.fromJson(
      json: json,
      paramsConverter: (_) => null,
    );

    return NewlineBetweenClassMembers(options: options);
  }

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addClassMember((node) {
      final endToken = node.endToken;
      final nextToken = endToken.next;

      if (nextToken == null || nextToken.type == TokenType.CLOSE_CURLY_BRACKET) return;

      final lineInfo = resolver.lineInfo;
      final endLine = lineInfo.getLocation(endToken.offset).lineNumber;
      final nextLine = lineInfo.getLocation(nextToken.offset).lineNumber;

      if (nextLine - endLine == 1) {
        reporter.reportErrorForOffset(code, endToken.offset, endToken.length);
      }
    });
  }

  @override
  List<Fix> getFixes() => [_AddNewlineBetweenClassMembers()];
}

class _AddNewlineBetweenClassMembers extends DartFix {
  @override
  void run(
    CustomLintResolver resolver,
    ChangeReporter reporter,
    CustomLintContext context,
    AnalysisError analysisError,
    List<AnalysisError> others,
  ) {
    context.registry.addClassMember((node) {
      if (!analysisError.sourceRange.intersects(node.sourceRange)) return;

      final changeBuilder = reporter.createChangeBuilder(
        message: 'Add a blank line',
        priority: 80,
      );

      changeBuilder.addDartFileEdit((builder) {
        builder.addSimpleInsertion(node.end, '\n');
      });
    });
  }
}
