import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/token.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

import '../../pyramid_lint_rule.dart';

class NewlineAfterVar extends PyramidLintRule {
  NewlineAfterVar({required super.options})
      : super(
          name: ruleName,
          problemMessage:
              'Expected blank line after variable declarations',
          correctionMessage:
              'Add a blank line',
          url: url,
          errorSeverity: ErrorSeverity.WARNING,
        );

  static const ruleName = 'newline_after_var';
  static const url = '';

  factory NewlineAfterVar.fromConfigs(CustomLintConfigs configs) {
    final json = configs.rules[ruleName]?.json ?? {};
    final options = PyramidLintRuleOptions.fromJson(
      json: json,
      paramsConverter: (_) => null,
    );

    return NewlineAfterVar(options: options);
  }

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    final statements = <Statement>[];
    
    context.registry.addStatement(statements.add);
    context.registry.addVariableDeclarationStatement((node) {
      final nextToken = node.endToken.next;
      
      if (nextToken is Declaration || nextToken == null) return;

      final lineInfo = resolver.lineInfo;
      final currentTokenLine = lineInfo.getLocation(node.offset).lineNumber;
      final nextTokenLine = lineInfo.getLocation(nextToken.offset).lineNumber;

      if (nextTokenLine - currentTokenLine == 1) {
        reporter.reportErrorForOffset(code, node.offset, node.length);
      }
    });
    // context.addPostRunCallback(() {
    //   final lineInfo = resolver.lineInfo;
    //   bool previousWasDeclaration = false;
    //   int? previousOffset;
      
    //   for(final statement in statements) {
    //     if (statement is VariableDeclarationStatement) {
    //       previousWasDeclaration = true;
    //       continue;
    //     }
    //     if (!previousWasDeclaration || previousOffset == null) {
    //       previousOffset = statement.offset;
    //       continue;
    //     }
    //     final previousLine = lineInfo.getLocation(previousOffset).lineNumber;
    //     final currentLine = lineInfo.getLocation(statement.offset).lineNumber;

    //     if (currentLine - previousLine == 1) {
    //       reporter.reportErrorForOffset(code, statement.offset, statement.length);
    //     }

    //     previousWasDeclaration = false;
    //     previousOffset = statement.offset;
    //   }
    // });
  }

  @override
  List<Fix> getFixes() => [_AddNewlineAfterVar()];
}

class _AddNewlineAfterVar extends DartFix {
  @override
  void run(
    CustomLintResolver resolver,
    ChangeReporter reporter,
    CustomLintContext context,
    AnalysisError analysisError,
    List<AnalysisError> others,
  ) {
    context.registry.addReturnStatement((node) {
      if (!analysisError.sourceRange.intersects(node.sourceRange)) return;

      final nextToken = node.endToken.next;

      if (nextToken == null) return;

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
