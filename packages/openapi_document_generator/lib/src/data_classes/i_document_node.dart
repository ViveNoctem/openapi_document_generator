import 'package:openapi_document_generator/src/result/result_of.dart';

abstract interface class IDocumentNode {
  IDocumentNode merge(IDocumentNode other);
  ResultOf<void, ValidationErrors> validate(String path);
}

class const ValidationEntry({
  required final String path,
  required final String error,
  final ValidationErrorType type = .unknown,
}) {
  ValidationEntry.isRequired({required String path, required String fieldName})
    : this(
        path: path + "/$fieldName",
        error: 'Field "$fieldName" is required',
        type: .required,
      );
}

class const ValidationErrors(final List<ValidationEntry> validations)
    implements IDocumentNode {
  @override
  ValidationErrors merge(IDocumentNode other) {
    if (other is! ValidationErrors) {
      return this;
    }

    return ValidationErrors([...validations, ...other.validations]);
  }

  @override
  ResultOf<void, ValidationErrors> validate(String path) {
    throw UnimplementedError();
  }
}

enum ValidationErrorType { required, expectedUri, malformedField, unknown }
