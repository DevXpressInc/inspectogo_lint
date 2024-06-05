import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

import '../../pyramid_lint_rule.dart';

class DocumentClassMembers extends PyramidLintRule {
  DocumentClassMembers({required super.options})
      : super(
          name: ruleName,
          problemMessage:
              'All class members should be documented',
          correctionMessage:
              'Consider writing a doc comment explaining what the member does',
          url: url,
          errorSeverity: ErrorSeverity.INFO,
        );

  static const ruleName = 'newline_after_var';
  static const url = '';

  factory DocumentClassMembers.fromConfigs(CustomLintConfigs configs) {
    final json = configs.rules[ruleName]?.json ?? {};
    final options = PyramidLintRuleOptions.fromJson(
      json: json,
      paramsConverter: (_) => null,
    );

    return DocumentClassMembers(options: options);
  }

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addClassMember((node) {
      if (node.documentationComment == null) {

        final int reportLength;
        if (node is MethodDeclaration) {
          reportLength = node.body.beginToken.offset - node.offset;
        } else if (node is ConstructorDeclaration) {
          reportLength = node.body.beginToken.offset - node.offset;
        } else {
          reportLength = node.length;
        }
        reporter.reportErrorForOffset(code, node.offset, reportLength);
      }
    });
  }
}
