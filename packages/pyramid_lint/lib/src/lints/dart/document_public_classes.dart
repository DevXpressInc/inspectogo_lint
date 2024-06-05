import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

import '../../pyramid_lint_rule.dart';
import '../../utils/constants.dart';

class DocumentPublicClasses extends PyramidLintRule {
  DocumentPublicClasses({required super.options})
      : super(
          name: ruleName,
          problemMessage: 'All public classes should be documented',
          correctionMessage: 'Consider adding a doc comment explaining the purpose of the class before the class declaration',
          url: url,
          errorSeverity: ErrorSeverity.INFO,
        );

  static const ruleName = 'document_public_classes';
  static const url = '$dartLintDocUrl/$ruleName';

  factory DocumentPublicClasses.fromConfigs(CustomLintConfigs configs) {
    final json = configs.rules[ruleName]?.json ?? {};
    final options = PyramidLintRuleOptions.fromJson(
      json: json,
      paramsConverter: (_) => null,
    );

    return DocumentPublicClasses(options: options);
  }

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addClassDeclaration((node) {
      if (node.documentationComment == null && !node.name.lexeme.startsWith('_')) {
        final tokenBeforeBracket = node.leftBracket.previous!;
        final reportLength = tokenBeforeBracket.offset + tokenBeforeBracket.length - node.offset;
        reporter.reportErrorForOffset(code, node.offset, reportLength);
      }
    });
  }
}
