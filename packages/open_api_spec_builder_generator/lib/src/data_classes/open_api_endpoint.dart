import 'package:json_annotation/json_annotation.dart';
import 'package:open_api_spec_builder_generator/src/data_classes/i_spec_node.dart';
import 'package:open_api_spec_builder_generator/src/data_classes/open_api_content.dart';
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
      _$InternOpenApiEndpointFromJson(json);
  Map<String, dynamic> toJson() => _$InternOpenApiEndpointToJson(this);

  @override
  InternOpenApiEndpoint merge(ISpecNode other) {
    if (other is! InternOpenApiEndpoint) {
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
final class const InternOpenApiResponse({
  final String? description,
  final OpenApiSchemaContent? schema,
  final Map<String, OpenApiContent>? content,
}) implements ISpecNode {
  @override
  ISpecNode merge(ISpecNode other) {
    // TODO: implement merge
    throw UnimplementedError();
  }

  @override
  ResultOf<void, ValidationErrors> validate(String path) {
    path = path + "/response";
    if (description == null) {
      return FailureOf(
        ValidationErrors([
          ValidationEntry(
            path: path,
            error: "description is required for all responses",
          ),
        ]),
      );
    }

    return SuccessOf(null);
  }

  factory InternOpenApiResponse.fromJson(Map<String, dynamic> json) =>
      _$InternOpenApiResponseFromJson(json);
  Map<String, dynamic> toJson() => _$InternOpenApiResponseToJson(this);
}
