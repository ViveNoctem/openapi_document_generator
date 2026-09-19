import 'package:json_annotation/json_annotation.dart';
import 'package:open_api_spec_builder_generator/src/data_classes/i_spec_node.dart';
import 'package:open_api_spec_builder_generator/src/data_classes/open_api_parameter.dart';
import 'package:open_api_spec_builder_generator/src/result/result_of.dart';

part 'open_api_endpoint.g.dart';

// TODO This class should probably not have the path und httpMethod
@JsonSerializable()
final class const InternOpenApiEndpoint({
  final Map<int, InternOpenApiResponse>? responses,
  final List<InternOpenApiParameter>? parameters,
}) implements ISpecNode {
  InternOpenApiEndpoint.withDefault({
    Map<int, InternOpenApiResponse>? responses,
    List<InternOpenApiParameter>? parameters,
  }) : this(
         responses: responses ?? const {},
         parameters: parameters ?? const [],
       );

  factory InternOpenApiEndpoint.fromJson(Map<String, dynamic> json) =>
      _$OpenApiEndpointFromJson(json);
  Map<String, dynamic> toJson() => _$OpenApiEndpointToJson(this);

  @override
  InternOpenApiEndpoint merge(ISpecNode other) {
    if (other is! InternOpenApiEndpoint) {
      return this;
    }

    return InternOpenApiEndpoint(
      responses: responses ?? other.responses,
      parameters: parameters ?? other.parameters,
    );
  }

  @override
  ResultOf<void, ValidationErrors> validate(String path) {
    path = path + "/endpoint";
    final localResponse = responses;

    var validationErrors = ValidationErrors([]);

    if (localResponse == null || localResponse.isEmpty) {
      validationErrors.validations.add(
        ValidationEntry(path: path, error: "field 'responses' can't be empty"),
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

    if (validationErrors.validations.isNotEmpty) {
      return FailureOf(validationErrors);
    }

    return SuccessOf(null);
  }
}

@JsonSerializable()
final class const InternOpenApiResponse({required final String description}) {
  factory InternOpenApiResponse.fromJson(Map<String, dynamic> json) =>
      _$OpenApiResponseFromJson(json);
  Map<String, dynamic> toJson() => _$OpenApiResponseToJson(this);
}
