import 'package:openapi_document_generator/src/data_classes/i_document_node.dart';
import 'package:openapi_document_generator/src/data_classes/open_api_document.dart';
import 'package:openapi_document_generator/src/result/result_of.dart';
import 'package:test/test.dart';

void runSuccessfulValidation({
  required IDocumentNode node,
  required String path,
}) {
  final result = node.validate(path);

  switch (result) {
    case FailureOf<void, ValidationErrors>():
      String failure =
          "${node.runtimeType}.validate was expected to be successful, but failed\n";
      for (final error in result.failure.validations) {
        failure += error.error;
        failure += "\n";
      }

      throw TestFailure(failure);
    case SuccessOf<void, ValidationErrors>():
      break;
  }
}

ValidationErrors runFailingValidation({
  required IDocumentNode node,
  required String path,
}) {
  final result = node.validate(path);

  switch (result) {
    case FailureOf<void, ValidationErrors>():
      return result.failure;
    case SuccessOf<void, ValidationErrors>():
      throw TestFailure(
        "${node.runtimeType}.validate was expected to fail, but was successful",
      );
  }
}

// mimimal viable OpenapiSpec
const OpenapiDocument mvOpenApiSpec = OpenapiDocument(
  openapi: .openApi320,
  info: OpenapiInfo(title: "title", version: "version"),
);

bool checkValidationError({
  ValidationErrorType? type,
  String? path,
  String? error,
  required ValidationEntry entry,
}) {
  if (type != null) expect(entry.type, type);
  if (path != null) expect(entry.path, path);
  if (error != null) expect(entry.error, error);
  return true;
}

class const ValidationMatcher({
  final ValidationErrorType? type,
  final String? path,
  final String? error,
}) extends Matcher {
  @override
  Description describe(Description description) {
    if (type != null) description = description.add("type: $type");
    if (path != null) description = description.add("path: $path");
    if (error != null) description = description.add("error: $error");

    return description;
  }

  @override
  bool matches(dynamic item, Map<dynamic, dynamic> matchState) {
    if (item is! ValidationEntry) {
      return false;
    }

    bool failed = false;

    if (type != null && type != item.type) {
      matchState["type"] = "expected $type but got ${item.type}";
      failed = true;
    }

    if (path != null && path != item.path) {
      matchState["path"] = "expected $path but got ${item.path}";
      failed = true;
    }

    if (error != null && error != item.error) {
      matchState["error"] = "expected $error but got ${item.error}";
      failed = true;
    }

    if (failed) {
      return false;
    }

    return true;
  }

  @override
  Description describeMismatch(
    dynamic item,
    Description mismatchDescription,
    Map matchState,
    bool verbose,
  ) {
    if (matchState["type"] case final value?)
      mismatchDescription = mismatchDescription.add(value);
    if (matchState["path"] case final value?)
      mismatchDescription = mismatchDescription.add(value);
    if (matchState["error"] case final value?)
      mismatchDescription = mismatchDescription.add(value);
    return mismatchDescription;
  }
}
