import 'package:open_api_spec_builder_generator/src/builder/type_checkers.dart';
import 'package:open_api_spec_builder_generator/src/data_classes/open_api_endpoint.dart';
import 'package:open_api_spec_builder_generator/src/data_classes/open_api_spec.dart';
import 'package:open_api_spec_builder_generator/src/result/result_of.dart';
import 'package:source_gen/source_gen.dart';

class const AnnotationReader({
  final TypeCheckers typeCheckers = const TypeCheckers(),
}) {
  ResultOf<OpenApiPathEnty, void> readOpenApiEndpoints(
    AnnotatedElement annotatedElement,
  ) {
    final annotation = annotatedElement.annotation;
    final isAnnotation = annotation.instanceOf(
      typeCheckers.getEndpointChecker(),
    );

    if (isAnnotation == false) {
      return FailureOf(null);
    }

    final responses = _readOpenApiEndpointResponses(annotation);

    switch (responses) {
      case FailureOf<Map<int, OpenApiResponse>, void>():
        return FailureOf(null);
      case SuccessOf<Map<int, OpenApiResponse>, void>():
        break;
    }

    final path = annotation.read("path");

    if (path.isString == false) {
      return FailureOf(null);
    }

    final httpMethod = annotation.read("httpMethod");

    if (httpMethod.isString == false) {
      return FailureOf(null);
    }

    final enumHttpMethod = HttpMethod.fromString(httpMethod.stringValue);

    if (enumHttpMethod == null) {
      return FailureOf(null);
    }

    final apiEndpoint = OpenApiEndpoint(responses: responses.data);

    return SuccessOf(MapEntry(path.stringValue, {enumHttpMethod: apiEndpoint}));
  }

  ResultOf<Map<int, OpenApiResponse>, void> _readOpenApiEndpointResponses(
    ConstantReader openApiEndpoint,
  ) {
    final responsesField = openApiEndpoint.peek("responses");

    if (responsesField == null) {
      return FailureOf(null);
    }

    if (responsesField.isMap == false) {
      return FailureOf(null);
    }

    final responsesMap = responsesField.mapValue;

    final Map<int, OpenApiResponse> responses = {};

    for (final MapEntry(:key, :value) in responsesMap.entries) {
      final keyValue = key?.toIntValue();

      if (keyValue == null) {
        return FailureOf(null);
      }

      final openApiEndpoint = _readOpenApiResponse(ConstantReader(value));

      switch (openApiEndpoint) {
        case FailureOf<OpenApiResponse, void>():
          return FailureOf(null);
        case SuccessOf<OpenApiResponse, void>():
          break;
      }

      responses[keyValue] = openApiEndpoint.data;
    }

    return SuccessOf(responses);
  }

  ResultOf<OpenApiResponse, void> _readOpenApiResponse(
    ConstantReader openApiEndpoint,
  ) {
    final description = openApiEndpoint.peek("description");

    if (description == null || description.isString == false) {
      return FailureOf(null);
    }

    return SuccessOf(OpenApiResponse(description: description.stringValue));
  }
}
