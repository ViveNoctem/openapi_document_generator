import 'package:json_annotation/json_annotation.dart';
import 'package:open_api_spec_builder_generator/src/data_classes/i_spec_node.dart';
import 'package:open_api_spec_builder_generator/src/data_classes/open_api_content.dart';
import 'package:open_api_spec_builder_generator/src/data_classes/open_api_fragment_context.dart';
import 'package:open_api_spec_builder_generator/src/data_classes/open_api_parameter.dart';
import 'package:open_api_spec_builder_generator/src/result/result_of.dart';
import 'package:pub_semver/pub_semver.dart';

part 'open_api_operation.g.dart';

// TODO This class should probably not have the path und httpMethod
@JsonSerializable()
final class const InternOpenApiOperation({
  final Map<int, InternOpenApiResponse>? responses,
  final List<InternOpenApiParameter>? parameters,
}) implements ISpecNode {
  InternOpenApiOperation.withDefault({
    Map<int, InternOpenApiResponse>? responses,
    List<InternOpenApiParameter>? parameters,
  }) : this(
         responses: responses ?? const {},
         parameters: parameters ?? const [],
       );

  factory InternOpenApiOperation.fromJson(Map<String, dynamic> json) =>
      _$InternOpenApiOperationFromJson(json);
  Map<String, dynamic> toJson() => _$InternOpenApiOperationToJson(this);

  @override
  InternOpenApiOperation merge(ISpecNode other) {
    if (other is! InternOpenApiOperation) {
      return this;
    }

    // if both responses are non null merge the results
    // status codes existing in other.responses and not in this.responses are added
    if ((responses, other.responses) case (
      final thisResponses?,
      final otherResponses?,
    ))
      for (final MapEntry(:key, :value) in otherResponses.entries) {
        if (thisResponses.containsKey(key)) {
          continue;
        }

        thisResponses[key] = value;
      }

    return InternOpenApiOperation(
      responses: responses ?? other.responses,
      parameters: parameters ?? other.parameters,
    );
  }

  @override
  ResultOf<void, ValidationErrors> validate(String path) {
    path = path + "/operation";
    final localResponse = responses;

    var validationErrors = ValidationErrors([]);

    if (localResponse != null && localResponse.isEmpty) {
      validationErrors.validations.add(
        ValidationEntry(
          path: path + "/responses",
          error: '"responses" should contain at least one response',
          type: .required,
        ),
      );
    }

    if (parameters case final notNull?) {
      for (final parameter in notNull) {
        final parameterValidation = parameter.validate(path);

        if (parameterValidation case FailureOf<void, ValidationErrors>()) {
          validationErrors = validationErrors.merge(
            parameterValidation.failure,
          );
        }
      }
    }

    if (responses case final notNull?) {
      for (final response in notNull.values) {
        final responseValidation = response.validate(path);

        if (responseValidation case FailureOf<void, ValidationErrors>()) {
          validationErrors = validationErrors.merge(responseValidation.failure);
        }
      }
    }

    if (validationErrors.validations.isNotEmpty) {
      return FailureOf(validationErrors);
    }

    return SuccessOf(null);
  }
}

@JsonSerializable()
final class const InternOpenApiResponse({
  final String? description,
  final Map<String, OpenapiMediaType>? content,
}) implements ISpecNode {
  @override
  ISpecNode merge(ISpecNode other) {
    // TODO: implement merge
    throw UnimplementedError();
  }

  @override
  ResultOf<void, ValidationErrors> validate(String path) {
    path = path + "/response";

    if (description == null &&
        builderContext.openapiVersion < Version(3, 2, 0)) {
      return FailureOf(
        ValidationErrors([
          ValidationEntry.isRequired(path: path, fieldName: "description"),
        ]),
      );
    }

    return SuccessOf(null);
  }

  factory InternOpenApiResponse.fromJson(Map<String, dynamic> json) =>
      _$InternOpenApiResponseFromJson(json);
  Map<String, dynamic> toJson() => _$InternOpenApiResponseToJson(this);
}
