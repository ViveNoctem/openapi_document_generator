import 'package:open_api_spec_builder_generator/src/result/result_of.dart';

abstract interface class ISpecNode {
  ISpecNode merge(ISpecNode other);
  ResultOf<void, ValidationErrors> validate(String path);
}

class const ValidationEntry({
  required final String path,
  required final String error,
}) {}

class const ValidationErrors(final List<ValidationEntry> validations)
    implements ISpecNode {
  @override
  ValidationErrors merge(ISpecNode other) {
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
