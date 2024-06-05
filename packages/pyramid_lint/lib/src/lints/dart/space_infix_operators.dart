import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

import '../../pyramid_lint_rule.dart';
import '../../utils/lint_code_extension.dart';

class SpaceInfixOperators extends PyramidLintRule {
  SpaceInfixOperators({required super.options})
      : super(
          name: ruleName,
          problemMessage:
              "Operator '{operator}' must be spaced.",
          correctionMessage:
              'Add blank spaces around the operator.',
          url: url,
          errorSeverity: ErrorSeverity.INFO,
        );

  static const ruleName = 'space_infix_operators';
  static const url = '';

  factory SpaceInfixOperators.fromConfigs(CustomLintConfigs configs) {
    final json = configs.rules[ruleName]?.json ?? {};
    final options = PyramidLintRuleOptions.fromJson(
      json: json,
      paramsConverter: (_) => null,
    );

    return SpaceInfixOperators(options: options);
  }

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addBinaryExpression((node) {
      final left = node.leftOperand;
      final operator = node.operator;
      final right = node.rightOperand;
      final lineInfo = resolver.lineInfo;

      final leftLine = lineInfo.getLocation(left.offset).lineNumber;
      final operatorLine = lineInfo.getLocation(operator.offset).lineNumber;
      final rightLine = lineInfo.getLocation(right.offset).lineNumber;

      final leftSpacing = operator.offset - left.offset + left.length - 1;
      final rightSpacing = right.offset - operator.offset;

      final leftSameLine = leftLine == operatorLine;
      final rightSameLine = rightLine == operatorLine;

      if (leftSameLine && leftSpacing < 2 || rightSameLine && rightSpacing < 2) {
        final customMessage = code.problemMessage.replaceFirst('{operator}', operator.lexeme);
        final customCode = code.copyWith(problemMessage: customMessage);
        reporter.reportErrorForOffset(customCode, operator.offset, operator.length);
      }

    });
    //TODO: For some reason, doesn't work with assignment expressions
    context.registry.addAssignmentExpression((node) {
      final left = node.leftHandSide;
      final operator = node.operator;
      final right = node.rightHandSide;
      final lineInfo = resolver.lineInfo;

      final leftLine = lineInfo.getLocation(left.offset).lineNumber;
      final operatorLine = lineInfo.getLocation(operator.offset).lineNumber;
      final rightLine = lineInfo.getLocation(right.offset).lineNumber;

      final leftSpacing = operator.offset - left.offset + left.length - 1;
      final rightSpacing = right.offset - operator.offset;

      final leftSameLine = leftLine == operatorLine;
      final rightSameLine = rightLine == operatorLine;

      if (leftSameLine && leftSpacing < 2 || rightSameLine && rightSpacing < 2) {
        final customMessage = code.problemMessage.replaceFirst('{operator}', operator.lexeme);
        final customCode = code.copyWith(problemMessage: customMessage);

        reporter.reportErrorForOffset(customCode, operator.offset, operator.length);
      }
    });
  }
  @override
  List<Fix> getFixes() => [_AddSpacingToInfixOperator()];
}

class _AddSpacingToInfixOperator extends DartFix {
  @override
  void run(
    CustomLintResolver resolver,
    ChangeReporter reporter,
    CustomLintContext context,
    AnalysisError analysisError,
    List<AnalysisError> others,
  ) {
    context.registry.addAssignmentExpression((node) {
      if (!analysisError.sourceRange.intersects(node.sourceRange)) return;

      final changeBuilder = reporter.createChangeBuilder(
        message: 'Add spacing around operator',
        priority: 80,
      );

      // TODO: Implement this correctly
      changeBuilder.addDartFileEdit((builder) {
        builder.addSimpleInsertion(node.operator.offset, ' ');
      });
    });
  }
}
