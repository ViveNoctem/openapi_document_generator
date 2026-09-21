import 'package:analyzer/dart/element/type.dart';
import 'package:openapi_document_annotation/openapi_document_annotation.dart';
import 'package:openapi_document_generator/src/data_classes/open_api_document.dart';
import 'package:openapi_document_generator/src/data_classes/open_api_operation.dart';
import 'package:openapi_document_generator/src/data_classes/open_api_parameter.dart';
import 'package:openapi_document_generator/src/data_classes/openapi_controller.dart';
import 'package:openapi_document_generator/src/result/result_of.dart';
import 'package:openapi_document_generator/src/utils/content.utils.dart';
import 'package:openapi_document_generator/src/utils/type_checkers.dart';
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

  ConstantReader? _readObject(ConstantReader reader, String fieldName) {
    final field = reader.peek(fieldName);

    if (field == null || field.isNull) return null;

    return ConstantReader(field.objectValue);
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

    final apiEndpoint = InternOpenApiOperation(responses: responses.data);

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
    final schema = contentUtil.getOpenApiSchemaForType(
      type: schemaType,
      isComponents: false,
    );
    // TODO remove !
    final (String, String)? schemaImportUri;

    if (schemaType != null) {
      schemaImportUri = (
        schemaType.element!.library!.firstFragment.source.uri.toString(),
        schemaType.element!.name!,
      );
    } else {
      schemaImportUri = null;
    }

    final content = _readString(openApiParameter, "content");

    return InternOpenApiParameter.withDefault(
      name: name,
      location: location,
      deprecated: deprecated,
      required: required,
      description: description,
      content: content,
      schemaImportUri: schemaImportUri,
      schema: schema.$1,
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

  // region Controller
  InternOpenapiController readOpenApiController(ConstantReader reader) {
    final summary = _readString(reader, "summary");
    final basePath = _readString(reader, "basePath");
    final shelfRouter = _readObject(reader, "shelfRouter");
    final responses = _readOpenApiEndpointResponses(reader);
    final Map<int, InternOpenApiResponse>? responseValue;
    switch (responses) {
      case FailureOf<Map<int, InternOpenApiResponse>, void>():
        responseValue = null;
      case SuccessOf<Map<int, InternOpenApiResponse>, void>():
        responseValue = responses.data;
    }

    return InternOpenapiController(
      summary: summary,
      basePath: basePath,
      responses: responseValue,
      shelfRouter: shelfRouter,
    );
  }
  // endregion
}
