import 'dart:isolate';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';


import '../../pyramid_lint_rule.dart';
import '../../utils/lint_code_extension.dart';

class DebugFindVmUri extends PyramidLintRule {
  DebugFindVmUri({required super.options})
      : super(
          name: ruleName,
          problemMessage:
              'Find the Service VM uri of the analyzer',
          correctionMessage: '',
          url: url,
          errorSeverity: ErrorSeverity.INFO,
        );

  static const ruleName = 'debug_find_vm_uri';
  static const url = '';

  factory DebugFindVmUri.fromConfigs(CustomLintConfigs configs) {
    final json = configs.rules[ruleName]?.json ?? {};
    final options = PyramidLintRuleOptions.fromJson(
      json: json,
      paramsConverter: (_) => null,
    );

    return DebugFindVmUri(options: options);
  }

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {  
    printPackageConfig(reporter);
  }

  Future<void> printPackageConfig(ErrorReporter reporter) async {
    final uri = await Isolate.packageConfig;
    reporter.reportErrorForOffset(code.copyWith(correctionMessage: uri.toString()), 0, 1);
    reporter.reportErrorForOffset(code.copyWith(correctionMessage: Isolate.current.debugName), 0, 1);
    reporter.reportErrorForOffset(code.copyWith(correctionMessage: Isolate.current.controlPort.toString()), 0, 1);
  }
  
}
