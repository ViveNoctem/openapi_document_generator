import 'package:analyzer/dart/element/type.dart';
import 'package:open_api_spec_builder/open_api_spec_builder.dart';
import 'package:open_api_spec_builder_generator/src/data_classes/open_api_endpoint.dart';
import 'package:open_api_spec_builder_generator/src/data_classes/open_api_parameter.dart';
import 'package:open_api_spec_builder_generator/src/data_classes/open_api_spec.dart';
import 'package:open_api_spec_builder_generator/src/result/result_of.dart';
import 'package:open_api_spec_builder_generator/src/utils/content.utils.dart';
import 'package:open_api_spec_builder_generator/src/utils/type_checkers.dart';
import 'package:source_gen/source_gen.dart';

class const AnnotationReader({
  final TypeCheckers typeCheckers = const TypeCheckers(),
  final ContentUtils contentUtil = const ContentUtils(),
}) {
  // region utils

  String? _readString(ConstantReader reader, String fieldName) {
    final field = reader.peek(fieldName);

    if (field == null || field.isString == false) {
      return null;
    }

    return field.stringValue;
  }

  bool? _readBool(ConstantReader reader, String fieldName) {
    final field = reader.peek(fieldName);

    if (field == null || field.isBool == false) {
      return null;
    }

    return field.boolValue;
  }

  DartType? _readType(ConstantReader reader, String fieldName) {
    final field = reader.peek(fieldName);

    if (field == null || field.isType == false) {
      return null;
    }

    return field.typeValue;
  }
  // endregion

  // region endpoint

  ResultOf<OpenApiPathEntry, void> readOpenApiEndpoints(
    ConstantReader annotation,
  ) {
    final isAnnotation = annotation.instanceOf(
      typeCheckers.getEndpointChecker(),
    );

    if (isAnnotation == false) {
      return FailureOf(null);
    }

    final responses = _readOpenApiEndpointResponses(annotation);

    switch (responses) {
      case FailureOf<Map<int, InternOpenApiResponse>, void>():
        return FailureOf(null);
      case SuccessOf<Map<int, InternOpenApiResponse>, void>():
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

    final apiEndpoint = InternOpenApiEndpoint(responses: responses.data);

    return SuccessOf((path.stringValue, enumHttpMethod, apiEndpoint));
  }

  ResultOf<Map<int, InternOpenApiResponse>, void> _readOpenApiEndpointResponses(
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

    final Map<int, InternOpenApiResponse> responses = {};

    for (final MapEntry(:key, :value) in responsesMap.entries) {
      final keyValue = key?.toIntValue();

      if (keyValue == null) {
        return FailureOf(null);
      }

      final openApiEndpoint = _readOpenApiResponse(ConstantReader(value));

      switch (openApiEndpoint) {
        case FailureOf<InternOpenApiResponse, void>():
          return FailureOf(null);
        case SuccessOf<InternOpenApiResponse, void>():
          break;
      }

      responses[keyValue] = openApiEndpoint.data;
    }

    return SuccessOf(responses);
  }

  ResultOf<InternOpenApiResponse, void> _readOpenApiResponse(
    ConstantReader openApiEndpoint,
  ) {
    final description = openApiEndpoint.peek("description");

    if (description == null || description.isString == false) {
      return FailureOf(null);
    }

    return SuccessOf(
      InternOpenApiResponse(description: description.stringValue),
    );
  }

  // endregion

  // region parameter
  InternOpenApiParameter? readOpenApiParameter(
    ConstantReader openApiParameter,
  ) {
    final ignoreParameter = _readBool(openApiParameter, "ignoreParameter");

    if (ignoreParameter == true) {
      return null;
    }

    final name = _readString(openApiParameter, "name");
    final location = _readParameterLocation(openApiParameter);
    final description = _readString(openApiParameter, "description");
    final required = _readBool(openApiParameter, "required");
    final deprecated = _readBool(openApiParameter, "deprecated");
    final schemaType = _readType(openApiParameter, "schema");
    final schema = contentUtil.getJsonForContentType(schemaType);
    final content = _readString(openApiParameter, "content");

    return InternOpenApiParameter.withDefault(
      name: name,
      location: location,
      deprecated: deprecated,
      required: required,
      description: description,
      content: content,
      schemaType: schemaType,
      schema: schema,
    );
  }

  OpenApiParameterLocation? _readParameterLocation(
    ConstantReader openApiParameter,
  ) {
    final location = openApiParameter.peek("location");

    if (location == null) {
      return null;
    }

    final enumValue = location.peek("value");

    if (enumValue == null || enumValue.isString == false) {
      return null;
    }

    return OpenApiParameterLocation.fromValue(enumValue.stringValue);
  }

  // endregion
}
