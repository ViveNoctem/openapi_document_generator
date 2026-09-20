import 'dart:io';

import 'package:analyzer/dart/element/element.dart';
import 'package:open_api_spec_builder_generator/src/data_classes/open_api_content.dart';
import 'package:open_api_spec_builder_generator/src/data_classes/open_api_fragment_context.dart';
import 'package:open_api_spec_builder_generator/src/data_classes/open_api_operation.dart';
import 'package:open_api_spec_builder_generator/src/data_classes/open_api_parameter.dart';
import 'package:open_api_spec_builder_generator/src/data_classes/open_api_spec.dart';
import 'package:open_api_spec_builder_generator/src/result/result_of.dart';
import 'package:open_api_spec_builder_generator/src/utils/annotation_reader.dart';
import 'package:open_api_spec_builder_generator/src/utils/content.utils.dart';
import 'package:open_api_spec_builder_generator/src/utils/type_checkers.dart';
import 'package:source_gen/source_gen.dart';

/// TODO Should Read Endpoint and Controller annotation to use the default values
class const AnnotationAnalyzer({
  final AnnotationReader annotationReader = const AnnotationReader(),
  final TypeCheckers typeCheckers = const TypeCheckers(),
  final ContentUtils contentUtil = const ContentUtils(),
}) {
  ResultOf<(OpenApiPathEntry, Set<DartTypeJson>), void> readEndpointMethod({
    required AnnotatedElement element,
    required OpenApiFragmentContext context,
  }) {
    if (element.element is! MethodElement &&
        element.element is! TopLevelFunctionElement) {
      return FailureOf(null);
    }

    final openApiEndpoint = _readPathEntry(element: element);
    var dartTypes = <DartTypeJson>{};

    switch (openApiEndpoint) {
      case FailureOf<(OpenApiPathEntry, Set<DartTypeJson>), void>():
        return FailureOf(null);
      case SuccessOf<(OpenApiPathEntry, Set<DartTypeJson>), void>():
        break;
    }

    dartTypes.addAll(openApiEndpoint.data.$2);

    final parameters = _readParameters(
      context: context,
      element: element.element,
    );

    InternOpenApiOperation subvalue;

    switch (parameters) {
      case FailureOf<(List<InternOpenApiParameter>, Set<DartTypeJson>), void>():
        subvalue = openApiEndpoint.data.$1.$3;
      case SuccessOf<(List<InternOpenApiParameter>, Set<DartTypeJson>), void>():
        subvalue = openApiEndpoint.data.$1.$3.merge(
          InternOpenApiOperation(parameters: parameters.data.$1),
        );
        dartTypes.addAll(parameters.data.$2);
    }

    return SuccessOf((
      (openApiEndpoint.data.$1.$1, openApiEndpoint.data.$1.$2, subvalue),
      dartTypes,
    ));
  }

  ResultOf<(OpenApiPathEntry, Set<DartTypeJson>), void> _readPathEntry({
    required AnnotatedElement element,
  }) {
    final annotationEndpoint = annotationReader.readOpenApiEndpoints(
      element.annotation,
    );

    switch (annotationEndpoint) {
      case FailureOf<(String, HttpMethod, InternOpenApiOperation), void>():
        return FailureOf(null);
      case SuccessOf<(String, HttpMethod, InternOpenApiOperation), void>():
        break;
    }

    final inferredEndpoint = _getInferredEndpoint(element: element.element);

    switch (inferredEndpoint) {
      case FailureOf<InternOpenApiOperation, void>():
        return FailureOf(null);
      case SuccessOf<InternOpenApiOperation, void>():
        break;
    }

    final dartTypes = <DartTypeJson>{};

    final result = annotationEndpoint.data.$3.merge(inferredEndpoint.data);

    if (result.responses?.values case final values?) {
      for (final response in values) {
        for (final mediaType
            in response.content?.values ?? <OpenapiMediaType>[]) {
          dartTypes.addAll(_readDarTypesFromContent(mediaType.schema));
        }
      }
    }

    return SuccessOf((
      (annotationEndpoint.data.$1, annotationEndpoint.data.$2, result),
      dartTypes,
    ));
  }

  ResultOf<InternOpenApiOperation, void> _getInferredEndpoint({
    required Element element,
  }) {
    if (element is! FunctionTypedElement) {
      return FailureOf(null);
    }

    final returnType = element.returnType;

    final schemaResult = contentUtil.getOpenApiSchemaForType(
      type: returnType,
      isComponents: false,
    );

    if (schemaResult.$1 != null) {
      final InternOpenApiOperation inferredEndpoint = InternOpenApiOperation(
        responses: {
          HttpStatus.ok: InternOpenApiResponse(
            content: {
              "application/json": OpenapiMediaType(schema: schemaResult.$1),
            },
          ),
        },
      );

      return SuccessOf(inferredEndpoint);
    }

    return SuccessOf(InternOpenApiOperation());
  }

  ResultOf<(List<InternOpenApiParameter>, Set<DartTypeJson>), void>
  _readParameters({
    required OpenApiFragmentContext context,
    required Element element,
  }) {
    if (element is! FunctionTypedElement) {
      return FailureOf(null);
    }

    final result = <InternOpenApiParameter>[];
    final componentSchemas = <DartTypeJson>{};

    for (final parameter in element.formalParameters) {
      if (context.options.apiLibrary == .dartFrog) {
        // Skip RequestContext if DartFrog is used
        if (typeCheckers.getDartFrogRequestContextChecker().isExactlyType(
          parameter.type,
        )) {
          continue;
        }
      }

      final parameterAnnotation = typeCheckers
          .getParameterChecker()
          .firstAnnotationOf(parameter, throwOnUnresolved: false);

      final schema = contentUtil.getOpenApiSchemaForType(
        type: parameter.type,
        isComponents: false,
      );

      final inferredValues = InternOpenApiParameter(
        name: parameter.displayName,
        location: null,
        required: parameter.isRequired,
        schema: schema.$1,
        // deprecated:
        // description:
      );

      final annotationValues = annotationReader.readOpenApiParameter(
        ConstantReader(parameterAnnotation),
      );

      // is only null if ignored is true
      if (annotationValues == null) {
        continue;
      }

      final merged = annotationValues.merge(inferredValues);

      componentSchemas.addAll(_readDarTypesFromContent(merged.schema));

      result.add(merged);
    }

    return SuccessOf((result, componentSchemas));
  }

  Set<DartTypeJson> _readDarTypesFromContent(OpenApiSchemaContent? schema) {
    final result = <DartTypeJson>{};
    if (schema case OpenApiSchemaContent(
      dartType: final schemaType,
      type: .object,
    )) {
      // add dartType of schema to components
      if (schemaType?.element case Element(
        library: final library?,
        name: final name?,
      )) {
        result.add((
          uri: library.firstFragment.source.uri.toString(),
          className: name,
        ));
      }

      // add dartTypes of properties to components
      if (schema.properties?.values case final values?) {
        for (final value in values) {
          if (value case OpenApiSchemaContent(
            dartType: final propertyType,
            type: .object,
          )) {
            if (propertyType?.element case Element(
              library: final library?,
              name: final name?,
            )) {
              result.add((
                uri: library.firstFragment.source.uri.toString(),
                className: name,
              ));
            }
          }
        }
      }
    }

    return result;
  }
}
