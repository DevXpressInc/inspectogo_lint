// This is the entrypoint of our custom linter

import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:meta/meta.dart';

import '../../pyramid_lint_rule.dart';
import '../../utils/typedef.dart';

@immutable
class MaxLengthOptions {
  final int code;
  final int comments;
  final bool ignoreComments;
  
  const MaxLengthOptions({
    int? code,
    int? comments,
    bool? ignoreComments,
  })
  : code = code ?? 80,
    comments = comments ?? code ?? 80,
    ignoreComments = ignoreComments ?? false;

  factory MaxLengthOptions.fromJson(Json json) {
    final code = switch (json['code']) {
      final int code => code,
      _ => null,
    };

    final comments = switch (json['comments']) {
      final int comments => comments,
      _ => null,
    };

    final ignoreComments = switch (json['ignore_comments']) {
      final bool ignoreComments => ignoreComments,
      _ => null,
    };

    return MaxLengthOptions(
      code: code,
      comments: comments,
      ignoreComments: ignoreComments,
    );
  }
}

class MaxLength extends PyramidLintRule<MaxLengthOptions> {

  MaxLength({required super.options}) : super(
    name: ruleName,
    problemMessage: 'Avoid lines longer than ${options.params.code} characters.',
    correctionMessage: '',
    url: '',
    errorSeverity: ErrorSeverity.WARNING,
  );

  factory MaxLength.fromConfigs(CustomLintConfigs configs) {
    final json = configs.rules[ruleName]?.json ?? {};
    final options = PyramidLintRuleOptions.fromJson(
      json: json,
      paramsConverter: MaxLengthOptions.fromJson,
    );

    return MaxLength(options: options);
  }

  static const String ruleName = 'max_length';

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    // Our lint will highlight all variable declarations with our custom warning.
    context.registry.addStatement((node) {
      if (node.length <= options.params.code) return;

      if (node.endToken is Comment) return;

      final length = node.length - options.params.code;
      final offset = node.offset + options.params.code;

      // reporter.atOffset(
      //   errorCode: code,
      //   offset: offset,
      //   length: length,
      // );
      reporter.reportErrorForOffset(
        code,
        offset,
        length,
      );
    });
  }
}
